use strict;
use warnings;
use Tkx;
use Data::Dumper;


my $gui = Tkx::widget->new(".");

my $frame = $gui->new_frame(-height => 200, -width => 200);
$frame->g_place(-relheight => 1, -relwidth => .9);
#print($frame->config() . "\n\n");
my $cav = $frame->new_canvas();#-height => 4000, -width => 4000);
$cav->g_place(-relheight => 1, -relwidth => 1);

my $scrollbar = $frame->new_ttk__scrollbar(-orient => 'vertical', 
        -command => [$frame, 'yview']);
$cav->configure(-yscrollcommand => [$scrollbar, 'set']);
$scrollbar->g_place(-relx => .9, -width => 20, -height => 400);

for my $x (1 .. 10) {
    print "x: $x\n";
    $cav->new_ttk__button(
        -text => "some text $x", -width => 50
    )->g_place(
        -rely => ($x - 1) / 5, -height => 20, -relwidth => .75
    );#-sticky => 'nsew');
}

#print "config 2: " . $frame->config();

&Tkx::MainLoop();