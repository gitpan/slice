##
##  slice_setup.pl -- Command line parsing and CFG setup
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package main;

sub usage {
    print STDERR "Usage: slice [options] [file]\n";
    print STDERR "\n";
    print STDERR "Options:\n";
    print STDERR "  -o, --outputfile=FILESPEC  create output file(s)\n";
    print STDERR "  -v, --verbose              enable verbose mode\n";
    print STDERR "  -V, --version              display version string\n";
    print STDERR "  -h, --help                 display usage page\n";
    print STDERR "\n";
    print STDERR "FILESPEC format:\n";
    print STDERR "\n";
    print STDERR "  [SLICETERM:]PATH[\@CHMODOPT]\n";
    print STDERR "\n";
    print STDERR "  SLICETERM ..... a set-theory term describing the slices\n";
    print STDERR "  PATH .......... a filesystem path to the outputfile\n";
    print STDERR "  CHMODOPT ...... permission change options for 'chmod'\n";
    print STDERR "\n";
    exit(1);
}

sub hello {
    print STDERR "$Vers::SLICE_Hello\n";
    print STDERR <<'EOT';
Copyright (c) 1996-1997 Ralf S. Engelschall, All Rights Reserved.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
EOT
    exit(0);
}

sub setup {
    my ($CFG) = @_;

    #   parse command line options
    $opt_h = 0;
    $opt_V = 0;
    $opt_v = 0;
    @opt_o = ();
    $SIG{'__WARN__'} = sub { 
        print STDERR "Slice:Error: $_[0]";
    };
    $Getopt::Long::bundling = 1;
    $Getopt::Long::getopt_compat = 0;
    if (not Getopt::Long::GetOptions("v|verbose",
                                     "V|version",
                                     "h|help",
                                     "o|outputfile=s@")) {
        print STDERR "Try `$0 --help' for more information.\n";
        exit(0);
    }
    $SIG{'__WARN__'} = undef;
    &usage($0) if ($opt_h);
    &hello() if ($opt_V);

    #   process command line arguments and
    #   read input file
    if (($#ARGV == 0 and $ARGV[0] eq '-') or $#ARGV == -1) {
        $fp = new IO::Handle;
        $fp->fdopen(fileno(STDIN), "r");
        local ($/) = undef;
        $INPUT = <$fp>;
        $fp->close;
    }
    elsif ($#ARGV == 0) {
        $fp = new IO::File;
        $fp->open($ARGV[0]);
        local ($/) = undef;
        $INPUT = <$fp>;
        $fp->close;
    }
    else {
        &usage;
    }

    #   add additional options
    $INPUT =~ s|^%!slice\s+(.*?)\n|push(@ARGV, split(' ', $1)), ''|egim;
    if (not Getopt::Long::GetOptions("x|debug",
                                     "v|version",
                                     "o|outputfile=s@")) {
        &usage;
    }
    if ($#opt_o == -1) {
        @opt_o = ( "ALL:-" ); # default is all on stdout
    }

    #   setup the $CFG hash
    $CFG->{INPUT} = {};
    $CFG->{INPUT}->{SRC}   = $INPUT;  # original source
    $CFG->{INPUT}->{PLAIN} = '';      # source without slice delimiters
    $CFG->{OPT} = {};    
    $CFG->{OPT}->{X} = $opt_v;        # option -v
    $CFG->{OPT}->{O} = [ @opt_o ];    # options -o
    $CFG->{SLICE} = {};
    $CFG->{SLICE}->{SET} = {};       
    $CFG->{SLICE}->{SET}->{ASC} = {}; # slice set, represented in ASCII
    $CFG->{SLICE}->{SET}->{OBJ} = {}; # slice set, represented as Bit::Vector object
    $CFG->{SLICE}->{MINLEVELS} = {};  # slice min levels
    $CFG->{SLICE}->{MAXLEVEL}  = 0;   # maximum slice level
}

1;
##EOF##
