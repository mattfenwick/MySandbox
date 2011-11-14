
use strict;
use warnings;

use WebUtil;
use WordRef;
use Urban;
use Definition;
use Data::Dumper;


my $parser = WordRef->new();

my $page = &WebUtil::getWebPage($parser->buildURL('refrigerator'));

my $def = $parser->parseContent($page);

print Dumper($def);

my $uparser = Urban->new();

print Dumper($uparser->parseContent(
	&WebUtil::getWebPage($uparser->buildURL('refrigerator'))));
	
	
print Dumper(&Definition::getDefinitions("mouse"))