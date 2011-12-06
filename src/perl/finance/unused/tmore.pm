use strict;
use warnings;

package tmore;

sub new {
    my ( $class, $parent, @options ) = @_;
    print "base: @_\n";
    my $self = { 
        frame => $parent->new_ttk__frame(@options), 
    };
    bless( $self, $class );
    return $self;
}

sub g_grid {
    my ( $self, @options ) = @_;
    my %options = @options;
    $options{-padx} = 5;
    $options{-pady} = 5;
    @options = %options;
    $self->{frame}->g_grid(@options);
}


1;