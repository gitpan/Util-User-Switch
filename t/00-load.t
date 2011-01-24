#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Util::User::Switch' );
}

diag( "Testing Util::User::Switch $Util::User::Switch::VERSION, Perl $], $^X" );
