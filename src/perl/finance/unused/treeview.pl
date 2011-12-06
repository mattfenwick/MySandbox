use strict;
use warnings;
use tmore;
use Tkx;

# so, what did I do?
# I made sure the frame changed its size, with sticky and columnconfigure(weight)
# I made sure the treeview changed its size, also with sticky and cc(weight)
# I added a horizontal scrollbar right under the treeview
# I added width and minwidth options to some columns, even though they gave
#        horribly inconsistent results


my @headings = qw/there are lots of words that are headings here and now/;
my @rows = ([qw/a b c d e z y x w v u/], [qw/f g h i j t s r q p o/]) x 15;

my $gui = Tkx::widget->new(".");
my $res = ResultViewer->new($gui, -borderwidth => 10, -relief => "sunken");
$gui->g_grid_columnconfigure(0, -weight => 1);
$gui->g_grid_rowconfigure(0, -weight => 1);
$res->g_grid(-sticky => 'nsew');
$res->displayResults([@headings], [@rows]);
&Tkx::MainLoop();



package ResultViewer;
use parent qw/tmore/;

####### public methods
#    displayResults (self, hash: keys: 'headings' and 'rows')
#    g_grid (self, options)
#
####### private methods
#    addScrollBar (self)
#    clearResults (self)
#    sortResults (self)


sub new {
    my ($class, $parent, @options) = @_;
    my $self = $class->SUPER::new($parent, @options);
    my $frame = $self->{frame};
    my $tree = $frame->new_ttk__treeview(-height => 35);
    $self->{tree} = $tree;
    $self->{itemids} = [];
    $self->{scrollbar} = $frame->new_ttk__scrollbar(-orient => 'vertical', 
            -command => [$tree, 'yview']);
    $self->setupWidgets();
    $self->{tree}->tag_configure("bluetag", -background => "green"); # new
    return $self;
}


sub displayResults {
    my ($self, $headings, $rows) = @_;
    $self->clearResults();
    my ($tree) = $self->{tree};
    my @headings = @$headings;
    my @rows = @$rows;
    $tree->configure(-columns => [@headings[1..$#headings]]);
    $tree->heading("#0", -text => $headings[0], -command => sub {$self->sortResults(0)});
    $tree->column("#0", -minwidth => 150);
    my @ids = ();
    for my $index (1..$#headings) {
        my $head = $headings[$index];
        my $command = sub {
            $self->sortResults($index);
        };
        $tree->heading($head, -text => $head, -command => $command);
        $tree->column($head, -minwidth => 100);
        $tree->column($head, -width => 100);
    }
    my $index = 0;
    for my $row (@rows) {
        my @row = @$row;
        my $id;
        if ($index % 2 == 0) {
            $id = $tree->insert("", "0", -text => $row[0], -values => [@row[1..$#row]]);        
        } else {
            $id = $tree->insert("", "0", -text => $row[0], -values => [@row[1..$#row]],
                -tags => "bluetag"); # new
            print "damn $id  ";
        }
        $index++;
        push(@ids, $id);
    }
    $self->{itemids} = [@ids];
    $self->{headings} = $headings;
    $self->{rows} = $rows;
}


sub clearResults {
    my ($self) = @_;
    my @ids = @{$self->{itemids}};
    for my $id (@ids) {
        $self->{tree}->delete($id);
    }
    $self->{headings} = [];
    $self->{rows} = [];
}


sub setupWidgets {
    my ($self) = @_;
    my $tree = $self->{tree};
    my $scrollbar = $self->{scrollbar};
    $self->{frame}->g_grid_columnconfigure(1, -weight => 1);
    $self->{frame}->g_grid_rowconfigure(0, -weight => 1);
    $tree->configure(-yscrollcommand => [$scrollbar, 'set']);
    $scrollbar->g_grid(-row => 0, -column => 0, -sticky => 'ns');
    $tree->g_grid(-row => 0, -column => 1, -sticky => 'nsew');

    my $xscroll = $self->{frame}->new_ttk__scrollbar(-orient => 'horizontal', 
            -command => [$tree, 'xview']);
    $tree->configure(-xscrollcommand => [$xscroll, 'set']);
    $xscroll->g_grid(-row => 1, -column => 1, -sticky => 'ew');
#    $self->{frame}->g_grid_columnconfigure(0, -weight => 1);
#    $self->{frame}->g_grid_columnconfigure(1, -weight => 1);
}


sub sortResults {
    my ($self, $column) = @_;
    my @headings = @{$self->{headings}};
    my @rows = @{$self->{rows}};
    my @sorted = sort 
        {
            abs($b->[$column]) <=> abs($a->[$column])
            || uc($b->[$column]) cmp uc($a->[$column])
        } 
        @rows;
    $self->displayResults([@headings], [@sorted]);
    print "in sort: @_\n";
}

