
#   bootstrapping private installed modules
BEGIN { 
    @INC = ( 
	"/usr/local/lib/perl_private/lib",
	"/usr/local/lib/perl_private/lib/i386-freebsd/5.00324",
	"/usr/local/lib/perl_private/lib/site_perl",
	"/usr/local/lib/perl_private/lib/site_perl/i386-freebsd",
	@INC );
}

