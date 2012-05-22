use strict;
use warnings;
use Tkx;
use Data::Dumper;


my $gui = Tkx::widget->new(".");

#$gui->g_wm_maxsize(600, 400);

my $frame = $gui->new_frame(-height => 200, -width => 200);
$frame->g_grid(-row => 0, -column => 0);#place(-relheight => 1, -relwidth => .9);
#print($frame->config() . "\n\n");

my $lb = $gui->new_canvas(-height => 50);#tk__listbox(-height => 5);
$lb->g_grid(-column => 0, -row => 0, -sticky => "nwes");

for (my $i = 0; $i < 100; $i++) {
    $lb->new_ttk__button(-text => "blargh $i")->g_grid();
#   $lb->insert("end", "Line " . $i . " of 100");
}

my $scr = $gui->new_ttk__scrollbar(-orient => 'vertical', 
        -command => [$lb, 'yview']);
$lb->configure(-yscrollcommand => [$scr, 'set']);
$scr->g_grid(-column => 1, -row => 0, -sticky => 'ns');
  #place(-relx => .9, -width => 20, -height => 400);

#for my $x (0 .. 25) {
#    print "x: $x\n";
#    $canv->new_ttk__button(
#        -text => "some text $x", -width => 50
#    )->g_place(
#        -y => 60 * $x, -height => 60, -relwidth => .75
#    );#-sticky => 'nsew');
#}

&Tkx::MainLoop();