#!/usr/local/ActivePerl-5.12/bin/perl

use strict;
use warnings;
use Tkx;
use GUI;
use Controller;


&simple_gui();


sub simple_gui {
    my $controller = Controller->new();
    my $gui = GUI->new($controller);
    $controller->setGUI($gui);
    
    Tkx::MainLoop;
}

