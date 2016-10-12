
#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::Simple;

my $infile="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\stemcellcoremeshterms.txt";
open (INFILE, "<$infile") or die "Can't open subjects file: $infile";

my $outfile="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\test.txt";
open (OUTFILE, ">$outfile") or die "Can't open subjects file: $outfile";

my $query="";
while (<INFILE>) {
      my $stub=$_;
      chomp($stub); 
      if ($query eq "") { $query="$stub"; }
      else { $query="$query+OR+$stub"; }
}

#assemble the esearch URL
my $base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
my $utility = 'esearch';
my $db = 'pubmed';
my $url = "$base$utility.fcgi?db=$db&term=$query&usehistory=y";
#print OUTFILE $url;

#post the esearch URL
my $output = get($url);

#print OUTFILE $output;

#parse WebEnv, QueryKey and Count (# records retrieved)
my $web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
my $key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);
my $count = $1 if ($output =~ /<Count>(\d+)<\/Count>/);

#retrieve data in batches of 100,000
my $retmax = 100000;
for (my $retstart = 0; $retstart < $count; $retstart += $retmax) {
        my $efetch_url = $base ."efetch.fcgi?db=pubmed&WebEnv=$web";
        $efetch_url .= "&query_key=$key&retstart=$retstart";
        $efetch_url .= "&retmax=$retmax&retmode=pmid";
        my $efetch_out = get($efetch_url);
        print OUTFILE "$efetch_out";
}
close OUTFILE;







