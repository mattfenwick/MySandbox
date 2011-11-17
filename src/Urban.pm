
use strict;
use warnings;

package Urban;
my $base = "http://www.urbandictionary.com/define.php?term=";
use Data::Dumper;
use WebUtil;

sub new {
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub buildURL {
    my ($self, $searchPhrase) = @_;
    return $base . $searchPhrase;
}

# method behavior
# 1. parse text into html tree
# 2. find searched-for word
# 3. find definition(s)
# 4. find examples
#
# error cases
# 1. text is not valid html -- maybe not a problem, because HTML::TreeBuilder doesn't fail ??
# 2. can't find word
# 3. can't find definition
# 4. can't find example -- not an error, but maybe give notification
#
sub parseContent {
    my ($self, $content) = @_;
    
    # case 1 -- but unsure if parse failure results in false return value, or exception
    #    also unsure if it ever fails to parse
    my $root = &WebUtil::makeTree($content);
    
    my @words = $root->find_by_attribute("class", "word");
    if(!$words[0]) { # case 2
        $root->delete();
        return {'error' => 'could not find word'};
    }
    my $word = $words[0]->as_text();
    
    my @defs = $root->find_by_attribute("class", "definition");
    if(!$defs[0]) { # case 3
        $root->delete();
        return {'error' => 'could not find definition'};
    }
    my $def = $defs[0]->as_text();
    
    my @egs = $root->find_by_attribute("class", "example");
    my $eg;
    if(!$egs[0] || !$egs[0]->as_text()) { # case 4
        $eg = "no example found";
    } else {
        $eg = $egs[0]->as_text();
    }
    
    $root->delete();
    return {
        'word' => $word,
        'meaning' => $def,
        'example' => $eg 
    };
}

1;
