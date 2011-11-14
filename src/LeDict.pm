
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

sub parseContent {
    my ($self, $content) = @_;
    my $root = &WebUtil::makeTree($content);
    my @outs = ("le dictionnaire or something");
    my @defs = $root->find_by_attribute("class", "arial-12-gris");
    push(@outs, $defs[0]->as_text());
    $root->delete();
    return \@outs;
}

1;
