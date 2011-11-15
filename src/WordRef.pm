
use strict;
use warnings;

package WordRef;

use JSON;
use Data::Dumper;

my $base = "http://api.wordreference.com";
my $apiVersion = "";
my $apiKey = "";
my $output = "json";
my $dict = "enfr";

my %partsOfSpeech = ('n' => 'noun', 'adv' => 'adverb', 
    'adj' => 'adjective', 'vi' => 'intransitive verb',
    'vtr' => 'transitive verb', 'nm' => '????');


sub new {
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
}


sub buildURL {
    my ($self, $searchPhrase) = @_;
    # does the searchPhrase need to be cleaned up -- or was that done elsewhere?
    my @fields = ($base, $apiVersion, $apiKey, $output, $dict, $searchPhrase);
    return join("/", @fields);
}


sub parseContent {
    my ($self, $content) = @_;
    my $jsonDict = decode_json($content);
    my $rel = $jsonDict->{'term0'}->{'PrincipalTranslations'}->{'0'};
    if(!$rel) { # sometimes it's in `Entries' instead !!!!
        $rel = $jsonDict->{'term0'}->{'Entries'}->{'0'};
    }
#    print "word: " . Dumper($rel) . Dumper($jsonDict->{'term0'}->{'PrincipalTranslations'});
    my $def = {
        'word' => $rel->{'OriginalTerm'}->{'term'},
        'p-o-s' => #$rel->{'OriginalTerm'}->{'POS'}, 
           $partsOfSpeech{$rel->{'OriginalTerm'}->{'POS'}},
        'meaning' => $rel->{'FirstTranslation'}->{'term'}
    };
    return $def;
}

1;
