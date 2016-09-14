
#!/usr/bin/perl -w

use LWP::Simple;
use XML::Simple;

$inpath = "D:\\Research\\Projects\\StemCells\\StemCells2\\Data";
$outpath = "D:\\Research\\Projects\\StemCells\\StemCells2\\Data";


open (OUTFILE1, ">$outpath/pubmed_stemcellpmids_similarpmids.txt") or die "Can't open subjects file: pubmed_stemcellpmids_similarpmids.xml";
print OUTFILE1 "nihpmiddb	nihpmid	linkname	dbto	similarpmid	similarityscore\n";

$counter=0;

open (INFILE, "<$inpath/pubmed_stemcellpmidlist.txt") or die "Can't open subjects file: pubmed_stemcellpmidlist.txt";
while (<INFILE>) {
      if (/(.*)\n/) {

         $pmid=$1;
         $counter++;
         print "$pmid ($counter out of 23,379)\n";

         $url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=$pmid&db=pubmed&cmd=neighbor_score";
         $content = get $url;
         die "Couldn't get $url" unless defined $content;

         #print $content;

         open (OUTFILE2, ">$outpath/pubmed_stemcellpmids_similarpmids.xml") or die "Can't open subjects file: pubmed_stemcellpmids_similarpmids.xml";
         print OUTFILE2 $content;
         close OUTFILE2;

        $data = XMLin("$outpath/pubmed_stemcellpmids_similarpmids.xml");
        #open (OUTFILE, ">$outpath\\structure.txt") or die "Can't open subjects file: pmidsimilarity.xml";
        #print OUTFILE Dumper($data);

        $dbfrom = $data->{LinkSet}->{DbFrom};
        $idmain = $data->{LinkSet}->{IdList}->{Id};

        # In this case there are multiple Link Names (Typical Case)
        if (ref($data->{LinkSet}->{LinkSetDb}) =~ /ARRAY/) {
          
          @linksetdb = (@{$data->{LinkSet}->{LinkSetDb}});
          foreach $i (@linksetdb) {
            $linkname = $i->{LinkName};
            $dbto = $i->{DbTo};
            if (ref($link = $i->{Link}) =~ /ARRAY/) {
                @link = @{$i->{Link}};
                foreach $j (@link) {
                   $score = $j->{Score};
                   $id = $j->{Id};
                   print OUTFILE1 "$dbfrom	$idmain	$linkname	$dbto	$id	$score\n";
                }
            }
            else {
                $score = $i->{Link}->{Score};
                $id = $i->{Link}->{Id};
                print OUTFILE1 "$dbfrom	$idmain	$linkname	$dbto	$id	$score\n";
            }
          }
        }
        
        # In this case there is only a single Link Name (Rare Case)
        else {
            $linkname = $data->{LinkSet}->{LinkSetDb}->{LinkName};
            $dbto = $data->{LinkSet}->{LinkSetDb}->{DbTo};
            if (ref($link = $data->{LinkSet}->{LinkSetDb}->{Link}) =~ /ARRAY/) {
                @link = @{$data->{LinkSet}->{LinkSetDb}->{Link}};
                foreach $j (@link) {
                   $score = $j->{Score};
                   $id = $j->{Id};
                   print OUTFILE1 "$dbfrom	$idmain	$linkname	$dbto	$id	$score\n";
                }
            }
            else {
                $score = $data->{LinkSet}->{LinkSetDb}->{Link}->{Score};
                $id = $data->{LinkSet}->{LinkSetDb}->{Link}->{Id};
                print OUTFILE1 "$dbfrom	$idmain	$linkname	$dbto	$id	$score\n";
            }
        }
      }
}

close OUTFILE1;
