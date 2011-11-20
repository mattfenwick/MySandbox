package SRTQuote;


use strict;
use warnings;


# public methods:
#	new(class, quote)
#	getAsSRTFormattedText(self)
#
# private methods:
#	validate(self)
#

sub new {
	my ($class, $quote) = @_;
	my $self = {quote => $quote};
	bless($self, $class);
	$self->validate();
	return $self;
}

sub getAsSRTFormattedText {
	my ($self) = @_;
	return $self->{quote};
}



sub validate {
	my $self = shift @_;
	if(!$self->{quote}) {
		die "no text????";
	}
}

1;