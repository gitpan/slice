##
##  slice_pass1.pl -- Pass 1
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package main;

##
##
##  Pass 1: Determine delimiters
##
##

sub pass1 {
    my ($CFG) = @_;

    my ($found1, $prolog1, $name1, $epilog1);
    my ($found2, $prolog2, $name2, $epilog2);
    my (@CURRENT_SLICE_NAMES, %CURRENT_LEVEL_BRAIN, $CURRENT_LEVEL_SET);
    my ($INPUT, $pos, $namex, $L, $openseen);

    &verbose("\nPass 1: Determine delimiters\n\n");

    @CURRENT_SLICE_NAMES = ();                  
    %CURRENT_LEVEL_BRAIN = ();                  
    $CURRENT_LEVEL_SET   = new Bit::Vector(512);

    #   allocate the next free level starting from 1
    sub alloclevel {
        my ($i);

        for ($i = 0; $i <= $CURRENT_LEVEL_SET->Max(); $i++) {
            last if (not $CURRENT_LEVEL_SET->bit_test($i));
        }
        $CURRENT_LEVEL_SET->Bit_On($i);
        return $i + 1;
    }

    #   clear the given level  
    sub clearlevel {
        my ($i) = @_;

        $CURRENT_LEVEL_SET->Bit_Off($i - 1);
    }

    $INPUT = $CFG->{INPUT}->{SRC};
    $pos   = 0;
    $open  = 0;
    while (1) {
        # search for begin delimiter
        $found1 = (($prolog1, $name1, $epilog1) = 
                   ($INPUT =~ m|^(.*?)\[([A-Z][_A-Z0-9]*):(.*)$|s));
        # search for end delimiter
        $found2 = (($prolog2, $name2, $epilog2) = 
                   ($INPUT =~ m|^(.*?):([A-Z][_A-Z0-9]*)?\](.*)$|s));

        if (($found1 and not $found2) or ($found1 and $found2 and (length($prolog1) < length($prolog2)))) {
            #
            #   begin delimiter found
            #
            $pos += length($prolog1);           # adjust position
            $CFG->{INPUT}->{PLAIN} .= $prolog1; # move prolog
            $INPUT = $epilog1;                  # and go on with epilog

            $L = &alloclevel();                 # allocate next free level

            push(@CURRENT_SLICE_NAMES, $name1); # remember name  for end delimiter
            $CURRENT_LEVEL_BRAIN{"$name1"} = $L;# remember level for end delimiter
            if ($CFG->{SLICE}->{MINLEVELS}->{"$name1"} eq '' or 
                $CFG->{SLICE}->{MINLEVELS}->{"$name1"} > $L) {
                $CFG->{SLICE}->{MINLEVELS}->{"$name1"} = $L;
            }

            #  now begin entry with LEVEL:START
            $CFG->{SLICE}->{SET}->{ASC}->{"$name1"} .= 
                 ($CFG->{SLICE}->{SET}->{ASC}->{"$name1"} ? ',' : '') . "$L:$pos"; 

            #  adjust notice about highest level
            $CFG->{SLICE}->{MAXLEVEL} = ($CFG->{SLICE}->{MAXLEVEL} < $L ? 
                                         $L : $CFG->{SLICE}->{MAXLEVEL});

            &verbose("    slice `$name1': begin at $pos, level $L\n");

            $open++;
        }
        elsif (($open > 0) and ((not $found1 and $found2) or ($found1 and $found2 and (length($prolog2) < length($prolog1))))) {
            #
            #   end delimiter found
            #
            $pos += length($prolog2)-1;         # adjust position
            $CFG->{INPUT}->{PLAIN} .= $prolog2; # move prolog
            $INPUT = $epilog2;                  # and go on with epilog

            $namex = pop(@CURRENT_SLICE_NAMES);      # take remembered name
            $name2 = $namex if ($name2 eq '');       # fill name because of shortcut syntax
            $L     = $CURRENT_LEVEL_BRAIN{"$name2"}; # take remembered level

            &clearlevel($L);                         # de-allocate level

            # now end entry with :END
            $CFG->{SLICE}->{SET}->{ASC}->{"$name2"} .= ":$pos";

            &verbose("    slice `$name2': end at $pos\n");

            $pos++;
            $open--;
        }
        else { # not $found1 and not $found2 _OR_ bad input stuff
            #
            #   nothing more found
            #
            $CFG->{INPUT}->{PLAIN} .= $INPUT; # add all remaining input
            last;                             # stop loop
        }
    }

    #   check: were all opened slices really closed?
    if ($CURRENT_LEVEL_SET->Norm > 0) {
        print STDERR "ERROR: Some slices were not closed: ";
        my $i;
        for ($i = 0; $i <= $CURRENT_LEVEL_SET->Max(); $i++) {
            if ($CURRENT_LEVEL_SET->bit_test($i)) {
                my $name;
                foreach $name (keys(%CURRENT_LEVEL_BRAIN)) {
                    if ($CURRENT_LEVEL_BRAIN{$name} == ($i+1)) {
                        print STDERR "`$name' ";
                    }
                }
            }
        }
        print STDERR "\n";
        exit(1);
    }
}

1;
##EOF##
