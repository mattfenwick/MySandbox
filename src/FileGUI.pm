
package FileGUI;


use strict;
use warnings;
use LabelEntry;
use SRTQuote;
use SRTTime;
use SRTEntry;


# public functions:
#	new(class, toplevel window, event listener, window name)	--> ${new instance of FileGUI}
#	update(self, index, entry, text)
#	destroy(self)
#
# user events
#	sendEvent(self, event string)	
#
# private functions:
#	setTextBoxContents(self, text)
#	getIndex(self)					--> ${line index}
#	setIndex(self, line index)
#	getQuote(self)						--> SRTQuote
#	setQuote(self, SRTQuote)
#	getTime(self, timestring)				--> SRTTime
#	setTime(self, SRTTime)
#	setWindowName(self, name)
#	setEntry(self, SRTEntry)
#	getEntry(self)						--> SRTEntry representing current state of fill-in GUI
#
# constructor extensions (for setting up the GUI):
#	registerWidget(self, name of widget, widget)
#	makeTextFrame(self, width of text frame)		--> ${frame containing the child widgets}
#	makeButtonFrame(self, parent widget)			--> ${frame containing the child widgets}
#	makeEditFrame(self, parent widget)			--> ${frame containing the child widgets}
#	makeQuoteFrame(self)					--> ${frame}
#	makeTimeEntry(self, parent widget, name prefix)		--> ${frame containing the child widgets}
#	makeMenu(self)						--> ${the menu}


sub new {
	my ($class, $toplevel, $listener, $index, $entry, $text, $windowname) = @_;
	my $self = {widget => $toplevel,
		listener => $listener,
		textbox => undef,
		quote => "",
		starttime => undef,
		stoptime => undef,
	};
	bless($self, $class);
	$self->makeTextFrame(70);
	$self->makeButtonFrame($self->{widget});
	$self->makeEditFrame($self->{widget});
	$self->makeQuoteFrame();
	$self->makeMenu();
	$self->update($index, $entry, $text, $windowname);
	return $self;
}

sub update {
	my($self, $index, $entry, $text, $windowname) = @_;
	if ($index) {$self->setIndex($index)};
	if ($entry) {$self->setEntry($entry)};
	if ($text) {$self->setTextBoxContents($text)};
	if ($windowname) {$self->setWindowName($windowname)};
}

sub destroy {
	my($self) = @_;
	$self->{widget}->Tkx::destroy();
}


############# private 


sub setWindowName {
	my ($self, $name) = @_;
	$self->{widget}->g_wm_title($name);
}


sub setEntry {
	my ($self, $entry) = @_;
	print "look: \n<".$entry->getAsSRTFormattedText().">\n\n";
	my $start = $entry->getStartTime();
	my $stop = $entry->getStopTime();
	$self->setTime($start, "starttime");
	$self->setTime($stop, "stoptime");
	$self->setQuote($entry->getQuote());
}

sub getEntry {
	my ($self) = @_;
	my $entry = SRTEntry->new($self->getTime('starttime'), $self->getTime('stoptime'), $self->getQuote());
	print "and see: \n<".$entry->getAsSRTFormattedText().">\n\n";
	return $entry;
}

sub setTextBoxContents {
	my ($self, $text) = @_;
	$self->{textbox}->delete("1.0", "end");
	$self->{textbox}->insert("end", $text);
}

sub getIndex {
	my ($self) = @_;
	return $self->{lineindex}->getText();
}

sub setIndex {
	my ($self, $index) = @_;
	$self->{lineindex}->setText($index);
}

sub getQuote {
	my ($self) = @_;
	my $quote = $self->{quote}->get("1.0", "end");
	$quote =~ s/[\n\r\f]*$//;
	return SRTQuote->new($quote);
}

sub setQuote {
	my ($self, $newquote) = @_;
	$self->{quote}->delete("1.0", "end");
	$self->{quote}->insert("end", $newquote->getAsSRTFormattedText());
}


####
# returns SRTTime
####
sub getTime {
	my ($self, $timestring) = @_;
	local $/;
	my @widgets = @{$self->{$timestring}};
	my @times = map {$_->getText()} @widgets;
	return SRTTime->new(@times);
}

####
# needs SRTTime
####
sub setTime {
	my ($self, $newtime, $timestring) = @_;
	my @widgets = @{$self->{$timestring}};
	$widgets[0]->setText($newtime->getHour());
	$widgets[1]->setText($newtime->getMinute());
	$widgets[2]->setText($newtime->getSecond());
	$widgets[3]->setText($newtime->getMillisecond());
}



############################# private methods
######## these few are activated by user-precipitated events

sub sendEvent {
	my ($self, $event) = @_;
	my %options = ();
	if(($event eq 'add') || ($event eq 'replace')) {
		$options{entry} = $self->getEntry();
		$options{index} = $self->getIndex();
	} elsif(($event eq 'remove') || ($event eq 'edit')) {
		$options{index} = $self->getIndex();
	} # else nothing to do		
	$self->{listener}->getEvent($event, \%options);
}



######## one-off methods for setting up the gui

sub registerWidget {
	my ($self, $widgetname, $widget) = @_;
	$self->{$widgetname} = $widget;
}

sub makeTextFrame {
	my ($self, $width) = @_;
	my $frame = $self->{widget}->new_frame();
	my $textbox = $frame->new_tk__text(-width => $width, -height => 35, -wrap => "word");
	my $scrollbar = $frame->new_ttk__scrollbar(-orient => 'vertical', 
		-command => [$textbox, 'yview']);
	$textbox->configure(-yscrollcommand => [$scrollbar, 'set']);
	$textbox->g_grid(-row => 0, -column => 0);
	$scrollbar->g_grid(-row => 0, 
		-column => 1, -sticky => 'ns');
	$frame->g_grid(-row => 0, 
		-column => 1, -rowspan => 3);
	$self->registerWidget('textbox', $textbox);
	$frame->configure(-bd => 5);
	return $frame;
}


sub makeButtonFrame {
	my ($self, $main) = @_;
	my $frame = $main->new_frame();
	my $i = 0;
	for my $name (qw/add remove edit replace/) {
		$frame->new_button(-text => "$name entry",
			-command => [\&sendEvent, $self, $name])->g_grid(-row => ($i % 2), 
			-column => int($i / 2), -pady => 10, -padx => 10, -sticky => 'ew');
		$i++;
	}
	$frame->g_grid(-row => 1, -column => 0, -padx => 10);
	return $frame;
}

sub makeEditFrame {
	my ($self, $main) = @_;
	my $frame = $main->new_frame();
	my $start = $self->makeTimeEntry($frame, "start");
	my $stop = $self->makeTimeEntry($frame, "stop");
	$start->g_grid(-row => 1, 
		-column => 0);
	$stop->g_grid(-row => 1, 
		-column => 1);
	my $index = LabelEntry->new($frame->new_frame(), "index");
	$index->setText('1');
	$index->{frame}->g_grid(-pady => 10, 
		-sticky => 'ew', -column => 0, 
		-row => 0, -columnspan => 2);
	$self->registerWidget('lineindex', $index);
	$frame->g_grid(-row => 0, 
		-column => 0, -padx => 10);
	return $frame;
}

sub makeQuoteFrame {
	my($self) = @_;
	my $frame = $self->{widget}->new_frame();
	my $quote = $frame->new_tk__text(-width => 35, -height => 10, -wrap => 'word');
	$quote->g_grid(-row => 2, 
		-column => 0,
		-columnspan => 2,
		-padx => 5,
		-pady => 5);
	$self->registerWidget('quote', $quote);
	$self->setQuote(SRTQuote->new("enter subtitle here"));
	$frame->g_grid(-row => 2, -column => 0);
	return $frame;
}

sub makeTimeEntry {
	my ($self, $main, $prefix) = @_;
	my $frame = $main->new_frame();
	my $label = $frame->new_label(-text => "$prefix time:");
	my $i = 0;
	$label->g_grid(-row => $i++, -column => 0);
	my @widgets;
	for my $wname (qw/hours minutes seconds milliseconds/) {
		my $entry = LabelEntry->new($frame->new_frame(), $wname);
		$entry->{frame}->g_grid(-row => $i++, -column => 0);
		$entry->setText('0');
		push(@widgets, $entry);
	}
	$frame->configure(-relief => 'raised', -bd => 5, -background => 'red', -padx => 10);
	$self->registerWidget("${prefix}time", [@widgets]);
	return $frame;
}

sub makeMenu {
	my ($self) = @_;
	my $gui = $self->{widget};
	my $menu = $gui->new_menu();

	my $file = $menu->new_menu(-tearoff => 0);
	$menu->add_cascade(
          -label => "File",
          -underline => 0,
          -menu => $file,
	);
	$file->add_command(
		-label => "Open",
		-accelerator => "Ctrl+O",
		-command => [\&sendEvent, $self, "open"],
	);
	$gui->g_bind("<Control-o>", [\&sendEvent, $self, "open"]);

	$file->add_command(
		-label => "Save",
		-accelerator => "Ctrl+S",
		-command => [\&sendEvent, $self, "save"],
	);
	$gui->g_bind("<Control-s>", [\&sendEvent, $self, "save"]);

	$file->add_command(
		-label => "Save as",
		-command => [\&sendEvent, $self, "saveAs"],
	);

      $file->add_command(
          -label   => "Close",
          -underline => 1,
          -command => [\&sendEvent, $self, "closeWindow"],
      );
  

      my $help = $menu->new_menu(
          -name => "help",
          -tearoff => 0,
      );
      $menu->add_cascade(
          -label => "Help",
          -underline => 0,
          -menu => $help,
      );
      $help->add_command(
          -label => "\uManual",
          -command => [\&sendEvent, $self, "manual"],
      );
  
      my $about_menu = $help;
      $about_menu->add_command(
          -label => "About",
          -command => [\&sendEvent, $self, "about"],
      );
	$gui->configure(-menu => $menu);
	return $menu;
}

1;
