#!@path_perl@
eval 'exec @path_perl@ -S $0 ${1+"$@"}'
    if $running_under_some_shell;

require 5.004;

require "slice_boot.pl";

use Getopt::Long 2.06;
use IO::Handle 1.15;
use IO::File 1.06;
use Bit::Vector 4.2;

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
