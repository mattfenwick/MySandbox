use strict;
use warnings;


package GridGrid;
use Data::Dumper;


sub new {
    my ($class, $frame, $controller) = @_;
    my $self = {
        frame      => $frame,
        controller => $controller,
        things     => {},
        rowNum     => 1
    };
    bless($self, $class);
    
    $self->{newThing} = $self->makeNewMaker();
    
    $self->displayRows();
    
    return $self;
}


sub doScrollbar {
    my ($self) = @_;
    my $frame = $self->{frame};
    $self->{scrollbar} = $frame->new_ttk__scrollbar(-orient => 'vertical', 
            -command => [$frame, 'yview']);
    $frame->configure(-yscrollcommand => [$self->{scrollbar}, 'set']);
    
    $self->{scrollbar}->g_grid(-row => 0, -column => 1, -sticky => 'ns', -rowspan => 20);
}


sub makeNewMaker {
    my ($self) = @_;
    
    my $ph = $self->{frame}->new_ttk__button(
#        -width => 20,
        -text => 'do new thing',
        -command => sub {
            my $x = $self->{rowNum};
            my $nt = $self->{frame}->new_ttk__button(
                -text => "remove me: $x",
                -command => sub {$self->removeRow($x);}
            );
            $self->addRow($nt);
        }
    );
    print Dumper($self->{frame}->config());
    $ph->g_grid();
    
}


sub addRow {
    my ($self, $nt) = @_;
    my $x = $self->{rowNum};
    $nt->g_grid(-column => 0);
    $self->{things}->{$x} = $nt;
    $self->{rowNum}++;
}


sub setRows {
    my ($self, @things) = @_;
    $self->undisplayRows();
    $self->{rowNum} = 1;
    $self->displayRows(@things);
}


sub removeRow {
    my ($self, $id) = @_;
    print "removing $id\n";
    my $t = $self->{things}->{$id};
    $t->g_grid_remove();
    $t->Tkx::destroy();
    delete($self->{things}->{$id});
    print "after delete: " . Dumper($self->{things});
}


sub displayRows {
    my ($self, @things) = @_;
    for my $thing (@things) {
        $self->addRow($thing);
    }
}


sub undisplayRows {
    my ($self) = @_;
    for my $id (keys %{$self->{things}}) {
        $self->removeRow($id);
    }
}


1;