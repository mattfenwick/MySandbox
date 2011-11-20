
package Data;


use strict;
use warnings;



# public functions:
#	new(class, reference to list of SRTEntr[ies])	--> new Data instance
#	pushEntry(self, new entry)
# 	addEntry(self, new entry, index of insertion point)
#	replaceEntry(self, new entry, index of insertion)
#	removeEntry(self, index of entry to-be-removed)
#	getEntry(self, index)					--> entry at requested index
#	getEntries(self)						--> reference to list of entries
#	getLength(self)						--> number of entries
#	clearText(self)


################
# create a new instance
# args:
#	optional: $entries
#
################
sub new {
	my ($class, $entries) = @_;
	my $self = {text => []};
	bless($self, $class);
	if(defined($entries)) {
		for my $entry (@$entries) {
			$self->pushEntry($entry);
		}
	}
	return $self;
}


sub pushEntry {
	my ($self, $newentry) = @_;
	my $index = $self->getLength();
	$self->addEntry($newentry, $index);
}


sub getEntries {
	my ($self) = @_;
	return $self->{text};
}


################
# push an entry onto the end of the list of entries
#
# args: \@ -> a, $ -> index
# forms:
#	index: integer between 0 and scalar(@text)
################
sub addEntry {
	my ($self, $new, $index) = @_;
	unless(ref $new eq "SRTEntry") {
		&main::exception("addEntry needs a SRTEntry reference\n");
	}
	my $length = $self->getLength();
	if($index < 0 || $index > $length) {
		&main::exception("index must be between 0 and $length (was: $index)\n");
	}
	my @text = @{$self->{text}};
	@text = (@text[0..$index-1], $new, @text[$index..$#text]);# insert new element into @text
	$self->{text} = \@text;
}


################
# replace an entry with a new entry: overwrite the entry with the selected index
#
# args: \@ -> a, $ -> index
# forms: 
#	index: integer between 0 and $#text
################
sub replaceEntry {
	my ($self, $new, $index) = @_;
	unless(ref $new eq "SRTEntry") {
		&main::exception("addEntry needs a SRTEntry reference\n");
	}
	my $length = $self->getLength();
	if($index < 0 || $index >= $length) {
		print "@{$self->{text}}\n";
		&main::exception("must replace existing entry (index >= 0 and <= $length) (was: $index\n)");
	}
	$self->{text}->[$index] = $new;
}


################
# returns the number of entries in $self->{text}
################
sub getLength {
	my ($self) = @_;
	return scalar(@{$self->{text}});
}


################
# args: $ -> index
# forms:
#	index: between 0 and $#text
# remove and return the specified entry (by index) if it exists,
#	otherwise throw an exception
################
sub removeEntry {
	my ($self, $index) = @_;
	my $length = $self->getLength();
	if($index < 0 || $index >= $length) {
		&main::exception("can't remove text: invalid index ($index)");
	} else {
		my @text = @{$self->{text}};
		my $return = $text[$index];
		@text = (@text[0..$index-1], @text[$index+1..$#text]);
			#there has got to be a better way to do this
		# just cut out the element with the selected index 
		$self->{text} = \@text;
		return $return;
	}
}


################
# args: $ -> index
# forms: 
#	index: between 0 and $#text
# returns an SRTEntry object
################
sub getEntry {
	my ($self, $index) = @_;
	my $length = $self->getLength();
	if($index < 0 || $index >= $length) {
		&main::exception("index outside allowed bounds ($index)\n");
	}
	return $self->{text}->[$index];
}


################
# args: none
# clears all entries from @text
################
sub clearText {
	my ($self) = @_;
	$self->{text} = [];
}

1;