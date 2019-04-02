#!/usr/bin/perl
use strict;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>1});


open(EnsemblPlant, 'mart_export.csv') ; #ouverture en lecture seule
open(csvtest, '>mart_exporttri.csv') ;
open(Uniprot, 'Uniprot.tab.txt');
open(testtab, '>Uniprottri.tab.txt') ;

my @tmp;
my @tmp2;
my $dupli;
my @list_keys;
my @list_keys2;
my @list_keys3;

#Remplissage des tables avec les données provenant d'EnsemblPlant
while (<EnsemblPlant>) {
  chomp;
  @tmp= split(/,/,$_);
  $dupli=1;
  if(@tmp[2]){
    if(join(" ",@list_keys)=~/$tmp[2]/){
      $dbh+=$dbh;
    }
    else{
      push @list_keys, @tmp[2];
      if (@tmp[3]){
        $dbh+=$dbh;
        print csvtest "@tmp[0],@tmp[1],@tmp[2],@tmp[3]\n";
      }
      else {
        print csvtest "@tmp[0],@tmp[1],@tmp[2],  \n";
      }
    }
  }
}

#Remplissage des tables avec les données provenant d'Uniprot
while(<Uniprot>){
  chomp;
  $_=~tr/\'/ /;
  @tmp2= split(/\t/,$_);
  if (@tmp2[5]=~/.*Arabidopsis thaliana.*/) {
    if(join(" ",@list_keys2)=~/$tmp2[0]/){
      $dbh+=$dbh;
    }
    else{
      push @list_keys2,$tmp[0];
      push @list_keys3,$tmp[4];
      print testtab "@tmp2[0]\t@tmp2[1]\t@tmp2[2]\t@tmp2[3]\t@tmp2[4]\t@tmp2[6]\t@tmp2[7]\t@tmp2[8]\t@tmp2[9]\t@tmp2[10]\n";
      $dbh+=$dbh;
    }
  }
}
