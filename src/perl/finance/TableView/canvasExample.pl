
use strict;
use warnings;
use Tkx;




my $gui = Tkx::widget->new(".");

#$gui->configure(-height)
#$gui->g_wm_maxsize(400, 250);

my $frame = $gui->new_frame();

my $canvas = $frame->new_canvas(-background => 'red', -scrollregion => "0 0 2000 2000");

$frame->g_grid();

$canvas->g_grid(-row => 1, -column => 1);

my $yscrollbar = $frame->new_ttk__scrollbar(-orient => 'vertical', 
        -command => [$canvas, 'yview']);

my $xscroll = $frame->new_ttk__scrollbar(-orient => 'horizontal', 
        -command => [$canvas, 'xview']);
        
        
$canvas->configure(-yscrollcommand => [$yscrollbar, 'set']);
$canvas->configure(-xscrollcommand => [$xscroll, 'set']);

$yscrollbar->g_grid(-column => 0, -row => 1, -sticky => 'ns');
$xscroll->g_grid(-column => 1, -row => 0, -sticky => 'ew');


for(my $i = 0; $i < 40; $i++) {
    my $label = $frame->new_label(-text => "damn $i");
    $canvas->create_window(40, $i * 25 + 20, -window => $label);
    $canvas->create_window($i * 50 + 40, 25, 
        -window => $frame->new_label(-text => "fuck $i"));
    my $x = $i;
    $canvas->create_window($i * 50 + 40, $i * 25 + 20, 
        -window => $frame->new_button(-text => "press me $i", -command => sub {warn $x;} ) );
#    $canvas->new_label(-text => "diarrhea $i")->g_grid();
#    $canvas->create_line(10 * $i, 10, 10 * $i, 50, -fill => "red", -width => 3);
}

&Tkx::MainLoop();