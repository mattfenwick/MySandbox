
use strict;
use warnings;
use Tkx;

package GUI;

## messages to send to controller:
#    1. search for phrase
#        'search' button starts it
#        need to read entry box
#        future -- also listbox ??
#    2. exit
#        exit button starts it
#
## messages received:
#    1. display responses
#        write to each response display widget
#

my @dictionaries = ("urban", "dictDotCom", "wordRef", "leDict");
my $ARBITRARY_SIZE = 200;

####### public methods
# new
# setDefinition
#

sub new {
    my ($class, $controller) = @_;
    my $self = {'mw' => Tkx::widget->new("."),
        'controller' => $controller
    };
    bless($self, $class);
    my $mw = $self->{'mw'};
    $mw->g_wm_minsize($ARBITRARY_SIZE, $ARBITRARY_SIZE);
    $mw->g_wm_title("Cross-Dictionnaire");
    
    my $cFrame = $self->makeControlFrame();
    my $dFrame = $self->makeTextFrame();
    
    $cFrame->g_grid(-row => 0, -column => 0);
    $dFrame->g_grid(-row => 0, -column => 1);
    
    return $self;
}

sub setDefinition {
    my ($self, $dictName, $def) = @_;
    $self->{'dicts'}->{$dictName}->delete("1.0", "end");
    use Data::Dumper;
    $self->{'dicts'}->{$dictName}->insert("end", Dumper($def)); # or format the def a bit first 
}

############## callbacks
# myExit
#
# search
#

sub myExit {
    print "exiting now ...";
    exit; # or forward to controller
}

sub search {
    my ($self) = @_;
    print "I would search for " . $self->{'searchPhrase'} . " if I could\n";
#    for my $dict (@dictionaries) {
#    	$self->setDefinition($dict, $self->{'searchPhrase'} . $dict);
#    }
    $self->{'controller'}->search($self->{'searchPhrase'});
}

############## gui set-up methods
# makeControlFrame
# makeLabelEntry
# makeTextFrame

sub makeControlFrame {
    my ($self) = @_;
    my $frame = $self->{'mw'}->new_frame();
    $self->{'searchPhrase'} = "";
    $self->{'labEnt'} = $self->makeLabelEntry($frame->new_frame(),
        [-text => "Type entry here:"],
        [-textvariable => \$self->{'searchPhrase'}]);
    $self->{'submit'} = $frame->new_button(
        -text => "Submit", 
        -command => sub {$self->search()} );
    $self->{'exit'} = $frame->new_button(-text => "Exit", -command => \&myExit);

    $self->{'labEnt'}->g_grid(-row => 0, -column => 0, 
        -padx => 10, -pady => 20, -rowspan => 5);
    $self->{'submit'}->g_grid(-column => 0, -padx => 10, -pady => 10, -sticky => "ew");
    $self->{'exit'}->g_grid(-column => 0, -padx => 10, -pady => 10, -sticky => "ew");
    return $frame;
}

sub makeLabelEntry {
    my ($self, $frame, $labConf, $entConf) = @_;
    $self->{'label'} = $frame->new_label(@$labConf);
    $self->{'label'}->g_grid(-row => 0, -pady => 5);
    $self->{'entry'} = $frame->new_entry(@$entConf);
    $self->{'entry'}->g_grid(-row => 1, -pady => 5);
    return $frame;
}

sub makeTextFrame {
    my ($self) = @_;
    my $frame = $self->{'mw'}->new_frame();
    my $i = 0;
    for my $dict (@dictionaries) {
        my $text = $frame->new_tk__text(-width => 100, -height => 10, -wrap => "word");
        my $scroll = $frame->new_ttk__scrollbar(-orient => 'vertical', 
            -command => [$text, 'yview']);
        $text->configure(-yscrollcommand => [$scroll, 'set']);
        $text->g_grid(-row => $i, -column => 0, -pady => 10);
        $scroll->g_grid(-row => $i, -column => 1, -sticky => "ns", -pady => 10);
        $self->{'dicts'}->{$dict} = $text;
        $i++;
    }
    return $frame;
}
