##
##  slice_setup.pl -- Command line parsing and CFG setup
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package main;

sub usage {
    print STDERR "Usage: slice [options] [file]\n";
    print STDERR "   where options are\n";
    print STDERR "   -o [sliceterm:]file[\@chmodopt]  create output file\n";
    print STDERR "   -x                              verbose/debug mode\n";
    print STDERR "   -v                              version string\n";
    exit(1);
}

sub hello {
    print STDERR "$Vers::SLICE_Hello\n";
    exit(0);
}

sub setup {
    my ($CFG) = @_;

    #   parse command line options
    $Getopt::Long::bundling = 1;
    $opt_x = 0;
    $opt_v = 0;
    @opt_o = ();
    if (not Getopt::Long::GetOptions("x|debug",
                                     "v|version",
                                     "o|outputfile=s@")) {
        &usage;
    }
    if ($opt_v) {
        &hello;
    }
    if ($#opt_o == -1) {
        @opt_o = ( "ALL:-" ); # default is all on stdout
    }

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

    #   setup the $CFG hash
    $CFG->{INPUT} = {};
    $CFG->{INPUT}->{SRC}   = $INPUT;  # original source
    $CFG->{INPUT}->{PLAIN} = '';      # source without slice delimiters
    $CFG->{OPT} = {};    
    $CFG->{OPT}->{X} = $opt_x;        # option -x
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
