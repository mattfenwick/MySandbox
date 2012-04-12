use strict;
use warnings;


package TranGrid;
use GridGrid;


sub new {
    my ($class) = @_;
    my $gui = Tkx::widget->new(".");
    $gui->g_wm_minsize(500, 200);
    my $self = {
        gui       => $gui,
        frame     => $gui->new_frame()
    };
    bless($self, $class);
    
    $self->makeLeftSide();
    $self->makeRightSide();
    
    $self->{frame}->g_grid();
    return $self;
}


sub makeLeftSide {
    my ($self) = @_;
    my $lframe = $self->{frame}->new_frame();
    
    my $sF = $lframe->new_ttk__button(
        -text => 'sort filter or whatever', 
        -command => sub {
            $self->{gg}->setRows($self->{rframe}->new_ttk__button(-text => "I don't do anything"),
                $self->{rframe}->new_ttk__button(-text => "me either"));
        }
    );
    
    $sF->g_grid();
    
    $lframe->g_grid(-column => 0, -row => 0);
}


sub makeRightSide {
    my ($self) = @_;
    my $rframe = $self->{frame}->new_frame(-padx => 200);#-height => 200, -width => 500);
    
    $rframe->g_grid(-column => 1, -row => 0);
    
    $self->{gg} = GridGrid->new($rframe, $self);
    
    $self->{rframe} = $rframe;
}


1;