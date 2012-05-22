
use strict;
use warnings;

use WebUtil;
use WordRef;
use Urban;
use Definition;
use Data::Dumper;
use HTML::TreeBuilder;


my $parser = WordRef->new();

my $page = &WebUtil::getWebPage($parser->buildURL('refrigerator'));

my $def = $parser->parseContent($page);

#print Dumper($def);

my $uparser = Urban->new();

#print Dumper($uparser->parseContent(
#	&WebUtil::getWebPage($uparser->buildURL('refrigerator'))));
	
	
#print Dumper(&Definition::getDefinitions("mouse"));

#######################################################################

my $html = "<html><bod I like stuff </blargh>";
my $root = HTML::TreeBuilder->new;
$root->parse($html);
$root->eof;

print "here's my tree: " . Dumper($root);