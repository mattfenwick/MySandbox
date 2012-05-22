use strict;
use warnings;
use LWP;
use HTML::TreeBuilder;

package WebUtil;


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

1;