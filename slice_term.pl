"@(#)yaccpar 1.8 (Berkeley) 01/20/91 (JAKE-P5BP-0.5 12/16/96)";
;##
;##  slice_term.y -- YACC parser for slice terms
;##  Copyright (c) 1997 Ralf S. Engelschall, All Rights Reserved. 
;##

package SliceTermParser;
$SLICE=257;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,
);
@yylen = (                                                2,
    1,    2,    2,    3,    3,    3,    3,    3,    3,    3,
    3,    3,
);
@yydefred = (                                             0,
    1,    0,    0,    0,    0,    2,    3,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   12,    0,    0,    0,
    0,    0,    0,    4,    5,
);
@yydgoto = (                                              5,
);
@yysindex = (                                           -33,
    0,  -33,  -33,  -33,  -12,    0,    0,  -18,  -33,  -33,
  -33,  -33,  -33,  -33,  -33,  -33,    0,  -32,  -32,  -37,
  -37,  -41,  -41,    0,    0,
);
@yyrindex = (                                             0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   14,   15,    8,
    9,    2,    3,    0,    0,
);
@yygindex = (                                           125,
);
$YYTABLESIZE=224;
@yytable = (                                              2,
   16,    6,    7,    0,   16,    0,    4,    8,    9,   16,
   12,    0,    0,   10,   11,    0,    0,    0,    0,    0,
    0,    0,   17,   16,   12,    0,   10,    0,    0,   16,
   12,    0,   10,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    6,    7,    6,    7,    6,    7,    8,    9,
    8,    9,    8,    9,   10,   11,   14,    0,   10,   11,
    0,   14,    0,    0,    0,    0,    0,    0,   15,    0,
    0,    0,   15,    9,    0,   14,    0,   15,    0,    9,
    0,   14,   13,    0,   11,    0,    0,   13,    0,    0,
    0,   15,    3,    6,    7,    6,    7,   15,   11,    8,
    9,   13,    0,    0,   11,   10,   11,   13,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    6,    7,
    0,    6,    7,    0,    8,    9,    6,    7,    8,    0,
    0,    0,    0,   18,   19,   20,   21,   22,   23,   24,
   25,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    1,
);
@yycheck = (                                             33,
   42,    0,    0,   -1,   42,   -1,   40,    0,    0,   42,
   43,   -1,   -1,    0,    0,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   41,   42,   43,   -1,   45,   -1,   -1,   42,
   43,   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   41,   41,   43,   43,   45,   45,   41,   41,
   43,   43,   45,   45,   41,   41,   94,   -1,   45,   45,
   -1,   94,   -1,   -1,   -1,   -1,   -1,   -1,  110,   -1,
   -1,   -1,  110,   92,   -1,   94,   -1,  110,   -1,   92,
   -1,   94,  120,   -1,  117,   -1,   -1,  120,   -1,   -1,
   -1,  110,  126,   92,   92,   94,   94,  110,  117,   92,
   92,  120,   -1,   -1,  117,   92,   92,  120,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  117,  117,
   -1,  120,  120,   -1,  117,  117,    2,    3,    4,   -1,
   -1,   -1,   -1,    9,   10,   11,   12,   13,   14,   15,
   16,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  257,
);
$YYFINAL=5;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=257;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
"'!'",'','','','','','',"'('","')'","'*'","'+'",'',"'-'",'','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"'\\\\'",'',"'^'",
'','','','','','','','','','','','','','','',"'n'",'','','','','','',"'u'",'','',"'x'",'','','','','',"'~'",
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','',"SLICE",
);
@yyrule = (
"\$accept : expr",
"expr : SLICE",
"expr : '!' expr",
"expr : '~' expr",
"expr : expr 'n' expr",
"expr : expr '*' expr",
"expr : expr 'x' expr",
"expr : expr '^' expr",
"expr : expr 'u' expr",
"expr : expr '+' expr",
"expr : expr '\\\\' expr",
"expr : expr '-' expr",
"expr : '(' expr ')'",
);
#endif
sub yyclearin { $_[0]->{'yychar'} = -1; }
sub yyerrok { $_[0]->{'yyerrflag'} = 0; }
sub new {
  my $p = {'yylex' => $_[1], 'yyerror' => $_[2], 'yydebug' => $_[3]};
  bless $p, $_[0];
}
sub YYERROR { ++$_[0]->{'yynerrs'}; $_[0]->yy_err_recover; }
sub yy_err_recover {
  my ($p) = @_;
  if ($p->{'yyerrflag'} < 3)
  {
    $p->{'yyerrflag'} = 3;
    while (1)
    {
      if (($p->{'yyn'} = $yysindex[$p->{'yyss'}->[$p->{'yyssp'}]]) && 
          ($p->{'yyn'} += $YYERRCODE) >= 0 && 
          $yycheck[$p->{'yyn'}] == $YYERRCODE)
      {
        warn("yydebug: state " . 
                     $p->{'yyss'}->[$p->{'yyssp'}] . 
                     ", error recovery shifting to state" . 
                     $yytable[$p->{'yyn'}] . "\n") 
                       if $p->{'yydebug'};
        $p->{'yyss'}->[++$p->{'yyssp'}] = 
          $p->{'yystate'} = $yytable[$p->{'yyn'}];
        $p->{'yyvs'}->[++$p->{'yyvsp'}] = $p->{'yylval'};
        next yyloop;
      }
      else
      {
        warn("yydebug: error recovery discarding state ".
              $p->{'yyss'}->[$p->{'yyssp'}]. "\n") 
                if $p->{'yydebug'};
        return(undef) if $p->{'yyssp'} <= 0;
        --$p->{'yyssp'};
        --$p->{'yyvsp'};
      }
    }
  }
  else
  {
    return (undef) if $p->{'yychar'} == 0;
    if ($p->{'yydebug'})
    {
      $p->{'yys'} = '';
      if ($p->{'yychar'} <= $YYMAXTOKEN) { $p->{'yys'} = 
        $yyname[$p->{'yychar'}]; }
      if (!$p->{'yys'}) { $p->{'yys'} = 'illegal-symbol'; }
      warn("yydebug: state " . $p->{'yystate'} . 
                   ", error recovery discards " . 
                   "token " . $p->{'yychar'} . "(" . 
                   $p->{'yys'} . ")\n");
    }
    $p->{'yychar'} = -1;
    next yyloop;
  }
0;
} # yy_err_recover

sub yyparse {
  my ($p, $s) = @_;
  if ($p->{'yys'} = $ENV{'YYDEBUG'})
  {
    $p->{'yydebug'} = int($1) if $p->{'yys'} =~ /^(\d)/;
  }

  $p->{'yynerrs'} = 0;
  $p->{'yyerrflag'} = 0;
  $p->{'yychar'} = (-1);

  $p->{'yyssp'} = 0;
  $p->{'yyvsp'} = 0;
  $p->{'yyss'}->[$p->{'yyssp'}] = $p->{'yystate'} = 0;

yyloop: while(1)
  {
    yyreduce: {
      last yyreduce if ($p->{'yyn'} = $yydefred[$p->{'yystate'}]);
      if ($p->{'yychar'} < 0)
      {
        if ((($p->{'yychar'}, $p->{'yylval'}) = 
            &{$p->{'yylex'}}($s)) < 0) { $p->{'yychar'} = 0; }
        if ($p->{'yydebug'})
        {
          $p->{'yys'} = '';
          if ($p->{'yychar'} <= $#yyname) 
             { $p->{'yys'} = $yyname[$p->{'yychar'}]; }
          if (!$p->{'yys'}) { $p->{'yys'} = 'illegal-symbol'; };
          warn("yydebug: state " . $p->{'yystate'} . 
                       ", reading " . $p->{'yychar'} . " (" . 
                       $p->{'yys'} . ")\n");
        }
      }
      if (($p->{'yyn'} = $yysindex[$p->{'yystate'}]) && 
          ($p->{'yyn'} += $p->{'yychar'}) >= 0 && 
          $yycheck[$p->{'yyn'}] == $p->{'yychar'})
      {
        warn("yydebug: state " . $p->{'yystate'} . 
                     ", shifting to state " .
              $yytable[$p->{'yyn'}] . "\n") if $p->{'yydebug'};
        $p->{'yyss'}->[++$p->{'yyssp'}] = $p->{'yystate'} = 
          $yytable[$p->{'yyn'}];
        $p->{'yyvs'}->[++$p->{'yyvsp'}] = $p->{'yylval'};
        $p->{'yychar'} = (-1);
        --$p->{'yyerrflag'} if $p->{'yyerrflag'} > 0;
        next yyloop;
      }
      if (($p->{'yyn'} = $yyrindex[$p->{'yystate'}]) && 
          ($p->{'yyn'} += $p->{'yychar'}) >= 0 &&
          $yycheck[$p->{'yyn'}] == $p->{'yychar'})
      {
        $p->{'yyn'} = $yytable[$p->{'yyn'}];
        last yyreduce;
      }
      if (! $p->{'yyerrflag'}) {
        &{$p->{'yyerror'}}('syntax error', $s);
        ++$p->{'yynerrs'};
      }
      return(undef) if $p->yy_err_recover;
    } # yyreduce
    warn("yydebug: state " . $p->{'yystate'} . 
                 ", reducing by rule " . 
                 $p->{'yyn'} . " (" . $yyrule[$p->{'yyn'}] . 
                 ")\n") if $p->{'yydebug'};
    $p->{'yym'} = $yylen[$p->{'yyn'}];
    $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}+1-$p->{'yym'}];
if ($p->{'yyn'} == 1) {
{ $p->{'yyval'} = &newvar($p->{'yyvs'}->[$p->{'yyvsp'}-0]); push(@OUT, $p->{'yyval'}." = \$SLICESET{'".$p->{'yyvs'}->[$p->{'yyvsp'}-0]."'};"); }
}
if ($p->{'yyn'} == 2) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-0]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-0]."->Complement(".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 3) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-0]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-0]."->Complement(".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 4) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Intersection(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 5) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Intersection(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 6) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->ExclusiveOr(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 7) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->ExclusiveOr(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 8) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Union(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 9) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Union(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 10) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Difference(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 11) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-2]; push(@OUT, $p->{'yyvs'}->[$p->{'yyvsp'}-2]."->Difference(".$p->{'yyvs'}->[$p->{'yyvsp'}-2].",".$p->{'yyvs'}->[$p->{'yyvsp'}-0].");"); }
}
if ($p->{'yyn'} == 12) {
{ $p->{'yyval'} = $p->{'yyvs'}->[$p->{'yyvsp'}-1]; }
}
    $p->{'yyssp'} -= $p->{'yym'};
    $p->{'yystate'} = $p->{'yyss'}->[$p->{'yyssp'}];
    $p->{'yyvsp'} -= $p->{'yym'};
    $p->{'yym'} = $yylhs[$p->{'yyn'}];
    if ($p->{'yystate'} == 0 && $p->{'yym'} == 0)
    {
      warn("yydebug: after reduction, shifting from state 0 ",
            "to state $YYFINAL\n") if $p->{'yydebug'};
      $p->{'yystate'} = $YYFINAL;
      $p->{'yyss'}->[++$p->{'yyssp'}] = $YYFINAL;
      $p->{'yyvs'}->[++$p->{'yyvsp'}] = $p->{'yyval'};
      if ($p->{'yychar'} < 0)
      {
        if ((($p->{'yychar'}, $p->{'yylval'}) = 
            &{$p->{'yylex'}}($s)) < 0) { $p->{'yychar'} = 0; }
        if ($p->{'yydebug'})
        {
          $p->{'yys'} = '';
          if ($p->{'yychar'} <= $#yyname) 
            { $p->{'yys'} = $yyname[$p->{'yychar'}]; }
          if (!$p->{'yys'}) { $p->{'yys'} = 'illegal-symbol'; }
          warn("yydebug: state $YYFINAL, reading " . 
               $p->{'yychar'} . " (" . $p->{'yys'} . ")\n");
        }
      }
      return ($p->{'yyvs'}->[1]) if $p->{'yychar'} == 0;
      next yyloop;
    }
    if (($p->{'yyn'} = $yygindex[$p->{'yym'}]) && 
        ($p->{'yyn'} += $p->{'yystate'}) >= 0 && 
        $p->{'yyn'} <= $#yycheck && 
        $yycheck[$p->{'yyn'}] == $p->{'yystate'})
    {
        $p->{'yystate'} = $yytable[$p->{'yyn'}];
    } else {
        $p->{'yystate'} = $yydgoto[$p->{'yym'}];
    }
    warn("yydebug: after reduction, shifting from state " . 
        $p->{'yyss'}->[$p->{'yyssp'}] . " to state " . 
        $p->{'yystate'} . "\n") if $p->{'yydebug'};
    $p->{'yyss'}[++$p->{'yyssp'}] = $p->{'yystate'};
    $p->{'yyvs'}[++$p->{'yyvsp'}] = $p->{'yyval'};
  } # yyloop
} # yyparse

#   create new set variable
$tmpcnt = 0;
sub newvar {
    local($name) = @_;
    local($tmp);

    if ($main::SLICESET{"$name"} eq "") {
        print STDERR "ERROR: no such slice '$name'\n";
        exit(1);
    }
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
