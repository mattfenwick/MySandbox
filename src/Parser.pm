
use strict;
use warnings;

package Parser;


sub urbanDict {
    my ($root) = @_;
    my @outs = ("urban or something");
    my @defs = $root->find_by_attribute("class", "definition");
    my @egs = $root->find_by_attribute("class", "example");
    for(my $i = 0; $i <= $#defs; $i++) {
        push(@outs, $defs[$i]->as_text()."\nexample:  ".$egs[$i]->as_text());
    }
    $root->delete();
    return \@outs;
}

sub leDict {
	my ($root) = @_;
    my @outs = ("le dictionnaire or something");
    my @defs = $root->find_by_attribute("class", "arial-12-gris");
    push(@outs, $defs[0]->as_text());
    $root->delete();
    return \@outs;
}

sub dicDotCom {
    my ($root) = @_;
    my @outs = ("dic.com or something");
    my @defs = $root->find_by_attribute("class", "luna-Ent");
    for(my $i = 0; $i <= $#defs; $i++) {
        push(@outs, $defs[$i]->as_text());
    }
    $root->delete();
    return \@outs;
}

sub wordRef {
    my ($root) = @_;
    my @outs = ("WRF or something");
    my @imp = $root->find_by_attribute("id", "Otbl");
    if ($imp[0]) {
        #print "\n\n".$imp[0]->dump()."\n\n";
        push(@outs, &wordRefSupp($imp[0]));
    } else {
        push(@outs, "empty page found\n");
    }
    $root->delete();
    return \@outs;
}

sub wordRefSupp {
    my @root = $_[0]->find_by_attribute('class', 'se');
    #print "\n\n".$root[0]->dump()."\n\n";
    my @word = $root[0]->look_down(_tag => 'span', class => 'hw');
    my $word = $word[0]->as_text();
    my @pron = $root[0]->look_down(_tag => 'span', class => 'ph');
    my $pron = $pron[0]->as_text();
    
    my @lists = $root[0]->look_down(_tag => 'ol', type => 'I');
    my $temp;
    if ($lists[0]) { #there is more than one usage....
        for(my $j = 0; $j <= $#lists; $j++) {
            my $li = $lists[$j]->find_by_tag_name('li');
            my @usage = $li->look_down(_tag => 'span', class => 'ps');
            my $usage = $usage[0]->as_text();
            my @defs = $li->look_down(_tag => 'ol');
            if ($defs[0]) {
                $temp .= "$word:  $usage    pronunciation: $pron\n";
                for my $l (@defs) {
                    $temp .= $l->as_text()."\n";
                }
                $temp .= "\n";
            } else {
                $temp .= $li->as_text()."\n\n";
            }
        }
    } else {
        my @usage = $root[0]->look_down(_tag => 'span', class => 'ps');
        my $usage = $usage[0]->as_text();
        my @gender = $root[0]->look_down(_tag => 'span', class => 'gr');
        my $gender;
        if ($gender[0]) {
            $gender = $gender[0]->as_text();
        }
        my @def = $root[0]->look_down(_tag => 'span', class => 'clickable');
        my $def = &text_only($def[0]);
        $temp = "$word:  $usage    pronunciation: $pron\n$def  $gender\n\n";
    }
    return $temp;
}


sub text_only($) {#given an html element, returns concatenation of all text from its content list
    my $html_elem = $_[0];
    my @children = @{${$html_elem}{_content}};
    my $out;
    for my $k (@children) {
        if (!ref($k)) {
            $out .= $k;
        }
    }
    return $out;
}
