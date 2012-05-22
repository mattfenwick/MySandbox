use strict;
use warnings;
use Tkx;
use Data::Dumper;


my $gui = Tkx::widget->new(".");

#$gui->g_wm_maxsize(600, 400);

my $frame = $gui->new_frame(-height => 200, -width => 200);
$frame->g_grid(-row => 0, -column => 0);#place(-relheight => 1, -relwidth => .9);
#print($frame->config() . "\n\n");

$gui->columnconfigure(0, -weight => 1);

my $canv = $frame->new_tk__canvas(-scrollregion => "0 0 1000 1000");
$canv->g_grid();#place(-relheight => 1, -relwidth => 1);

my $scrollbar = $gui->new_ttk__scrollbar(-orient => 'vertical', 
        -command => [$canv, 'yview']);
$canv->configure(-yscrollcommand => [$scrollbar, 'set']);
$scrollbar->g_grid(-column => 1, -row => 0, -sticky => 'ns');
  #place(-relx => .9, -width => 20, -height => 400);

for my $x (0 .. 10) {
    print "x: $x\n";
    $canv->new_ttk__button(
        -text => "some text $x", -width => 50
    )->g_grid(#)place(
        #-y => 60 * $x, -height => 60, -relwidth => .75
    );#-sticky => 'nsew');
}

#print "config 2: " . $frame->config();

&Tkx::MainLoop();