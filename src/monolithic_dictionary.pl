#!/usr/bin/perl

use strict;
use warnings;
use LWP;
use HTML::TreeBuilder;
use Tkx;


#ISSUES:  28.5.10
#	wordreference, le-dictionnaire parsing is poor
#	urban, dic.com (if not others, too) suggest similar words if word is not found
#		should check to see what words were returned, and warn or something if different from requested word


#gui:  version 1:
#	objects:
#		1. widget for text entry
#		2. widget that displays websites that will be checked
#		3. widget for displaying results (no choice, just displays all)
#		4. button to submit?
#		5. button to exit
#		something to save responses?--not in first version
#	operation:
#		type something in to 1, press enter or click a button
#		which sends query to each website listed in 2, gets response, parses,
#		and displays in 3
#
#
#version 2:
#	objects:
#		menu to choose between different websites and modes.......

###################################
# redesign components:
#   parsers:  html response -> parsed definition (or error message if necessary)
#   gui:  provide buttons, text entry fields ... display parsed results
#   http request code:  requested word -> html response
#   glue: connect all the pieces
#
# data definitions:
#   parsed definition (not sure what lowest common denominator is yet -- find out)
#     word
#     definitions
#     examples
###################################




BEGIN {#set up dictionary names, dictionary url stubs, and functions for accessing them safely

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

# could probably be eleminated (just use hash lookup directly)
	sub names($) {
		if (!$_[0]) {
			die "&names requires a scalar argument: $!";
		}
		if (!exists($names{$_[0]})) {
			die "&names entry not found:  invalid dictionary name:  $!";
		}
		return $names{$_[0]};
	}
	#sub urlstubs($) {
	#	if (!$_[0]) {
	#		die "&urlstubs requires a scalar argument: $!";
	#	}
	#	if (!exists($urlstubs{$_[0]})) {
	#		die "&urlstubs entry not found:  invalid dictionary name:  $!";
	#	}
	#	return $urlstubs{$_[0]};
	#}


	my $lwp = LWP::UserAgent->new();

	sub dic_url($$) {#search phrase, dictionary
		if (!exists($urlstubs{$_[1]})) {
			die "no such dictionary:  $_[1] at $!";
		}
		my $url = $urlstubs{$_[1]}.$_[0];#it's possible that we need something more robust here in case it's not simply tacked on the end.....
		my $content = ${$lwp->get($url)}{_content};
		return $content;
	}
}#end of BEGIN block




&simple_gui();



sub simple_gui {
	my $mw = &make_mainwindow();
	my $ent_but_frame = &make_entry_button_frame($mw);
	my $text_frame = &make_texts($mw);
	
	$ent_but_frame->g_grid(-row => 0, -column => 0);
	$text_frame->g_grid(-row => 0, -column => 1, -rowspan => 20);
	
	Tkx::MainLoop;
}



BEGIN {#gui code
my (%widgets, $ent_word, $lab_output, @widgets, @texts, @scrolls);
my %textvars = (names("URB") => "", names("DIC") => "", names("WRF") => "", names("LED") => "", "entry" => "query:");
my %dics = (names("URB") => \&urban_parse,
		names("DIC") => \&dictionary_dot_com_parse,
		names("WRF") => \&word_reference_parse,
		names("LED") => \&le_dictionnaire_parse,
	);

sub submit_query() {
	for (values %dics) {#iterate over parsing functions
		(my $query = $textvars{entry}) =~ tr/ /+/;#problem:  multi-word queries are sometimes automatically redirected…. to where?????
		my @face = @{&{$_}($query, \$widgets{list_wrf})};
		my $dictionary = shift @face;
		$widgets{$dictionary}->delete("1.0", "end");
		if (@face) {
			#for(my $i = 0; $i <= $#face; $i++) {#  $#face is an arbitrary limit:  do I really need them all?
			#	$face[$i] = "$textvars{entry}:  $face[$i]";
			#}
			$textvars{$dictionary} = join("\n\n", ($dictionary, @face));
 			$widgets{$dictionary}->insert("end", $textvars{$dictionary});
		} else {
			$textvars{$dictionary} = "I'm sorry, $textvars{entry} could not be found in $dictionary\n";
			$widgets{$dictionary}->insert("end", $textvars{$dictionary});
		}
	}
}

sub make_mainwindow() {
	my $mw = Tkx::widget->new(".");
	$mw->g_wm_minsize(200, 200);#what do these 200's mean?  nothing, that's what
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

}# end of BEGIN block





######################################################################################
# 'parsers' package
######################################################################################

####### response fetchers
sub urban_parse($) {
	my $root = HTML::TreeBuilder->new;
	my $response = &dic_url($_[0], "URB");
	my @outs = names("URB");
	if ($response) {
		$root->parse($response);
		$root->eof;
		my @defs = $root->find_by_attribute("class", "definition");
		my @egs = $root->find_by_attribute("class", "example");
		for(my $i = 0; $i <= $#defs; $i++) {
			push(@outs, $defs[$i]->as_text()."\nexample:  ".$egs[$i]->as_text());
		}
		$root->delete();
	} else {
		warn "no page from $outs[0]...\n";
	}
	return \@outs;
}

sub dictionary_dot_com_parse($) {
	my $root = HTML::TreeBuilder->new;
	my $response = &dic_url($_[0], "DIC");
	my @outs = names("DIC");
	if ($response) {
		$root->parse($response);
		$root->eof;
		my @defs = $root->find_by_attribute("class", "luna-Ent");
		for(my $i = 0; $i <= $#defs; $i++) {
			push(@outs, $defs[$i]->as_text());
		}
		$root->delete();
	} else {
		warn "no page from $outs[0]....\n";
	}
	return \@outs;
}

sub word_reference_parse($$) {
	my $root = HTML::TreeBuilder->new;
	my $response;
	my $listbox = ${$_[1]};
	my $choice = $listbox->curselection();
	if ($choice eq 'english->french') {
		$response = &dic_url($_[0], "WRF");
	} else {
		$response = &dic_url($_[0], "FRW");
	}
	my @outs = names("WRF");
	if ($response) {
		$root->parse($response);
		$root->eof;
      	my @imp = $root->find_by_attribute("id", "Otbl");
		if ($imp[0]) {
			#print "\n\n".$imp[0]->dump()."\n\n";
			push(@outs, &word_ref_supp_parse($imp[0]));
		} else {
			push(@outs, "empty page found\n");
		}
		$root->delete();
	} else {
		warn "no page from $outs[0]....\n";
	}
	return \@outs;
}

sub le_dictionnaire_parse($) {
	my $root = HTML::TreeBuilder->new;
	my $response = &dic_url($_[0], "LED");
	my @outs = names("LED");
	if ($response) {
		$root->parse($response);
		$root->eof;
		my @defs = $root->find_by_attribute("class", "arial-12-gris");
		push(@outs, $defs[0]->as_text());
		$root->delete();
	} else {
		warn "no page from $outs[0]...\n";
	}
	return \@outs;
}



sub word_ref_supp_parse($) {
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