##
##  slice_set.pl -- Set manipulation
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

#
#  convert ASCII set representation string into internal set object
#
sub asc2set {
    my ($asc, $set, $onlylevel, $notcleared) = @_;
    my ($i, $I, $internal);

    $set->Empty() if (($notcleared eq "") or (not $notcleared));
    if ($asc =~ m|^\d+:0:-1$|) {
        #   the string represents the empty set
        return $set;
    }

    #   split out the interval substrings 
    if ($asc =~ m|,|) {
        @I = split(/,/, $asc);
    }
    else {
        @I = ($asc);
    }

    #   iterate over each interval and
    #   set the corresponding elements in the set
    foreach $interval (@I) {
        ($level, $from, $to) = ($interval =~ m|^(\d+):(\d+):(\d+)$|);
        next if (($onlylevel ne "") and ($level != $onlylevel)); 
        next if ($from > $to);
        $set->Fill_Interval($from, $to);
    }
}

1;
##EOF##
