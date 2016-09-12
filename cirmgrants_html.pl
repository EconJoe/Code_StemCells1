#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::Simple;

# Set path to input HTML files
my $inpath="D:\\Research\\Projects\\StemCells\\StemCells1\\Data\\CIRM";
my $outpath="D:\\Research\\Projects\\StemCells\\StemCells1\\Data\\CIRM\\grants_html_9_12_2016";

open (INFILE, "<$inpath\\granturllist_9_12_2016.txt") or die "Can't open subjects file: urls.txt";
my $count=0;
while (<INFILE>) {
  if ($_=~/(.*)\n/) { 

     $count++;
     print "$count\n";
     my $url=$1;
     my $content = get $url;  die "Couldn't get $url" unless defined $content;
     
     open (OUTFILE, ">$outpath\\grants_html_9_12_2016_page$count.txt") or die "Can't open subjects file: grants_html_9_12_2016_page$count.txt";
     print OUTFILE $content;
     close OUTFILE;
  }
}

close INFILE;

