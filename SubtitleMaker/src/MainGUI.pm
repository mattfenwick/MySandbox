
package MainGUI;

use strict;
use warnings;
use Tkx;


# public functions:
#	new(class, listener)		--> a new MainGUI instance
#	getGUI(self)			--> the root gui widget of the MainGUI
#
# private functions:
#	makeMenu(self)			--> the menu
#	sendEvent(self, event)


sub new {
	my ($class, $listener) = @_;
	my $self = {gui => Tkx::widget->new("."),
		listener => $listener,
	};
	bless($self, $class);
	my $gui = $self->{gui};
	$gui->g_wm_minsize(100, 2);
	$gui->g_wm_title("Subtitle editor");
	$self->makeMenu();
	return $self;
}

sub getGUI {
	my ($self) = @_;
	return $self->{gui};
}

sub makeMenu {
	my ($self) = shift @_;
	my $gui = $self->{gui};
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
          -label => "New",
          -underline => 0,
          -accelerator => "Ctrl+N",
          -command => [\&sendEvent, $self, "new"]
	);
        $gui->g_bind("<Control-n>", [\&sendEvent, $self, "new"]);
        $file->add_command(
          -label   => "Exit",
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


sub sendEvent {
	my ($self, $event) = @_;
	$self->{listener}->getEvent($event);
}


1;