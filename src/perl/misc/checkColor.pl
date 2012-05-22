
use strict;
use warnings;
use Tkx;
use ComboBox;

my $gui = Tkx::widget->new(".");

$gui->g_wm_minsize(300, 200);

my $c = $gui->new_ttk__checkbutton(-text => 'have receipt for transaction');
        #-variable => \$self->{isReceipt},
        #-command => sub {$self->{receiptW}->configure(-background => "red");} );
        
my $frame = $gui->new_frame();
$frame->g_grid();

my $cb = ComboBox->new($frame, 'whatever', 0);
$cb->g_grid();
        
$c->g_grid(-sticky => 'nsew');
#print $c->configure();
#$c->configure(-borderwidth => 15);
#$c->configure(-background => "red");

&Tkx::MainLoop();