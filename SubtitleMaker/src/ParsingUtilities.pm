
package ParsingUtilities;


use strict;
use warnings;
use SRTEntry;
use SRTTime;
use SRTQuote;



# public functions:
#	parseFile(filename)		--> reference to list of SRTEntr[ies]
#	writeFile(filename, reference SRTEntry list)
#	getAsSRTFormattedText(reference to SRTEntry list)	--> scalar (SRT formatted text)
#
# private functions:
#	parseEntries(filehandle)	--> reference to list of SRTEntr[ies]
#	getQuote(filehandle, line number)	--> (SRTQuote, updated line number)


sub parseFile {
	my ($filename) = @_;
	open(my $fh, $filename) || die "couldn't open file $filename";
	my $entries = &parseEntries($fh);
	return $entries;
}


sub writeFile {
	my ($filename, $srtentries) = @_;
	open(my $out, ">$filename") || die "can't write file: $filename";
	print $out &getAsSRTFormattedText($srtentries);
	close($out);
}


sub getAsSRTFormattedText {
	my ($srtentries) = @_;
	my @entries = @$srtentries;
	my $text;
	my $index = 1;
	for my $entry (@entries) {
		$text .= "$index\n";
		$text .= $entry->getAsSRTFormattedText();
		$text .= "\n";
		$index++;
	}
	return $text;
}


sub parseEntries {
	my ($fh) = @_;
	my @entries;
	my $line = 1;
	while(1) {
		my $linenum = <$fh>;#skip the quote number
		$line++;
		if(!$linenum) {last;}
		chomp(my $times = <$fh>);
		my ($start, $stop);
		if($times =~ /^(\d+):(\d+):(\d+),(\d+) --> (\d+):(\d+):(\d+),(\d+)\s*$/) {
			$start = SRTTime->new($1, $2, $3, $4);
			$stop = SRTTime->new($5, $6, $7, $8);
		} else {
			die "bad file format at line $line (got <$times>)";
		}
		$line++;
		my $quote;
		($quote, $line) = getQuote($fh, $line);
		my $entry = SRTEntry->new($start, $stop, $quote);
		push(@entries, $entry);
	}
	return \@entries;
}

sub getQuote {
	my($fh, $line) = @_;
	my $quote = "";
	my $textline;
	while(defined($textline = <$fh>) && ($textline !~ /^\s*$/)) {
		$quote .= "$textline";
		$line++;
	}
	$line++;
	chomp($quote);
	return (SRTQuote->new($quote), $line);
}

1;
