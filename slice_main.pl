#!@path_perl@
eval 'exec @path_perl@ -S $0 ${1+"$@"}'
    if $running_under_some_shell;
##
##  Slice -- Extract out pre-defined slices of an ASCII file
##
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##  
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to
##  
##      Free Software Foundation, Inc.,
##      675 Mass Ave, Cambridge,
##      MA 02139, USA.
##  
##  Notice, that ``free software'' addresses the fact that this program
##  is __distributed__ under the term of the GNU General Public License
##  and because of this, it can be redistributed and modified under the
##  conditions of this license, but the software remains __copyrighted__
##  by the author. Don't intermix this with the general meaning of 
##  Public Domain software or such a derivated distribution label.
##  
##  The author reserves the right to distribute following releases of
##  this program under different conditions or license agreements.
##
##                                Ralf S. Engelschall
##                                rse@engelschall.com
##                                www.engelschall.com
##

require "slice_boot.pl";

require 5.003;

use Getopt::Long 2.06;
use Bit::Vector 4.0;

require "slice_set.pl";
require "slice_term.pl";
require "slice_util.pl";
require "slice_vers.pl";

package main;


##
##
##  Process command line and read input
##
##

sub usage {
    print STDERR "Usage: slice [options] [file]\n";
    print STDERR "   where options are\n";
    print STDERR "   -o sliceterm:file  create output file\n";
    print STDERR "   -x                 verbose/debug mode\n";
    print STDERR "   -v                 version string\n";
    exit(1);
}

sub hello {
	print STDERR "$Vers::SLICE_Hello\n";
	exit(0);
}

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

if ($#ARGV == -1 or ($#ARGV == 0 and $ARGV[0] eq "-")) {
    $infile = "-";
    @IN = <STDIN>;
}
else {
    $infile = $ARGV[0];
    open(INFP, "<$infile");
    @IN = <INFP>;
    close(INFP);
}


##
##
##  Pass 1: Determine delimiters
##
##
&verbose("\nPass 1: Determine delimiters\n\n");

$INPUT = join("", @IN);
$NEW = "";
@NAMES = ();
$LEVELS = new Bit::Vector(100);
%SLICE = ();
$maxlevel = 0;

sub alloclevel {
    my ($i);

    for ($i = 0; $i < 100; $i++) {
        last if (not $LEVELS->bit_test($i));
    }
    $LEVELS->Bit_On($i);
    return $i + 1;
}

sub clearlevel {
    my ($level) = @_;

    $LEVELS->Bit_Off($level - 1);
}

$pos = 0;
while (1) {
    # search for a begin delimiter
    $rc1 = ($INPUT =~ m|^(.*?)\[([_A-Z0-9]+):(.*)$|s); # non greedy matching!
    ($prev1, $name1, $next1) = ($1, $2, $3);

    # search for an end delimiter
    $rc2 = ($INPUT =~ m|^(.*?):([_A-Z0-9]*)\](.*)$|s); # non greedy matching!
    ($prev2, $name2, $next2) = ($1, $2, $3);

    if (not $rc1 and not $rc2) {
        #   nothing more found, break.
        $NEW .= $INPUT;
        last;
    }
    elsif (($rc1 and $rc2) and (length($prev1) < length($prev2)) or ($rc1 and not $rc2)) {
        #   begin delimiter found
        push(@NAMES, $name1);
        $pos += length($prev1);
        $H = &alloclevel;
        $LEVEL{$name1} = $H;
        $maxlevel = ($maxlevel < $H ? $H : $maxlevel);
        &verbose("    $name1 begin @ $pos (level $H)\n");
        if ($SLICE{$name1} eq "") {
            $SLICE{$name1} = "$H:$pos";
        }
        else {
            $SLICE{$name1} .= ",$H:$pos";
        }
        $NEW .= $prev1;
        $INPUT = $next1;
    }
    else {
        #   end delimiter found
        $namex = pop(@NAMES);
        if ($name2 eq "") {
            $name2 = $namex;
        }
        $pos += length($prev2);
        &clearlevel($LEVEL{$name2});
        $n = sprintf("%d", $pos - 1);
        &verbose("    $name2 end @ $n\n");
        $SLICE{$name2} .= ":$n";
        $NEW .= $prev2;
        $INPUT = $next2;
    }
}
$IN = $NEW;

if ($LEVELS->Norm != 0) {
    &error("Sorry, some slices were not closed!\n");
}


##
##
##  Pass 2: Calculation of slice sets
##
##
&verbose("\nPass 2: Calculation of slice sets\n\n");

$MAXSETLEN = length($NEW)+1;
%SLICESET = ();
$set  = new Bit::Vector($MAXSETLEN);
$setA = new Bit::Vector($MAXSETLEN);

sub SetClone {
    my ($set) = @_;
    my ($tmp);

    $tmp = new Bit::Vector($set->Size());
    $tmp->Copy($set);
    return $tmp;
}

#   convert ASCII representation to real internal set objects
foreach $slice (keys(%SLICE)) {
    $asc = $SLICE{$slice};
    $set->Empty();
    &asc2set($asc, $set);
    $SLICESET{$slice} = &SetClone($set);
}

#   define the various (un)defined slice areas
$set->Fill();
$SLICESET{'UNDEF0'} = &SetClone($set);
$set->Empty();
$SLICESET{'DEF0'} = &SetClone($set);
$setA->Empty();
for ($i = 1; $i <= $maxlevel; $i++) {
    $set->Empty();
    foreach $name (keys(%SLICE)) {
        $asc = $SLICE{$name};
        &asc2set($asc, $set, $i, 1); # load $set with entries of level $i
        $setA->Union($setA, $set);   # add to $setA these entries
    }
    $SLICESET{"DEF$i"} = &SetClone($set);
    $set->Complement($set);
    $SLICESET{"UNDEF$i"} = &SetClone($set);
}
$SLICESET{'DEF'} = &SetClone($setA);
$setA->Complement($setA);
$SLICESET{'UNDEF'} = &SetClone($setA);
$SLICESET{'ALL'} = $SLICESET{'UNDEF0'};


##
##
##  Pass 3: Output generation
##
##
&verbose("\nPass 3: Output generation\n\n");

sub WriteOutput {
    local ($infile, *IN, $slice, $outfile, *OUT, $chmod) = @_;

    ($cmds, $var) = SliceTerm::Parse($slice);

    &verbose("        calculated Perl 5 set term:\n");
    &verbose("        ----\n");
    $x = $cmds; $x =~ s|\n|\n        |g;
    &verbose("        $x");
    &verbose("----\n");

    eval $cmds;
    $set = eval "$var";

    for ($i = 0; $i <= $set->Max(); $i++) {
        if ($set->bit_test($i)) {
            print OUT substr($IN, $i, 1);
        }
    }

    &verbose("\n");
}


if ($#opt_o == -1) {
    @opt_o = ( "ALL:-" ); # default is all on stdout
}
foreach $entry (@opt_o) {
    if ($entry =~ m|^([A-Z0-9~!+u*n\-\\^x()]+):(.+)@(.+)$|) {
        # full syntax
        ($slice, $outfile, $chmod) = ($1, $2, $3);
    }
    elsif ($entry =~ m|^([_A-Z0-9~!+u*n\-\\^x()]+):(.+)$|) {
        # only slice and file
        ($slice, $outfile, $chmod) = ($1, $2, "");
    }
    elsif ($entry =~ m|^(.+)@(.+)$|) {
        # only file and chmod
        ($slice, $outfile, $chmod) = ("ALL", $1, $2);
    }
    else {
        # only file 
        ($slice, $outfile, $chmod) = ("ALL", $entry, "");
    }

    if ($outfile eq "-") {
        *OUT = *STDOUT;
    }
    else {
        open(OUT, ">$outfile") || die;
    }

    &verbose("    file $outfile: sliceterm='$slice', chmodopts='$chmod'\n");
    &WriteOutput($infile, *IN, $slice, $outfile, *OUT, $chmod);

    if ($outfile ne "-") {
        close(OUT);
    }
    if ($chmod ne "") {
        system("chmod $chmod $outfile");
    }
}

#   die gracefully...
exit(0);

##EOF##
