##
##  slice_pass3.pl -- Pass 3
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package main;

##
##
##  Pass 3: Output generation
##
##

sub pass3 {
    my ($CFG) = @_;

    my ($slice, $outfile, $chmod, $out);
    my ($set, $cmds, $var);
    my ($start, $min, $max);
    my ($entry);

    &verbose("\nPass 3: Output generation\n\n");

    foreach $entry (@{$CFG->{OPT}->{O}}) {

        #   determine parameters
        if ($entry =~ m|^([A-Z0-9~!+u*n\-\\^x()@]+):(.+)@(.+)$|) {
            # full syntax
            ($slice, $outfile, $chmod) = ($1, $2, $3);
        }
        elsif ($entry =~ m|^([_A-Z0-9~!+u*n\-\\^x()@]+):(.+)$|) {
            # only slice and file
            ($slice, $outfile, $chmod) = ($1, $2, "");
        }
        elsif ($entry =~ m|^([^@]+)@(.+)$|) {
            # only file and chmod
            ($slice, $outfile, $chmod) = ("ALL", $1, $2);
        }
        else {
            # only file 
            ($slice, $outfile, $chmod) = ("ALL", $entry, "");
        }
        &verbose("    file `$outfile': sliceterm='$slice', chmodopts='$chmod'\n");

        #   open output file
        if ($outfile eq '-') {
            $out = new IO::Handle;
            $out->fdopen(fileno(STDOUT), "w");
        }
        else {
            $out = new IO::File;
            $out->open(">$outfile");
        }

        #   now when there is plain data cut out the slices
        if (length($CFG->{INPUT}->{PLAIN}) > 0) {
            #   parse the sliceterm and create corresponding
            #   Perl 5 statement containing Bit::Vector calls
            ($cmds, $var) = SliceTerm::Parse($slice);
    
            #   just debugging...
            if ($CFG->{OPT}->{X}) {
                &verbose("        calculated Perl 5 set term:\n");
                &verbose("        ----\n");
                my $x = $cmds; $x =~ s|\n|\n        |g;
                &verbose("        $x");
                &verbose("----\n");
            }
    
            #   now evaluate the Bit::Vector statements
            #   and move result to $set
            eval "$cmds; \$set = $var";
    
            #   now scan the set and write out characters
            #   which have a corresponding bit set.
            $start = 0;
            while (($start < $set->Size()) &&
                   (($min, $max) = $set->Interval_Scan_inc($start))) {
                $out->print(substr($CFG->{INPUT}->{PLAIN}, $min, ($max-$min+1)));
                $start = $max + 2;
            }
        }

        #   close outputfile
        $out->close;

        #   additionally run chmod on the output file
        if ($outfile ne '-' and $chmod ne '' and -f $outfile) {
            system("chmod $chmod $outfile");
        }
    }
}

1;
