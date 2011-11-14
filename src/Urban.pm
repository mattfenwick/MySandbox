
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

sub parseContent {
    my ($self, $content) = @_;
    my $root = &WebUtil::makeTree($content);
    my @outs = ("urban or something");
    my @defs = $root->find_by_attribute("class", "definition");
    my @egs = $root->find_by_attribute("class", "example");
    for(my $i = 0; $i <= $#defs; $i++) {
        push(@outs, $defs[$i]->as_text()."\nexample:  ".$egs[$i]->as_text());
    }
    $root->delete();
    return \@outs;
}

1;
