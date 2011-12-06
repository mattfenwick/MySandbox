
use strict;
use warnings;

package ComboBox;
use parent qw/WidgetBase/;



sub new {
    my ($class, $parent, $text, $isReadOnly, $values, $initialIndex) = @_;
    my $self = $class->SUPER::new($parent);
    my $frame = $self->{frame};
    $self->{label} = $frame->new_label(-text => $text);
    $self->{selected} = undef;
    $self->{'values'} = [];
    $self->{combobox} = $frame->new_ttk__combobox(-textvariable => \$self->{selected});
    if ($isReadOnly) {
        $self->{combobox}->configure(-state => 'readonly');
    }
    if ($values) {
        $self->setValues($values, $initialIndex);
    }
    $self->{label}->g_grid(-row => 0, -column => 0);
    $self->{combobox}->g_grid(-row => 1, -column => 0);
    #########
    $self->{frame}->configure(-borderwidth => 5);
    $self->{combobox}->g_bind("<<ComboboxSelected>>", sub {$self->setColor("green")} );
    #########
    return $self;
}


sub setValues {
    my ($self, $values, $initialIndex) = @_;
    $self->{combobox}->configure(-value => $values);
    if (defined($initialIndex) and scalar(@$values) > 0) {# possible bug resulting from and ...
        $self->{combobox}->current($initialIndex);
    }
}


sub getSelected {
    my ($self) = @_;
    return $self->{selected};
}


sub setAction {
    my ($self, $coderef) = @_;
    die "ComboBox action requires coderef" unless (ref $coderef eq "CODE");
    $self->{combobox}->g_bind("<<ComboboxSelected>>", 
        sub {
            &{$coderef}($self->getSelected());
            $self->setColor("red"); # highlight when changed
        }
    );
}


sub setColor {
    my ($self, $color) = @_;
    warn "changing color to <$color>";
    $self->{frame}->configure(-background => $color);
}


sub setSelectedIndex {
    my ($self, $index) = @_;
    $self->{combobox}->current($index);
}


sub setSelected {
    my ($self, $selection) = @_;
    $self->{selected} = $selection;
}


1;