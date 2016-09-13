
#!/usr/bin/perl -w

# For some reason CIRM eliminated the application review summaries from its website. 
# This script scrapes the last instance of these URLS as captured by the WayBack Macine on July 29, 2016.

use strict;
use warnings;
use LWP::Simple;

# Set path to input HTML files
my $inpath="D:\\Research\\Projects\\StemCells\\StemCells1\\Data\\CIRM";
my $outpath="D:\\Research\\Projects\\StemCells\\StemCells1\\Data\\CIRM\\FundingCommitments";

# HTML from base page. CIRM FUNDING COMMITMENTS.
my $mainurl="https://web.archive.org/web/20160729012339/https://www.cirm.ca.gov/our-progress/cirm-funding-commitments";
my $mainhtml = get $mainurl;  die "Couldn't get $mainurl" unless defined $mainhtml;
open (OUTFILE, ">$outpath\\cirm_funding_commitments_wayback_html.txt") or die "Can't open subjects file: cirm_funding_commitments_wayback_html.txt";
print OUTFILE $mainhtml;
close OUTFILE;

my $page=0;
while ($mainhtml=~/<br><a href="\/web\/(.*?)"><ul><li>Read the RFA<\/a><br><a href="\/web\/(.*?)"><li>Application review summaries<\/li><\/ul><\/a>/g) {

      $page++;
     
     # HTML from each of the X RFAs
      my $rfaurl=$1; $rfaurl="https://web.archive.org/web/$rfaurl";
      my $rfahtml = get $rfaurl;  die "Couldn't get $rfaurl" unless defined $rfahtml;
      open (OUTFILE, ">$outpath\\RFAs\\cirm_funding_commitments_wayback_html_rfa$page.txt") or die "Can't open subjects file: cirm_funding_commitments_wayback_html_rfa$page.txt";
      print OUTFILE $rfahtml;
      close OUTFILE;

      # HTML from each of the XX corresponding base pages for Application Review Summaries
      my $apprevurl=$2; $apprevurl="https://web.archive.org/web/$apprevurl";
      my $apprevhtml = get $apprevurl;  die "Couldn't get $apprevurl" unless defined $apprevhtml;
      open (OUTFILE, ">$outpath\\ApplicationReviews\\cirm_funding_commitments_wayback_html_apprev$page.txt") or die "Can't open subjects file: cirm_funding_commitments_wayback_html_apprev$page.txt";
      print OUTFILE $apprevhtml;
      close OUTFILE;

      my $appnum=0;
      while ($apprevhtml=~/<a href="\/web\/(.*?)\/https:\/\/www.cirm.ca.gov\/node\/(.*?)\/review">/g) {

            $appnum++;

            # HTML from the specific applications for each of the XX corresponding Application Review Summaries
            # The first number corresponds to the Application Review Summary base page. The second number corresponds to the specific application number.
            my $appwburl=$1; my $appcirmurl=$2; my $appurl="https://web.archive.org/web/$appwburl/https://www.cirm.ca.gov/node/$appcirmurl/review";
            my $apphtml = get $appurl;  die "Couldn't get $apprevurl" unless defined $apphtml;
            open (OUTFILE, ">$outpath\\ApplicationReviews\\Applications\\cirm_funding_commitments_wayback_html_app\_$page\_$appnum.txt") or die "Can't open subjects file: cirm_funding_commitments_wayback_html_app\_$page\_$appnum.txt";
            print OUTFILE $apphtml;
            close OUTFILE;
      }
}
