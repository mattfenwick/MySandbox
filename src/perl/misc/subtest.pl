use strict;
use warnings;
use Test::More;


subtest 'Available reports' => sub {
	is(1, 2 - 1);
	
	subtest 'scheisse' => sub {
		ok(1);
		ok(0);
	};
	
	is('me', 'you');
};

ok(4);

done_testing();