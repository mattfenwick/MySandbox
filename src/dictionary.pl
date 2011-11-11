#!/usr/local/ActivePerl-5.12/bin/perl

use strict;
use warnings;
use Tkx;
use GUI;

print "hi";
my $gui = GUI->new(3);
print "hi";
&Tkx::MainLoop();
print "hi";


# &simple_gui();


sub simple_gui {
    my $mw = &make_mainwindow();
    my $ent_but_frame = &make_entry_button_frame($mw);
    my $text_frame = &make_texts($mw);
    
    $ent_but_frame->g_grid(-row => 0, -column => 0);
    $text_frame->g_grid(-row => 0, -column => 1, -rowspan => 20);
    
    Tkx::MainLoop;
}

