
use strict;
use warnings;

package Controller;
use Definition;
use Log::Log4perl qw(:easy);


sub new {
    my ($class) = @_;
    INFO("setting up controller");
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
    INFO("searching for <$searchPhrase>");
    my %responses = Definition::getDefinitions($searchPhrase);
    
    for my $dict (keys %responses) {
        INFO("formatting definition for <$dict>");
    	my $formDef = &formatDefinition($responses{$dict});
    	INFO("setting definition in GUI: <$formDef>");
        $self->{'gui'}->setDefinition($dict, $formDef);
    }
}

sub myExit {
	my ($self) = @_;
	INFO("exiting dictionary");
	# is there any clean-up to perform?
	exit;
}

sub formatDefinition {
	my ($def) = @_;
	my @parts;
	if(my $word = $def->{'word'}) {
		push(@parts, &formatPart('word', $word));
	}
	if(my $meaning = $def->{'meaning'}) {
		push(@parts, &formatPart('meaning', $meaning));
	}
	if(my $eg = $def->{'example'}) {
		push(@parts, &formatPart('example', $eg));
	}
	for my $part (keys %$def) {
		if(($part ne 'word') && ($part ne 'meaning') && ($part ne 'example')) {
			push(@parts, &formatPart($part, $def->{$part}));
		}
	}
	return join("\n\n", @parts);
}

sub formatPart {
	my ($key, $value) = @_;
	return "$key:  $value";
}

1;
