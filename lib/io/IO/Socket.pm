# IO::Socket.pm
#
# Copyright (c) 1996 Graham Barr <gbarr@pobox.com>. All rights
# reserved. This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package IO::Socket;

require 5.000;

use Config;
use IO::Handle;
use Socket 1.3;
use Carp;
use strict;
use vars qw(@ISA $VERSION);
use Exporter;

# legacy

require IO::Socket::INET;
require IO::Socket::UNIX;

@ISA = qw(IO::Handle);

$VERSION = "1.21";

sub import {
    my $pkg = shift;
    my $callpkg = caller;
    Exporter::export 'Socket', $callpkg, @_;
}

sub new {
    my($class,%arg) = @_;
    my $sock = $class->SUPER::new();

    $sock->autoflush(1);

    ${*$sock}{'io_socket_timeout'} = delete $arg{Timeout};

    return scalar(%arg) ? $sock->configure(\%arg)
			: $sock;
}

my @domain2pkg = ();

sub register_domain {
    my($p,$d) = @_;
    $domain2pkg[$d] = $p;
}

sub configure {
    my($sock,$arg) = @_;
    my $domain = delete $arg->{Domain};

    croak 'IO::Socket: Cannot configure a generic socket'
	unless defined $domain;

    croak "IO::Socket: Unsupported socket domain"
	unless defined $domain2pkg[$domain];

    croak "IO::Socket: Cannot configure socket in domain '$domain'"
	unless ref($sock) eq "IO::Socket";

    bless($sock, $domain2pkg[$domain]);
    $sock->configure($arg);
}

sub socket {
    @_ == 4 or croak 'usage: $sock->socket(DOMAIN, TYPE, PROTOCOL)';
    my($sock,$domain,$type,$protocol) = @_;

    socket($sock,$domain,$type,$protocol) or
    	return undef;

    ${*$sock}{'io_socket_domain'} = $domain;
    ${*$sock}{'io_socket_type'}   = $type;
    ${*$sock}{'io_socket_proto'}  = $protocol;

    $sock;
}

sub socketpair {
    @_ == 4 || croak 'usage: IO::Socket->pair(DOMAIN, TYPE, PROTOCOL)';
    my($class,$domain,$type,$protocol) = @_;
    my $sock1 = $class->new();
    my $sock2 = $class->new();

    socketpair($sock1,$sock2,$domain,$type,$protocol) or
    	return ();

    ${*$sock1}{'io_socket_type'}  = ${*$sock2}{'io_socket_type'}  = $type;
    ${*$sock1}{'io_socket_proto'} = ${*$sock2}{'io_socket_proto'} = $protocol;

    ($sock1,$sock2);
}

sub connect {
    @_ == 2 || @_ == 3 or
	croak 'usage: $sock->connect(NAME) or $sock->connect(PORT, ADDR)';
    my $sock = shift;
    my $addr = @_ == 1 ? shift : sockaddr_in(@_);
    my $timeout = ${*$sock}{'io_socket_timeout'};

    eval {
	my $blocking = 0;

    	croak 'connect: Bad address'
    	    if(@_ == 2 && !defined $_[1]);

	$blocking = $sock->blocking(0)
	    if($timeout);

	unless(connect($sock, $addr)) {
	    if($timeout && ($! == &IO::EINPROGRESS)) {
		require IO::Select;

		my $sel = new IO::Select $sock;

		$sock->blocking(1)
		    if($blocking);

		unless($sel->can_write($timeout) && defined($sock->peername)) {
		    undef $sock;
		    croak "connect: timeout";
		}
	    }
	    else {
		undef $sock;
		croak "connect: $!";
	    }
	}
	$sock->blocking(1)
	    if($sock && $blocking);
    };

    $sock;
}

sub bind {
    @_ == 2 || @_ == 3 or
	croak 'usage: $sock->bind(NAME) or $sock->bind(PORT, ADDR)';
    my $sock = shift;
    my $addr = @_ == 1 ? shift : sockaddr_in(@_);

    return bind($sock, $addr) ? $sock
			      : undef;
}

sub listen {
    @_ >= 1 && @_ <= 2 or croak 'usage: $sock->listen([QUEUE])';
    my($sock,$queue) = @_;
    $queue = 5
	unless $queue && $queue > 0;

    return listen($sock, $queue) ? $sock
				 : undef;
}

sub accept {
    @_ == 1 || @_ == 2 or croak 'usage $sock->accept([PKG])';
    my $sock = shift;
    my $pkg = shift || $sock;
    my $timeout = ${*$sock}{'io_socket_timeout'};
    my $new = $pkg->new(Timeout => $timeout);
    my $peer = undef;

    eval {
    	if($timeout) {
	    require IO::Select;

	    my $sel = new IO::Select $sock;

    	    croak "accept: timeout"
    	    	unless $sel->can_read($timeout);
    	}
    	$peer = accept($new,$sock);
    };

    return wantarray ? defined $peer ? ($new, $peer)
    	    	    	    	     : () 
    	      	     : defined $peer ? $new
    	    	    	    	     : undef;
}

sub sockname {
    @_ == 1 or croak 'usage: $sock->sockname()';
    getsockname($_[0]);
}

sub peername {
    @_ == 1 or croak 'usage: $sock->peername()';
    my($sock) = @_;
    getpeername($sock)
      || ${*$sock}{'io_socket_peername'}
      || undef;
}

sub send {
    @_ >= 2 && @_ <= 4 or croak 'usage: $sock->send(BUF, [FLAGS, [TO]])';
    my $sock  = $_[0];
    my $flags = $_[2] || 0;
    my $peer  = $_[3] || $sock->peername;

    croak 'send: Cannot determine peer address'
	 unless($peer);

    my $r = defined(getpeername($sock))
	? send($sock, $_[1], $flags)
	: send($sock, $_[1], $flags, $peer);

    # remember who we send to, if it was sucessful
    ${*$sock}{'io_socket_peername'} = $peer
	if(@_ == 4 && defined $r);

    $r;
}

sub recv {
    @_ == 3 || @_ == 4 or croak 'usage: $sock->recv(BUF, LEN [, FLAGS])';
    my $sock  = $_[0];
    my $len   = $_[2];
    my $flags = $_[3] || 0;

    # remember who we recv'd from
    ${*$sock}{'io_socket_peername'} = recv($sock, $_[1]='', $len, $flags);
}

sub shutdown {
    @_ == 2 or croak 'usage: $sock->shutdown(HOW)';
    my($sock, $how) = @_;
    shutdown($sock, $how);
}

sub setsockopt {
    @_ == 4 or croak '$sock->setsockopt(LEVEL, OPTNAME)';
    setsockopt($_[0],$_[1],$_[2],$_[3]);
}

my $intsize = length(pack("i",0));

sub getsockopt {
    @_ == 3 or croak '$sock->getsockopt(LEVEL, OPTNAME)';
    my $r = getsockopt($_[0],$_[1],$_[2]);
    # Just a guess
    $r = unpack("i", $r)
	if(defined $r && length($r) == $intsize);
    $r;
}

sub sockopt {
    my $sock = shift;
    @_ == 1 ? $sock->getsockopt(SOL_SOCKET,@_)
	    : $sock->setsockopt(SOL_SOCKET,@_);
}

sub timeout {
    @_ == 1 || @_ == 2 or croak 'usage: $sock->timeout([VALUE])';
    my($sock,$val) = @_;
    my $r = ${*$sock}{'io_socket_timeout'} || undef;

    ${*$sock}{'io_socket_timeout'} = 0 + $val
	if(@_ == 2);

    $r;
}

sub sockdomain {
    @_ == 1 or croak 'usage: $sock->sockdomain()';
    my $sock = shift;
    ${*$sock}{'io_socket_domain'};
}

sub socktype {
    @_ == 1 or croak 'usage: $sock->socktype()';
    my $sock = shift;
    ${*$sock}{'io_socket_type'}
}

sub protocol {
    @_ == 1 or croak 'usage: $sock->protocol()';
    my($sock) = @_;
    ${*$sock}{'io_socket_protocol'};
}

1;

__END__

=head1 NAME

IO::Socket - Object interface to socket communications

=head1 SYNOPSIS

    use IO::Socket;

=head1 DESCRIPTION

C<IO::Socket> provides an object interface to creating and using sockets. It
is built upon the L<IO::Handle> interface and inherits all the methods defined
by L<IO::Handle>.

C<IO::Socket> only defines methods for those operations which are common to all
types of socket. Operations which are specified to a socket in a particular 
domain have methods defined in sub classes of C<IO::Socket>

C<IO::Socket> will export all functions (and constants) defined by L<Socket>.

=head1 CONSTRUCTOR

=over 4

=item new ( [ARGS] )

Creates an C<IO::Socket>, which is a reference to a
newly created symbol (see the C<Symbol> package). C<new>
optionally takes arguments, these arguments are in key-value pairs.
C<new> only looks for one key C<Domain> which tells new which domain
the socket will be in. All other arguments will be passed to the
configuration method of the package for that domain, See below.

 NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
 
As of VERSION 1.18 all IO::Socket objects have autoflush turned on
by default. This was not the case with earlier releases.

 NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE

=back

=head1 METHODS

See L<perlfunc> for complete descriptions of each of the following
supported C<IO::Socket> methods, which are just front ends for the
corresponding built-in functions:

    socket
    socketpair
    bind
    listen
    accept
    send
    recv
    peername (getpeername)
    sockname (getsockname)
    shutdown

Some methods take slightly different arguments to those defined in L<perlfunc>
in attempt to make the interface more flexible. These are

=over 4

=item accept([PKG])

perform the system call C<accept> on the socket and return a new object. The
new object will be created in the same class as the listen socket, unless
C<PKG> is specified. This object can be used to communicate with the client
that was trying to connect. In a scalar context the new socket is returned,
or undef upon failure. In an array context a two-element array is returned
containing the new socket and the peer address, the list will
be empty upon failure.

Additional methods that are provided are

=item timeout([VAL])

Set or get the timeout value associated with this socket. If called without
any arguments then the current setting is returned. If called with an argument
the current setting is changed and the previous value returned.

=item sockopt(OPT [, VAL])

Unified method to both set and get options in the SOL_SOCKET level. If called
with one argument then getsockopt is called, otherwise setsockopt is called.

=item sockdomain

Returns the numerical number for the socket domain type. For example, for
a AF_INET socket the value of &AF_INET will be returned.

=item socktype

Returns the numerical number for the socket type. For example, for
a SOCK_STREAM socket the value of &SOCK_STREAM will be returned.

=item protocol

Returns the numerical number for the protocol being used on the socket, if
known. If the protocol is unknown, as with an AF_UNIX socket, zero
is returned.

=back

=head1 SEE ALSO

L<Socket>, L<IO::Handle>, L<IO::Socket::INET>, L<IO::Socket::UNIX>

=head1 AUTHOR

Graham Barr E<lt>F<gbarr@pobox.com>E<gt>

=head1 COPYRIGHT

Copyright (c) 1996 Graham Barr. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut