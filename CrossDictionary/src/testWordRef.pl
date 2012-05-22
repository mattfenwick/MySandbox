
use strict;
use warnings;

use WordRef;
use Test::More;
use Data::Dumper; # temporary!

my $parser = WordRef->new();

subtest 'undefined input' => sub {
    my $result = $parser->parseContent(undef);
    is($result->{"error"}, 'invalid content:  not json', "dealt with undefined input");
};

subtest 'non-json input' => sub {
    my $result = $parser->parseContent("[abc");
    is($result->{"error"}, 'invalid content:  not json', "dealt with non-json input");
};

subtest 'input already is error' => sub {
    my $result = $parser->parseContent('{"Error" : "NoTranslation", 
      "Note" : "No translation was found for helllo.Aucune traduction trouvee pour helllo."}');
    is($result->{"error"}, "NoTranslation", "dealt with error in input");
};

subtest 'missing translation information' => sub {
    my $result = $parser->parseContent('{"term0":{}}');
#    print Dumper($result);
    is($result->{"error"}, "could not find translation information", 
        "missing translation information");
};

subtest 'missing searched-for word' => sub {
    my $result = $parser->parseContent('{"term0": {"PrincipalTranslations": {"0": {} }}}');
    is($result->{"error"}, "could not find looked-up word in translation",
        "missing searched-for word");
};

subtest 'pass in array instead of dictionary' => sub {
    my $result;
    eval{
        $result = $parser->parseContent('{"term0": {"PrincipalTranslations": {"0": []}}}');
    } || ok(undef, "still refactoring");
};

subtest 'find everything in "PrincipalTranslations"' => sub {
#    print "starting test 6";
    my $result = $parser->parseContent('
      {"term0": 
          {"PrincipalTranslations": 
            {"0": 
              {"FirstTranslation": {"term": "hello"},
               "OriginalTerm": {"term": "hello"} 
              }
            }
          }
      }');
#    print "here it is: " . Dumper($result);
    ok($result->{'word'} && $result->{'meaning'}, "found results");
};

subtest 'find everything in "Entries"' => sub {
    print "starting test";
    my $result = $parser->parseContent('
      {"term0": 
          {"Entries": 
            {"0": 
              {"FirstTranslation": {"term": "hello"},
               "OriginalTerm": {"term": "hello"} 
              }
            }
          }
      }');
    print "here it is: " . Dumper($result);
    ok($result->{'word'} && $result->{'meaning'}, "found results");
};

done_testing();
