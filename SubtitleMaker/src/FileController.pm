
package FileController;


use strict;
use warnings;
use FileGUI;
use Data;
use ParsingUtilities;
use SRTEntry;
use SRTTime;
use SRTQuote;


# public functions:
#	new(class, parent gui, open a file)		--> new FileController instance
#	entryEvent(self, event string)
#	cleanUp(self)
#	fileEvent(self, event string, file path)
#
# private functions:
#	updateGUI(self)
#	getFromGUIAsEntry(self)				--> SRTEntry composed of current data
#	getTimes(time)	[static]			--> (hour, minute, second, millisecond)
#	saveFile(self)
#	saveFileAs(self)
#	openFile(self)
#	writeToFile(self)
#	updateTimeFields(self)


sub new {
	my ($class, $maingui, $name, $openfile, $listener) = @_;
	my $self = {listener => $listener,
			name => $name,
	};
	bless($self, $class);
	my ($index, $entry, $text, $windowname);
	if($openfile) {
		$self->openFile();
		if($self->{data}->getLength() > 0) {
			$entry = $self->{data}->getEntry(0);
		}
	} else {
		$self->{data} = Data->new();
		$self->{savepath} = "Untitled";
	}
	$index = 1;
	$text = ParsingUtilities::getAsSRTFormattedText($self->{data}->getEntries());
	$windowname = $self->{savepath};
	my $filegui = FileGUI->new($maingui->new_toplevel(), $self, $index, $entry, $text, $windowname);
	$self->{gui} = $filegui;
	return $self;
}

sub getName {
	my ($self) = @_;
	return $self->{name};
}

sub getEvent {
	my ($self, $event, $options) = @_;
	my %options = %$options;
	my ($newindex, $newentry, $newtext, $newwindowname);
	if($event eq "add") {
		$self->{data}->addEntry($options{entry}, $options{index} - 1);
		$newindex = $options{index} + 1;
		$newtext = ParsingUtilities::getAsSRTFormattedText($self->{data}->getEntries());
	} elsif($event eq "remove") {
		$self->{data}->removeEntry($options{index} - 1);
		unless($options{index} == 1) {
			$newindex = $options{index} - 1;
		}
		$newtext = ParsingUtilities::getAsSRTFormattedText($self->{data}->getEntries());
	} elsif($event eq "edit") {
		$newentry = $self->{data}->getEntry($options{index} - 1);
	} elsif($event eq "replace") {
		$self->{data}->replaceEntry($options{entry}, $options{index} - 1);
		$newtext = ParsingUtilities::getAsSRTFormattedText($self->{data}->getEntries());
	} elsif($event eq "closeWindow") {
		$self->{listener}->getFileEvent("closeFileWindow", $self);
		return;
	} elsif($event eq "save") {
		$self->saveFile();
	} elsif($event eq "saveAs") {
		$self->saveFileAs();
	} elsif($event eq "open") {
		warn("I really want to check whether changes have been made before asking whether to save");
		my $save = Tkx::tk___messageBox(-message => "Save file?", -type => "yesno");
		if($save eq "yes") {
			$self->saveFile();
		}
		$self->openFile();
	} elsif(($event eq "manual") || ($event eq "about")) {
		$self->{listener}->getFileEvent($event);
	} else {
		die "invalid event: $event";
	}
	$newwindowname = $self->{savepath};
	$self->{gui}->update($newindex, $newentry, $newtext, $newwindowname);
}

sub cleanUp {
	my ($self) = @_;
	my $savename = $self->{savepath} || "Untitled";
	my $answer = Tkx::tk___messageBox(-message => "Save file <$savename>?", -type => "yesno");
	if($answer eq "yes") {
		$self->saveFile();
	}
	print "here's my gui: $self->{gui}->{widget}\n";
	$self->{gui}->destroy();
}


sub saveFileAs {
	my ($self) = @_;
	my $path = &Tkx::tk___getSaveFile();
	return unless $path;# in case user cancels
	$self->{savepath} = $path;
	$self->{gui}->setWindowName($path);
	$self->writeToFile();
}

sub saveFile {
	my ($self) = @_;
	if($self->{savepath}) {
		$self->writeToFile();
	} else {
		$self->saveFileAs();
	}
}

sub writeToFile {
	my ($self) = @_;
	my $path = $self->{savepath};
	if(!$path) {
		die "why is the path undefined??";
	}
	open(my $file, ">$path") || die "can't open file for writing";
	my $text = ParsingUtilities::getAsSRTFormattedText($self->{data}->getEntries());
	print $file $text;
	close($file);
}

sub openFile {
	my ($self) = @_;
	my $path = &Tkx::tk___getOpenFile();
	if(!$path) {
		$self->{data} = Data->new();
		$self->{savepath} = "";
		return;
	}
	my $entries = ParsingUtilities::parseFile($path);
	my $datamodel = Data->new($entries);
	# blow away old data model if there was one already
	$self->{data} = $datamodel;
	$self->{savepath} = $path;
}

1;