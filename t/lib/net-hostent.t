#!./perl -w

BEGIN {
	chdir 't' if -d 't';
	@INC = '../lib';
}

BEGIN { $| = 1; print "1..5\n"; }

END {print "not ok 1\n" unless $loaded;}

use Net::hostent;

$loaded = 1;
print "ok 1\n";

# test basic resolution of localhost <-> 127.0.0.1
use Socket;

my $h = gethost('localhost');
my $i = gethostbyaddr(inet_aton("127.0.0.1"));

print "not " if inet_ntoa($h->addr) ne "127.0.0.1";
print "ok 2\n";

print "not " if inet_ntoa($i->addr) ne "127.0.0.1";
print "ok 3\n";

# need to skip the name comparisons on Win32 because windows will
# return the name of the machine instead of "localhost" when resolving
# 127.0.0.1 or even "localhost"

if ($^O eq 'MSWin32') {
  print "ok $_ # skipped on win32\n" for (4,5);
} else {
  print "not " if $h->name ne "localhost";
  print "ok 4\n";

  print "not " if $i->name ne "localhost";
  print "ok 5\n";
}
