
#
#  convert ASCII set representation string into internal set object
#
sub asc2set {
    local($asc, *set, $onlylevel, $notcleared) = @_;
    local($i, $I, $internal);

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
        for ($i = $from; $i <= $to; $i++) {
            $set->Insert($i);
        }
		#$set->InsertRange($from, $to);
    }
}

#
#  convert internal set object into ASCII set representation string 
#
sub set2asc {
    local($set, *asc) = @_;
    local($inside, $i, $max, $min);

    $asc = "";
    $inside = 0;
    $min = $set->Min();
    $max = $set->Max();
    for ($i = $min; $i <= $max; $i++) {
        if ($set->in($i) and not $inside) {
            #   start of interval
            $asc .= ",0:$i";
            $inside = 1;
            next;
        }
        if (not $set->in($i) and $inside) {
            #   end of interval
            $asc .= ":" . sprintf("%d", $i-1);
            $inside = 0;
            next;
        }
    }
    #   special case: the leading comma
    $asc =~ s|^,||;

    #   special case: a interval which reached the end
    #   the above loop cannot determine this
    if ($asc =~ m|[^:]*\d+:\d+$|) {
        $asc .= ":" . $set->Max();
    }
}

1;
