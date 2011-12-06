use strict;
use warnings;


package TableView::Record;
use parent qw/WidgetBase/;


sub new {
    my ($class, $parent, $controller) = @_;
    my $self = $class->SUPER::new($parent);
    my $frame = $self->{frame};
    $self->{controller} = $controller;
    
    my $validator = sub { die "bad amount: $_[0]" 
                unless $_[0] =~ /^\d+(?:\.\d{0,2})?$/; };
        # a $ amount is at least 1 digit,
        #        followed by an optional decimal and up to 0-2 digits 
    $self->{amount} = LabelEntry->new($frame, '', $validator);
    $self->{amount}->g_grid(-row => 0, -column => 0);

    $self->{comment} = ComboBox->new($frame, '', 0,
#        $self->getComments(), 0);
        [qw/blargh a bag/], 0); # a joke
    $self->{comment}->g_grid(-row => 0, -column => 1);
    
    $self->{year} = ComboBox->new($frame, '', 0,
        $self->{controller}->getYears(), 0);
    my $currentYear = 2011;
    $self->{year}->setSelected($currentYear);
    $self->{year}->g_grid(-row => 0, -column => 2);
    
    $self->{month} = ComboBox->new($frame, '', 1,
        $self->{controller}->getMonths(), 0);
    $self->{month}->g_grid(-row => 0, -column => 3);
    
    $self->{day} = ComboBox->new($frame, '', 1,
        [0 .. 31], 1);
    $self->{day}->g_grid(-row => 0, -column => 4);
    
    $self->{account} = ComboBox->new($frame, '', 1,
        $self->{controller}->getAccounts(), 0);
    $self->{account}->g_grid(-row => 0, -column => 5);
    
    $self->{type} = ComboBox->new($frame, '', 1,
        $self->{controller}->getTransactionTypes(), 0);
    $self->{type}->g_grid(-row => 0, -column => 6);
    
    $self->{isReceipt} = 0;
    $self->{isBankConfirmed} = 0;
    $frame->new_ttk__checkbutton(
        -variable => \$self->{isReceipt})->g_grid(-row => 0, -column => 7, -pady => 5);
    $frame->new_ttk__checkbutton(
        -variable => \$self->{isBankConfirmed})->g_grid(-row => 0, -column => 8, -pady => 5);
        
    return $self;
}


sub displayTransaction {
    my ($self, $result) = @_;
    use Data::Dumper;
    print "transaction being displayed: " . Dumper($result) . "\n";
    $self->{comment}->setSelected($result->{comment});
    $self->{account}->setSelected($result->{account});
    $self->{year}->setSelected($result->{year});
    $self->{month}->setSelected($result->{month});
    $self->{day}->setSelected($result->{day});
    $self->{amount}->setText($result->{amount});
    $self->{isReceipt} = $result->{isreceiptconfirmed};
    $self->{isBankConfirmed} = $result->{isbankconfirmed};
    $self->{type}->setSelected($result->{type});
}


1;