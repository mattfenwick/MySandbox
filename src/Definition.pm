use strict;
use warnings;

package Definition;
use WebUtil;
use WordRef;
use Urban;

my %parsers = (
    'wordRef' => WordRef->new(),
    'urban' => Urban->new()
);


sub getDefinitions {
    my ($searchPhrase) = @_;
    #   substitute '+' for ' ' when building url (because that's how urls work)
    my $query = $searchPhrase =~ tr/ /+/; 
    #   problem:  multi-word queries are sometimes redirected .... to where?????
    my %defs = ();
    for my $dict (keys %parsers) {
        my $parser = $parsers{$dict};                 # get the parsing function
        my $url = $parser->buildURL($searchPhrase);   # ... the url
        my $content = &WebUtil::getWebPage($url);     # fetch the web page
        my $def = $parser->parseContent($content);    # turn the web page into an html tree
        $defs{$dict} = $def;
    }                                                 # ???? ERROR HANDLING ????
    return %defs;
}


1;
