
use ExtUtils::MakeMaker;

require "./GetoptLong.pm";

WriteMakefile(
	VERSION   => $Getopt::Long::VERSION,
	NAME      => "Getopt::Long",
);
