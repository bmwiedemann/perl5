#!./perl

print "1..14\n";

@x = (1, 2, 3);
if (join(':',@x) eq '1:2:3') {print "ok 1\n";} else {print "not ok 1\n";}

if (join('',1,2,3) eq '123') {print "ok 2\n";} else {print "not ok 2\n";}

if (join(':',split(/ /,"1 2 3")) eq '1:2:3') {print "ok 3\n";} else {print "not ok 3\n";}

my $f = 'a';
$f = join ',', 'b', $f, 'e';
if ($f eq 'b,a,e') {print "ok 4\n";} else {print "# '$f'\nnot ok 4\n";}

$f = 'a';
$f = join ',', $f, 'b', 'e';
if ($f eq 'a,b,e') {print "ok 5\n";} else {print "not ok 5\n";}

$f = 'a';
$f = join $f, 'b', 'e', 'k';
if ($f eq 'baeak') {print "ok 6\n";} else {print "# '$f'\nnot ok 6\n";}

# 7,8 check for multiple read of tied objects
{ package X;
  sub TIESCALAR { my $x = 7; bless \$x };
  sub FETCH { my $y = shift; $$y += 5 };
  tie my $t, 'X';
  my $r = join ':', $t, 99, $t, 99;
  print "# expected '12:99:17:99' got '$r'\nnot " if $r ne '12:99:17:99';
  print "ok 7\n";
  $r = join '', $t, 99, $t, 99;
  print "# expected '22992799' got '$r'\nnot " if $r ne '22992799';
  print "ok 8\n";
};

# 9,10 and for multiple read of undef
{ my $s = 5;
  local ($^W, $SIG{__WARN__}) = ( 1, sub { $s+=4 } );
  my $r = join ':', 'a', undef, $s, 'b', undef, $s, 'c';
  print "# expected 'a::9:b::13:c' got '$r'\nnot " if $r ne 'a::9:b::13:c';
  print "ok 9\n";
  my $r = join '', 'a', undef, $s, 'b', undef, $s, 'c';
  print "# expected 'a17b21c' got '$r'\nnot " if $r ne 'a17b21c';
  print "ok 10\n";
};

{ my $s = join("", chr(1234),chr(255));
  print "not " unless length($s) == 2 &&
                      ord(substr($s,0,1)) == 1234 &&
                      ord(substr($s,1,1)) ==  255;
  print "ok 11\n";
}

{ my $s = join(chr(2345), chr(1234),chr(255));
  print "not " unless length($s) == 3 &&
                      ord(substr($s,0,1)) == 1234 &&
                      ord(substr($s,1,1)) == 2345 &&
                      ord(substr($s,2,1)) ==  255;
  print "ok 12\n";
}

{ my $s = join(chr(2345), chr(1234),chr(3456));
  print "not " unless length($s) == 3 &&
                      ord(substr($s,0,1)) == 1234 &&
                      ord(substr($s,1,1)) == 2345 &&
                      ord(substr($s,2,1)) == 3456;
  print "ok 13\n";
}

{ my $s = join(chr(255), chr(1234),chr(2345));
  print "not " unless length($s) == 3 &&
                      ord(substr($s,0,1)) == 1234 &&
                      ord(substr($s,1,1)) ==  255 &&
                      ord(substr($s,2,1)) == 2345;
  print "ok 14\n";
}
