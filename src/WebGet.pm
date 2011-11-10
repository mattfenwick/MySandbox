
use strict;
use warnings;
use LWP;
use HTML::TreeBuilder;

package WebGet;

# for each parsing function (found in %dics)
#   figure out what the desired phrase is, and substitute '+' for ' ' (because that's how urls work)
#   get the web page and parse it
#   clear text from the widget, then put the new text in (if there is any)
sub submit_query {
    my ($search) = @_;
    for my $func (values %dics) {#iterate over parsing functions
        (my $query = $textvars{entry}) =~ tr/ /+/; # problem:  multi-word queries are sometimes redirected …. to where?????
        my @face = @{&{$func}($query, \$widgets{'list_wrf'})};
        my $dictionary = shift @face;
        $widgets{$dictionary}->delete("1.0", "end");
        if (@face) {
            #for(my $i = 0; $i <= $#face; $i++) {#  $#face is an arbitrary limit:  do I really need them all?
            #    $face[$i] = "$textvars{entry}:  $face[$i]";
            #}
            $textvars{$dictionary} = join("\n\n", ($dictionary, @face));
             $widgets{$dictionary}->insert("end", $textvars{$dictionary});
        } else {
            $textvars{$dictionary} = "I'm sorry, $textvars{entry} could not be found in $dictionary\n";
            $widgets{$dictionary}->insert("end", $textvars{$dictionary});
        }
    }
}

# Map (dictionary name) urlstub
my %names = (URB => "urbandictionary.com", 
    DIC => "dictionary.com", 
    WRF => "wordreference.com", 
    LED => "le-dictionnaire.com",
);

# Map (dictionary name) urlbase+lookup
my %urlstubs = (URB => "http://www.urbandictionary.com/define.php?term=",
    DIC => "http://dictionary.reference.com/browse/",
    WRF => "http://www.wordreference.com/enfr/",
    LED => "http://www.le-dictionnaire.com/definition.php?mot=",
    FRW => "http://www.wordreference.com/fren/",
);

sub makeURL {
    my ($search, $dicname) = @_;
    my $url = $urlstubs{$search}.$dicname; # we need something more robust here in case it's not simply tacked on the end.....
    return $url;
}

sub getWebPage {
    my ($url) = @_;
    my $lwp = LWP::UserAgent->new();
    my $content = ${$lwp->get($url)}{_content};
    return $content;
}

sub makeTree {
    my ($response) = @_;
    my $root = HTML::TreeBuilder->new;
    $root->parse($response);
    $root->eof;
    return $root;
}
