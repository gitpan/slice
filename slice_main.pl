#!@path_perl@
eval 'exec @path_perl@ -S $0 ${1+"$@"}'
    if $running_under_some_shell;
require 5.003;
require "slice_boot.pl";

##         _ _          
##     ___| (_) ___ ___ 
##    / __| | |/ __/ _ \
##    \__ \ | | (_|  __/
##    |___/_|_|\___\___|
##                    
##    Slice -- Extract out pre-defined slices of an ASCII file
##
##    The slice program reads an inputfile and divide its prepaired ASCII contents
##    into possibly overlapping slices. These slices are determined by enclosing
##    blocks which are defined by begin and end delimiters which have to be
##    already in the file.   The final output gets calculated by a slice term
##    consisting of slice names, set theory operators and optional round brackets.
##  
##    The latest release can be found on
##    http://www.engelschall.com/sw/slice/
##  
##    Copyright (c) 1997 Ralf S. Engelschall, All rights reserved.
##  
##    This program is free software; it may be redistributed and/or modified only
##    under the terms of the GNU General Public License, which may be found in the
##    SLICE source distribution.  Look at the file COPYING.   This program is
##    distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
##    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
##    PARTICULAR PURPOSE.  See either the GNU General Public License for more
##    details.
##  
##                                Ralf S. Engelschall
##                                rse@engelschall.com
##                                www.engelschall.com


use Getopt::Long 2.12;
use IO::Handle 1.15;
use IO::File 1.07;
use Bit::Vector 5.0;

require "slice_vers.pl";
require "slice_util.pl";
require "slice_term.pl";
require "slice_setup.pl";
require "slice_pass1.pl";
require "slice_pass2.pl";
require "slice_pass3.pl";

$CFG = {};
&setup($CFG);
&pass1($CFG);
&pass2($CFG);
&pass3($CFG);

exit(0);


##EOF##
