
#
#   general purpose functions
#
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
