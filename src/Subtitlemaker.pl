#!/usr/local/ActivePerl-5.12/bin/perl


use strict;
use warnings;
use Tkx;
use MainController;


my $gui = MainController->new();
&Tkx::MainLoop();




sub warning {
	my $message = shift @_;
	warn $message;
}

sub exception {
	my $message = shift @_;
	die $message."\n";
}

sub notifyUser {
	my ($message) = @_;
	# ideally, pop this up in a message box
	print $message;
}