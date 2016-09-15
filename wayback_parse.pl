
#!/usr/bin/perl -w

# For some reason CIRM eliminated the application review summaries from its website. 
# This script scrapes the last instance of these URLS as captured by the WayBack Macine on July 29, 2016.

use strict;
use warnings;
use File::Slurp;
use String::Util 'trim';

# Set path to input HTML files
my $inpath="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\CIRM\\Applications\\html";
my $outpath="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\CIRM\\Applications\\Parsed";

open (OUTFILE1, ">$outpath\\applications_fundingrounds_parsed.txt") or die "Can't open subjects file: applications_fundingrounds_parsed.txt";
print OUTFILE1 "roundnum	rounddate	totalawards	totalfunds	awardvalue	dispersedfunds	roundname\n";


my $content = read_file("$inpath\\cirm_funding_commitments_wayback_html.txt");

my $roundnum=0;
while ($content=~/<td class="views-field views-field-title" >(.*?)<br><span class="date-display-single"(.*?)">(.*?)<\/span><br>(.*?)grant-count" >(.*?)<\/td>(.*?)total-funds-ag" >(.*?)<\/td>(.*?)award-value-ag" >(.*?)<\/td>(.*?)dispersed-funds" >(.*?)<\/td>/gs) {

       $roundnum++;
       my $roundname=""; $roundname=$1; $roundname=trim($roundname);
       my $rounddate=""; $rounddate=$3; $rounddate=trim($rounddate);
       my $totalawards=""; $totalawards=$5; $totalawards=trim($totalawards);
       my $totalfunds=""; $totalfunds=$7; $totalfunds=trim($totalfunds);
       my $awardvalue=""; $awardvalue=$9; $awardvalue=trim($awardvalue);
       my $dispersedfunds=""; $dispersedfunds=$11; $dispersedfunds=trim($dispersedfunds);
       print OUTFILE1 "$roundnum	$rounddate	$totalawards	$totalfunds	$awardvalue	$dispersedfunds	$roundname\n";
}
print OUTFILE1 "52		3	\$11,644,754	\$7,468,299	\$7,444,220	Early Translational from Disease Team Conversion\n";



