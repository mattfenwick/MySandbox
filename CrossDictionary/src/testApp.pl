
use strict;
use warnings;
use Test::More;


BEGIN { use_ok('Tkx'); }
BEGIN { use_ok('HTML::TreeBuilder'); }
BEGIN { use_ok('JSON'); }
BEGIN { use_ok('LWP'); }
BEGIN { use_ok('Log::Log4perl'); }

BEGIN { use_ok('Controller'); }
BEGIN { use_ok('Definition'); }
BEGIN { use_ok('DictDotCom'); }
BEGIN { use_ok('GUI'); }
BEGIN { use_ok('LeDict'); }
BEGIN { use_ok('Urban'); }
BEGIN { use_ok('WebUtil'); }
BEGIN { use_ok('WordRef'); }


done_testing();