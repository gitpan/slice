##
##  slice_util.pl -- Utility functions
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package main;

sub verbose {
    my ($str) = @_;

    if ($main::CFG->{OPT}->{X}) {
        $str =~ s|^|** SLICE:Verbose: |mg;
        print STDERR $str;
    }
}

sub error {
    my ($str) = @_;

    $str =~ s|^|** SLICE:Error: |mg;
    print STDERR $str;
    exit(1);
}

1;
##EOF##
