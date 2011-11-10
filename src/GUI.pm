
use strict;
use warnings;
use Tkx;

package GUI;

sub make_mainwindow {
    my $mw = Tkx::widget->new(".");
    $mw->g_wm_minsize(200, 200); # what do these 200's mean?  nothing, that's what
    $mw->g_wm_title("Cross-Dictionnaire");
    return $mw;
}

sub make_entry_button_frame($) {
    my $mw = $_[0];
    my $frame = $mw->new_frame();
    $widgets{lab_ent} = &make_label_entry($frame, [-text => "Type entry here:"],[-textvariable => \$textvars{entry}]);
    $widgets{but_submit} = $frame->new_button(-text => "Submit", -command => [\&submit_query]);
    $widgets{but_exit} = $frame->new_button(-text => "Exit", -command => sub {exit});
    my $listvar = " {english->french} {french->english}";
    $widgets{list_wrf} = $frame->new_tk__listbox(-listvariable => \$listvar);

    $widgets{list_wrf}->g_grid(-row => 15, -padx => 10, -pady => 10);    
    $widgets{lab_ent}->g_grid(-row => 0, -column => 0, -padx => 10, -pady => 20, -rowspan => 5);
    $widgets{but_submit}->g_grid(-column => 0, -padx => 10, -pady => 10, -sticky => "ew");
    $widgets{but_exit}->g_grid(-column => 0, -padx => 10, -pady => 10, -sticky => "ew");
    return $frame;
}

sub make_label_entry($\@\@) {
    my $mw = $_[0];
    my @label_config = @{$_[1]};
    my @entry_config = @{$_[2]};
    my $frame = $mw->new_frame();
    $widgets{label} = $frame->new_label(@label_config);
    $widgets{label}->g_grid(-row => 0, -pady => 5);
    $widgets{entry} = $frame->new_entry(@entry_config);
    $widgets{entry}->g_grid(-row => 1, -pady => 5);
    return $frame;
}

# make the widgets that are used for displaying ??the definitions??
sub make_texts($) {
    my $mw = $_[0];
    my $frame = $mw->new_frame();
    my $i = 0;
    for my $k ((names("URB"), names("DIC"), names("WRF"), names("LED"))) {
        $widgets{$k} = $frame->new_tk__text(-width => 100, -height => 10, -wrap => "word");
        $widgets{"${k}_scroll"} = $frame->new_ttk__scrollbar(-orient => 'vertical', -command => [$widgets{$k}, 'yview']);
        $widgets{$k}->configur(-yscrollcommand => [$widgets{"${k}_scroll"}, 'set']);
        $widgets{$k}->g_grid(-row => $i, -column => 0, -pady => 10);
        $widgets{"${k}_scroll"}->g_grid(-row => $i, -column => 1, -sticky => "ns", -pady => 10);
        $i++;
    }
    return $frame;
}