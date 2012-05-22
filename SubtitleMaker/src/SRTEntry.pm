
package SRTEntry;


use strict;
use warnings;
use SRTTime;
use SRTQuote;

# public functions:
#	new(class, starttime, stoptime, quote)		--> new SRTEntry instance
#	getStartTime(self)		--> the start SRTTime
#	getStopTime(self)		--> the stop SRTTime
#	getQuote(self)		--> the SRTQuote
# 	getAsSRTFormattedText(self)			--> a string representing the object in SRT format,
#										including trailing newline
#
# private functions:
#	validate(self)


sub new {
	my ($class, $start, $stop, $quote) = @_;
	if((ref $start ne "SRTTime") || (ref $stop ne "SRTTime")) {
		die "SRTEntry needs start and stop to be SRTTime instances";
	}
	if(ref $quote ne "SRTQuote") {
		die "SRTEntry needs quote to be SRTQuote instance";
	}
	my $self = {start => $start, stop => $stop, quote => $quote};
	chomp($self->{quote});
	bless($self, $class);
	$self->validate();
	return $self;
}

sub getStartTime {
	my ($self) = @_;
	return $self->{start};
}

sub getStopTime {
	my ($self) = @_;
	return $self->{stop};
}

sub getQuote {
	my ($self) = @_;
	return $self->{quote};
}


sub getAsSRTFormattedText {
	my ($self) = @_;
	my $start = $self->{start}->getAsSRTFormattedText();
	my $stop = $self->{stop}->getAsSRTFormattedText();
	return "$start --> $stop\n".$self->{quote}->getAsSRTFormattedText()."\n";
}


################
# checks whether start time is before stop time
#
################
sub validate {
	my ($self) = @_;
	my ($start, $stop) = ($self->{"start"}, $self->{"stop"});
	if($start->getHour() < $stop->getHour()) {
		return;
	} elsif($start->getHour() > $stop->getHour()) {
		die "invalid values for hour";
	}
	if($start->getMinute() < $stop->getMinute()) {
		return;
	} elsif($start->getMinute() > $stop->getMinute()) {
		die "invalid values for Minute";
	}
	if($start->getSecond() < $stop->getSecond()) {
		return;
	} elsif($start->getSecond() > $stop->getSecond()) {
		die "invalid values for Second";
	}
	if($start->getMillisecond() < $stop->getMillisecond()) {
		return;
	} elsif($start->getMillisecond() > $stop->getMillisecond()) {
		die "invalid values for Millisecond";
	}
}


1;