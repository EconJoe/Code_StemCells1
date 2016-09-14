#!/usr/bin/perl -w

use strict;
use warnings;
use File::Slurp;
use String::Util 'trim';

# Set path to input HTML files
my $inpath="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\CIRM\\Grants\\grants_html_9_12_2016";
my $outpath="D:\\Research\\Projects\\StemCells\\StemCells2\\Data\\CIRM\\Grants\\Parsed";

open (OUTFILE1, ">$outpath\\grants_parsed_basic_9_12_2016.txt") or die "Can't open subjects file: grants_parsed_9_12_2016.txt";
print OUTFILE1 "page	grantnumber	fundingtype	status	awardvalue	stemcelluse	investigatorname	investigatortype	investigatorinstitution	shorturl	longurl\n";

open (OUTFILE2, ">$outpath\\grants_parsed_text_9_12_2016.txt") or die "Can't open subjects file: grants_parsed_text_9_12_2016.txt";
print OUTFILE2 "page ||| grantnumber ||| title ||| publicabstract\n";

open (OUTFILE3, ">$outpath\\grants_parsed_pmids_9_12_2016.txt") or die "Can't open subjects file: grants_parsed_pmids_9_12_2016.txt";
print OUTFILE3 "page	grantnumber	pmid\n";

foreach my $page (1..672) {

    my $grantnumber=""; 
    my $fundingtype=""; my $status=""; my $awardvalue=""; my $stemcelluse=""; my $investigatorname=""; my $investigatortype=""; my $investigatorinstitution=""; my $shorturl=""; my $longurl="";
    my $title=""; my $publicabstract=""; my $pmid="";
    
    my $content = read_file("$inpath\\grants_html_9_12_2016_page$page.txt");

    # Grant number
    if ($content=~/>Grant Number:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $grantnumber=$1; $grantnumber=trim($grantnumber) }

    # Funding Type
    if ($content=~/>Funding Type:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $fundingtype=$1; $fundingtype=trim($fundingtype) }

    # Status
    if ($content=~/>Status:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $status=$1; $status=trim($status) }
    
    # Award Value
    if ($content=~/>Award Value:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $awardvalue=$1; $awardvalue=trim($awardvalue) }

    # Stem Cell Use
    if ($content=~/>Stem Cell Use:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $stemcelluse=$1; $stemcelluse=trim($stemcelluse) }

    # Investigator Name
    if ($content=~/>Name:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first"><a href="(.*?)">(.*?)<\/a>/) { $investigatorname=$2; $investigatorname=trim($investigatorname) }

    # Investigator Type
    if ($content=~/>Type:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first">(.*?)<\/div>/) { $investigatortype=$1; $investigatortype=trim($investigatortype) }

    # Investigator Institution
    if ($content=~/>Institution:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first"><a href="(.*?)">(.*?)<\/a>/) { $investigatorinstitution=$2; $investigatorinstitution=trim($investigatorinstitution) }

    # URL
    if ($content=~/<link rel="canonical" href="(.*?)" \/>/) { $longurl=$1; $longurl=trim($longurl) }
    if ($content=~/<link rel="shortlink" href="(.*?)" \/\>/) { $shorturl=$1; $shorturl=trim($shorturl) }
    
    # Title
    if ($content=~/<meta property="og:title" content="(.*)" \/>/) { $title=$1; $title=trim($title) }

    print OUTFILE1 "$page	$grantnumber	$fundingtype	$status	$awardvalue	$stemcelluse	$investigatorname	$investigatortype	$investigatorinstitution	$shorturl	$longurl\n";
    
    # Public abstract
    if ($content=~/>Public Abstract:&nbsp;<\/div><div class="field-items"><div class="field-item even"id="first"><p>(.*?)<\/p>/s) { $publicabstract=$1; $publicabstract=trim($publicabstract) }
    # view-source:https://www.cirm.ca.gov/our-progress/awards/redacted-new-cancer-therapeutic-reduce-csc-frequency
    
    print OUTFILE2 "$page ||| $grantnumber ||| $title ||| $publicabstract\n";

    # PMIDs
    while ($content=~/>\(PubMed: <a href="http:\/\/www.ncbi.nlm.nih.gov\/pubmed\/(.*?)" target="_blank">(.*?)<\/a>\)<\/span>/g) {
           $pmid=$2;
           print OUTFILE3 "$page	$grantnumber	$pmid\n";
     }
}

