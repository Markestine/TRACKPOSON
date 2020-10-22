use strict;
use Bio::SearchIO; 
use Bio::Search::Result::GenericResult;

my $file=$ARGV[0];
my $out=$ARGV[1];

my $in = new Bio::SearchIO(-format => 'blast', 
 
                          -file   => "$file");
open OUTFILE ,(">$out.bed"); 
#my  ;
while( my $result = $in->next_result ) {
  	if ($result->num_hits<2) {
		## $result is a Bio::Search::Result::ResultI compliant object
		while( my $hit = $result->next_hit ) {
    			## $hit is a Bio::Search::Hit::HitI compliant object
    			while( my $hsp = $hit->next_hsp ) {
      				## $hsp is a Bio::Search::HSP::HSPI compliant object
				#$insertion_number = $insertion_number + 1;
              			print OUTFILE $hit->name ;
				print OUTFILE "\t";
				print OUTFILE $hsp->start('hit');
				print OUTFILE "\t";
				print OUTFILE $hsp->end('hit');
				print OUTFILE "\t";
				print OUTFILE $result->query_name();
				print OUTFILE "\n";
				}  
		}
	}
}
