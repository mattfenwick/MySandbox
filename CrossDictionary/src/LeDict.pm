
use strict;
use warnings;

package LeDict;
my $base = "http://www.le-dictionnaire.com/definition.php?mot=";
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
# 2. find definition/node
# 3. extract all spans under the definition/node
#
# error cases
# 1. fail to make html tree (may never happen??)
# 2. don't find definition/node -> error, could not find definition
# 3. don't find any spans in definition/node -- not currently checking for this
#
sub parseContent {
    my ($self, $content) = @_;
    
    my $root = &WebUtil::makeTree($content);
    
    my @defs = $root->find_by_attribute("class", "arial-12-gris");
    my $def = $defs[0];
    if(!$def) {
        $root->delete();
        return {'error' => 'could not find definition'};
    }
    
    my @spans = $def->look_down("_tag", "span");
    my @words;
    for my $span (@spans) {
        push(@words, $span->as_text());
    }

    $root->delete();    
    return {'definition' => join(' ', @words)};
}

1;
