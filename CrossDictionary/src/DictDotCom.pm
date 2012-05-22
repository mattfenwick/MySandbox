
use strict;
use warnings;

package DictDotCom;
my $base = "http://dictionary.reference.com/browse/";
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
    my @outs = ("dic.com or something");
    my @defs = $root->find_by_attribute("class", "luna-Ent");
    for(my $i = 0; $i <= $#defs; $i++) {
        push(@outs, $defs[$i]->as_text());
    }
    $root->delete();
    return \@outs;
}

1;
