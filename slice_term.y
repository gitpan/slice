%{
##
##  slice_term.y -- YACC parser for slice terms
##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
##

package SliceTermParser;
%}

%token SLICE

%left '\\' '-' 
%left 'u' '+'
%left 'x' '^' 
%left 'n' '*'

%right '!' '~' 

%%
expr:  SLICE            { $$ = &newvar($1); push(@OUT, $$." = \$SLICESET{'".$1."'};"); }

    |   '!' expr        { $$ = $2; push(@OUT, $2."->Complement(".$2.");"); }
    |   '~' expr        { $$ = $2; push(@OUT, $2."->Complement(".$2.");"); }

    |   expr 'n' expr   { $$ = $1; push(@OUT, $1."->Intersection(".$1.",".$3.");"); }
    |   expr '*' expr   { $$ = $1; push(@OUT, $1."->Intersection(".$1.",".$3.");"); }

    |   expr 'x' expr   { $$ = $1; push(@OUT, $1."->ExclusiveOr(".$1.",".$3.");"); }
    |   expr '^' expr   { $$ = $1; push(@OUT, $1."->ExclusiveOr(".$1.",".$3.");"); }

    |   expr 'u' expr   { $$ = $1; push(@OUT, $1."->Union(".$1.",".$3.");"); }
    |   expr '+' expr   { $$ = $1; push(@OUT, $1."->Union(".$1.",".$3.");"); }

    |   expr '\\' expr  { $$ = $1; push(@OUT, $1."->Difference(".$1.",".$3.");"); }
    |   expr '-' expr   { $$ = $1; push(@OUT, $1."->Difference(".$1.",".$3.");"); }

    |   '(' expr ')'    { $$ = $2; }
    ;
%%

#   create new set variable
$tmpcnt = 0;
sub newvar {
    local($name) = @_;
    local($tmp);

    $tmp = sprintf("\$T%03d", $tmpcnt++);
    return $tmp;
}

#   the lexical scanner
sub yylex {
    local(*s) = @_;
    local($c, $val);

    #   ignore whitespaces
    $s =~ s|^[ \t\n]+||;

    #   recognize end of string
    if ($s eq "") {
        return 0;
    }

    #   found a token
    if ($s =~ m|^([_A-Z0-9]+)(.*)|) {
        $val = $1;
        $s = $2;
        return ($SLICE, $val);
    }

    #   else give back one plain character
    $c = substr($s, 0, 1);
    $s = substr($s, 1);
    return ord($c);
}

#   and error function
sub yyerror {
    my ($msg, $s) = @_;
    die "$msg at $s.\n";
}

#
#  The top-level function which gets called by the user
#
#  ($cmds, $var) = SliceTerm::Parse($term);
#

package SliceTerm;

sub Parse {
    local($str) = @_;
    local($p, $var, $cmds);

    @SliceTermParser::OUT = ();
    $p = SliceTermParser->new(\&SliceTermParser::yylex, \&SliceTermParser::yyerror, 0);
    $var = $p->yyparse(*str);
    $cmds = join("\n", @SliceTermParser::OUT) . "\n";

    return ($cmds, $var);
}

package main;

1;
##EOF##
