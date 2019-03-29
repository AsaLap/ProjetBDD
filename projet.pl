#!/usr/bin/perl
use strict;
use DBI;



my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>1});


open(EnsemblPlant, 'mart_export.csv') ; #ouverture en lecture seule
open(csvtest, '>mart_exporttri.csv') ;
open(Uniprot, 'Uniprot.txt');
open(testtab, '>Uniprottri.tab.txt') ;

my @tmp;
my @tmp2;
my $dupli;

######Table EnsemblPlant
while (<EnsemblPlant>) {
  chomp;
  @tmp= split(/,/,$_);
  $dupli=1;
  if(@tmp[2]){
    if (@tmp[3]){
    	$dbh+=$dbh;
	     print csvtest "@tmp[0],@tmp[1],@tmp[2],@tmp[3]\n";
    }
    else {
      print csvtest "@tmp[0],@tmp[1],@tmp[2],  \n";
    }
  }
}


while(<Uniprot>){
  chomp;
  @tmp2= split(/\t/,$_);
  if (@tmp2[5]=~/.*Arabidopsis thaliana.*/) {
    $dbh+=$dbh;
    print testtab "@tmp2[0] @tmp2[1]  @tmp2[2]  @tmp2[3]  @tmp2[4]  @tmp2[6]\n"

  }
  # print testtab "@tmp2[0] @tmp2[1]  @tmp2[2]  @tmp2[3]  @tmp2[5]  @tmp2[6]\n"
}
