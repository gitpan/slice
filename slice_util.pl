##
##  slice_util.pl -- Utility functions
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

sub verbose {
    local($str) = @_;
    if ($opt_x) {
        print STDERR "$str";
    }
}

sub error {
    local($str) = @_;
    print STDERR "slice ERROR: $str";
    exit(1);
}

1;
##EOF##
