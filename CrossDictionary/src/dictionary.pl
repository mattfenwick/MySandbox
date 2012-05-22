#!/usr/local/ActivePerl-5.12/bin/perl

use strict;
use warnings;
use Tkx;
use GUI;
use Controller;
use Log::Log4perl qw(:easy);

BEGIN {
    Log::Log4perl->easy_init( 
        { level   => $DEBUG,
          file    => ">>dictionaryLog.txt",
          layout  => '%p  %F{1}-%L-%M: (%d) %m%n' 
        } 
    );
}

INFO("starting dictionary program");

eval {
    &simple_gui();
} || FATAL("program died, error message: " . $@);


sub simple_gui {
    my $controller = Controller->new();
    my $gui = GUI->new($controller);
    $controller->setGUI($gui);
    
    Tkx::MainLoop;
}

