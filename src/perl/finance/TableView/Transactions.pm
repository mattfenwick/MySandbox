use strict;
use warnings;


package TableView::Transactions;
use ComboBox;
use parent qw/WidgetBase/;
use TableView::Record;


sub new {
    my ($class, $parent, $controller) = @_;
    my $self = $class->SUPER::new($parent);
    my $frame = $self->{frame};
    $self->{controller} = $controller;
    
    $self->{filterFrame} = $self->{frame}->new_frame();
    $self->{viewFrame} = $self->{frame}->new_canvas(-height => 5);
    
    $self->{year} = ComboBox->new($self->{filterFrame}, 'year', 0,
        $self->{controller}->getYears(), 0);
    my $currentYear = 2011;
    $self->{year}->setSelected($currentYear);
    $self->{year}->g_grid();
    
    $self->{month} = ComboBox->new($self->{filterFrame}, 'month', 1,
        $self->{controller}->getMonths(), 0);
    $self->{month}->g_grid();
    
    my $command = sub {
        use Data::Dumper;
        my $year = $self->{year}->getSelected();
        my $month = $self->{month}->getSelected();
        my $result = $self->{controller}->getMonthOfTransactions($month, $year);
        $self->displayTransactions($result);
        print "result: " . Dumper($result);
    };
    $self->{fetchButton} = $self->{filterFrame}->new_ttk__button(-text => 'Fetch month',
        -command => $command);
    $self->{fetchButton}->g_grid();
    
    $self->{filterFrame}->g_grid(-column => 0, -row => 0);
    $self->{viewFrame}->g_grid(-column => 2, -row => 0, -rowspan => 15);
    
    $self->setupScrollBars();
    
    return $self;
}


sub setupScrollBars {
    my ($self) = @_;
    
    $self->{yscrollbar} = $self->{frame}->new_ttk__scrollbar(-orient => 'vertical', 
            -command => [$self->{viewFrame}, 'yview']);
            
    $self->{viewFrame}->configure(-yscrollcommand => [$self->{yscrollbar}, 'set']);
    
    $self->{yscrollbar}->g_grid(-row => 0, -column => 1, -rowspan => 5);
}


sub displayTransactions {
    my ($self, $trans) = @_;
    my @trans = @$trans;
    $self->clearTransactions();
    my $row = 0;
    for my $tran (@trans) {
        my $rec = TableView::Record->new($self->{viewFrame}, $self->{controller});
        $rec->displayTransaction($tran);
        $rec->g_grid(-column => 0, -row => $row);
#        $frame->new_label(-text => $tran->{id})->g_grid(-row => $x, -column => 2);
#        $frame->new_ttk__checkbutton(
#            -text => 'bank confirms transaction')->g_grid(-pady => 5,
#            -row => $x, -column => 3);
        $row++;
    }
}


sub clearTransactions {
    my ($self) = @_;
    warn "not implemented";
}


1;