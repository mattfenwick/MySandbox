
use strict;
use warnings;

package Controller;
use Definition;


sub new {
	my ($class) = @_;
	my $self = {'gui' => undef};
	bless($self, $class);
	return $self;
}

sub setGUI {
	my ($self, $gui) = @_;
	$self->{'gui'} = $gui;
}

sub search {
	my ($self, $searchPhrase) = @_;
	my %responses = Definition::getDefinitions($searchPhrase);
	for my $dict (keys %responses) {
		$self->{'gui'}->setDefinition($dict, $responses{$dict});
	}
}

1;
