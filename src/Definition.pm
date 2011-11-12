use strict;
use warnings;

package Definition;
use Parser;
use WebUtil;

my %urlstubs = (
	'urban' => "http://www.urbandictionary.com/define.php?term=",
    'dict' => "http://dictionary.reference.com/browse/",
    'word' => "http://www.wordreference.com/enfr/",
    'ledict' => "http://www.le-dictionnaire.com/definition.php?mot=",
    'frenchToEnglishWordRef' => "http://www.wordreference.com/fren/",
);

my %dics = (
    'urban'  => \&Parser::urbanDict,
    'word'   => \&Parser::wordRef,
    'ledict' => \&Parser::leDict,
    'dict'   => \&Parser::dicDotCom
);

sub getDefinitions {
    my ($searchPhrase) = @_;
    #   substitute '+' for ' ' when building url (because that's how urls work)
    my $query = $searchPhrase =~ tr/ /+/; 
    #   problem:  multi-word queries are sometimes redirected .... to where?????
    my %defs = ();
    for my $dict (keys %dics) {
    	my $parseFunction = $dics{$dict};             # get the parsing function
    	my $url = makeURL($searchPhrase, $dict);      # ... the url
    	my $response = &WebUtil::getWebPage($url);    # fetch the web page
    	my $htmlTree = &WebUtil::makeTree($response); # turn the web page into an html tree
        $defs{$dict} = &{$parseFunction}($htmlTree);  # parse the tree into a definition
        $htmlTree->delete();                          # make sure to free the tree
    }                                                 # ???? ERROR HANDLING ????
    return %defs;
}

sub makeURL {
    my ($search, $dicname) = @_;
    my $url = $urlstubs{$dicname}.$search; # we need something more robust here 
    						# in case it's not simply tacked on the end.....
    print "dict and url: <$dicname> <$url>\n";
    return $url;
}


1;
