package MainController;

use strict;
use warnings;
use MainGUI;
use FileController;

# public functions:
#	new(class)		--> new MainController instance
#	getEvent(self, event string)
#	getFileEvent(self, event string, filecontroller)
#
# private functions:
#	newFileController(self, ask if file should be opened)
#	cleanUp(self)
#	cleanUpFile(self, file controller)
#	addFile(self, file controller)
#	getUniqueNumber(self)

sub new {
	my ($class) = @_;
	my $self = {files => {},
		namenumber => 1,
	};
	$self->{maingui} = MainGUI->new($self);
	bless($self, $class);
	return $self;
}

sub getEvent {
	my ($self, $event) = @_;
	print "got event: $event\n";
	if($event eq "open") {
		$self->newFileController(1);
	} elsif($event eq "new") {
		$self->newFileController(0);
	} elsif($event eq "closeWindow") {
		$self->cleanUp();
		$self->{maingui}->{gui}->Tkx::destroy();
	} elsif($event eq "manual") {
		&manual();
	} elsif($event eq "about") {
		&about();
	} else {
		die "invalid event: $event";
	}
}

sub getFileEvent {
	my ($self, $event, $filecontroller) = @_;
	if($event eq "closeFileWindow") { # close the filecontroller
		$self->cleanUpFile($filecontroller);
	} elsif($event eq "manual") {
		&manual();
	} elsif($event eq "about") {
		&about();
	} else {
		die "invalid event from file controller: $event";
	}
}


sub manual {
	die "unimplemented (but see ./manual.html)";
}

sub about {
	Tkx::tk___messageBox(-message => "This program was created and developed solely by Matt Fenwick (2010) in order to facilitate creating subtitles for RvB videos", -type => "ok");
}



sub newFileController {
	my ($self, $askOpenFile) = @_;
	my $filename = $self->getUniqueNumber();
	my $filecontroller = FileController->new($self->{maingui}->getGUI(), $filename, $askOpenFile, $self);
	$self->addFile($filecontroller);
}

sub cleanUp {
	my ($self) = @_;
	for my $filecontroller (values %{$self->{files}}) {
		$self->cleanUpFile($filecontroller);
	}
	$self->{files} = undef; # clear all the files
}

sub cleanUpFile {
	my ($self, $filecontroller) = @_;
	print "here's my main gui: $self->{maingui}->{gui}\n";
	$filecontroller->cleanUp();
	if(!exists($self->{files}->{$filecontroller->getName()})) {
		die "impossible!  where is it?  <$filecontroller>";
	}
	delete $self->{files}->{$filecontroller->getName()};
}

sub addFile {
	my ($self, $filecontroller) = @_;
	if(exists($self->{files}->{$filecontroller->getName()})) {
		die "impossible!  where did that come from?? <$filecontroller>";
	}
	$self->{files}->{$filecontroller->getName()} = $filecontroller;
}

sub getUniqueNumber {
	my ($self) = @_;
	my $number = $self->{namenumber};
	$self->{namenumber}++;
	return $number;
}

1;