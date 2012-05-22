package SRTTime;


use strict;
use warnings;


# public:
#	new(class, hour, minute, second, millisecond)	--> a new SRTTime instance
#	getHour(self)			--> the hour
#	getMinute(self)			--> the minute
#	getSecond(self)			--> the second
#	getMillisecond(self)		--> the millisecond
#	getAsSRTFormattedText(self)	--> a string representing the object in SRT format 
#
# private:
#	validate(self)
#	validateTimeSubfield(time, low end of range, high end) : static	--> 1 if okay (exception otherwise)
#	zeroFill(number, final desired length) : static				--> a zero-filled number


################
# construct a new SRTTime
# 
# args: class, hours, minutes, seconds, milliseconds
#
# 
################
sub new {
	my ($class, $hour, $minute, $second, $millisecond) = @_;
	for my $var (@_[0..4]) {
		if(!defined($var)) {
			die "SRTTime constructor needs five values";
		}
	}
	my $self = {hour => $hour, 
		minute => $minute, 
		second => $second,
		millisecond => $millisecond
	};
	bless($self, $class);
	$self->validate();
	return $self;
}

sub getHour {
	my ($self) = @_;
	return $self->{hour};
}

sub getMinute {
	my ($self) = @_;
	return $self->{minute};
}

sub getSecond {
	my ($self) = @_;
	return $self->{second};
}

sub getMillisecond {
	my ($self) = @_;
	return $self->{millisecond};
}


################
# get .srt formatted time string (hh:mm:ss,mmm)
#
# args: \@ -> time
# forms:
#	time: [hours, minutes, seconds, milliseconds]
# returns a string
################
sub getAsSRTFormattedText {
	my ($self) = @_;
	my $hours = &zeroFill($self->{hour}, 2);
	my $minutes = &zeroFill($self->{minute}, 2);
	my $seconds = &zeroFill($self->{second}, 2);
	my $mills = &zeroFill($self->{millisecond}, 3);
	return "$hours:$minutes:$seconds,$mills";
}


################ doesn't enforce number ranges for start and stop time
# check syntax of an entry
#
# args: SRTTime
# 
# forms:
#	starttime, stoptime: (n1,n2,n3,n4) where n2, n3 between 0 and 59, n4 between 0 and 999 and has
#	three digits, while n1,n2,n3 have 2 digits (must include leading zeroes)
#		n1, n2, n3, n4: hours, minutes, seconds, milliseconds
################
sub validate {
	my $self = shift @_;
	&validateTimeSubfield($self->{hour}, 0);
	&validateTimeSubfield($self->{minute}, 0, 60);
	&validateTimeSubfield($self->{second}, 0, 60);
	&validateTimeSubfield($self->{millisecond}, 0, 1000);
}


################
# static
# checks whether a time field is within the (optional) bounds
#	returns 1 if time field is okay
################
sub validateTimeSubfield {
	my ($time, $low, $high) = @_;
	if($time !~ /^\d+/) {
		die("unacceptable input for time: <$time>");
	}
	if(defined($low) && time < $low) {
		die("time format error: too low ($time)");
	}
	if(defined($high) && $time >= $high) {
		die("time format error: too high ($time)");
	}
	return 1;
}


################
# static
# returns a number filled with leading zeroes (up to $finallength)
# 
# args: $ -> number, $ -> finallength
# forms:
#	number: the number to be filled out
#	finallength: the final total length of the number
################
sub zeroFill {
	my ($number, $finallength) = @_;
	my $add = $finallength - length $number;
	if(length $number > 3) {
		die("3 digit or longer number???? ($number)");
	}
	for(my $i = 0; $i < $add; $i++) {
		$number = "0".$number;
	}
	return $number;
}



1;