
use strict;
use warnings;

package WordRef;

use JSON;
use Data::Dumper;

my $base = "http://api.wordreference.com";
my $apiVersion = "";
my $apiKey = "fc60c";
my $output = "json";
my $dict = "enfr";

my %partsOfSpeech = ('n' => 'noun', 'adv' => 'adverb', 
    'adj' => 'adjective', 'vi' => 'intransitive verb',
    'vtr' => 'transitive verb', 'nm' => '????'
);


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

# method behavior
# 1. parse json response into hashes, arrays
# 2. check if response is an error
# 3. look for translation in:
#      json/term0/PrincipalTranslations/0
#      json/term0/Entries/0  (if not found in other one)
# 4. pull out of translation:
#      OriginalTerm/term
#      OriginalTerm/POS
#      FirstTranslation/term
# 
# error cases
# 1. text can not be parsed as json -> error/invalid response (expected json)
# 2. response is an error -> error/no translation found, message/'some explanation'
# 3. translation found in neither place -> error/got response, could not extract information
# 4a. can't find word/translation -> error/got translation, could not extract word/translation
# 4b. can't find pos -> not an error, but needs to be replaced with "sorry, can't find pos"
#
sub parseContent {
    my ($self, $content) = @_;
    
    my $jsonDict;
    eval { # error case 1
        $jsonDict = decode_json($content);
    } || return {'error' => 'invalid content:  not json'};

    if($jsonDict->{"Error"}) { # error case 2
    	return {'error' => $jsonDict->{"Error"}};
    }

    my $rel = $jsonDict->{'term0'}->{'PrincipalTranslations'}->{'0'} || 
        $jsonDict->{'term0'}->{'Entries'}->{'0'}; # sometimes in `Entries' instead !!
    if(!$rel) { # error case 3
    	return {'error' => 'could not find translation information'};
    }
    
    # error case 4a
    my $word = $rel->{'OriginalTerm'}->{'term'};
    if(!$word) {
    	return {'error' => 'could not find looked-up word in translation'};
    }
    my $meaning = $rel->{'FirstTranslation'}->{'term'};
    if(!$meaning) {
    	return {'error' => 'could not find meaning in translation'};
    }
    
    # error case 4b
    my $pos = $partsOfSpeech{$rel->{'OriginalTerm'}->{'POS'}} || 
                              $rel->{'OriginalTerm'}->{'POS'} ||
                              "not found";

    # at long last, success!
    return {
        'word' => $word,
        'part of speech' => $pos,
        'meaning' => $meaning
    };
}

1;
