
package LabelEntry;


use strict;
use warnings;

# public functions:
#	new(class, frame that will contain the object's widgets, text of the label)
#					--> a new LabelEntry instance
#	getText(self)			--> the text in the entry widget
#	setText(self)
#
# private functions:
#

sub new {
	my ($class, $frame, $text) = @_;
	my $self = {
		frame => $frame,
		label => $frame->new_label(-text => $text),
		entry => undef,
		text => "",
	};
	my $entry = $frame->new_entry(-textvariable => \$self->{text});
	$self->{entry} = $entry;
	$self->{label}->g_grid(-row => 0, -pady => 5);
	$self->{entry}->g_grid(-row => 1, -pady => 5);
#	$frame->configure(-relief => 'raised', -bd => 2, -background => 'blue');
	bless($self, $class);
	return $self;
}


sub getText {
	my ($self) = @_;
	return $self->{text};
}

sub setText {
	my ($self, $newtext) = @_;
	$self->{text} = $newtext;
}

1;