#!/usr/bin/perl
use strict;
use DBI;



my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>0});

$dbh->do("drop table Ensembl");
$dbh->do("drop table General");
$dbh->do("drop table Protein");
$dbh->do("drop table Gene");
$dbh->do("create table Ensembl(UniProtKB_TrEMBL_ID varchar primary key, GeneStableID varchar, TranscriptStableID varchar, PlantReactionID varchar)");
$dbh->do("create table General(Entry varchar primary key, EntryName varchar, Status varchar, EnsemblPlant varchar)");
$dbh->do("create table Protein(Entry varchar primary key, ProteinName varchar,Sequence varchar, Length int)");
$dbh->do("create table Gene(Entry varchar primary key, GeneName varchar, Synonym varchar, GeneOnthology varchar)");

open(Ensembl, 'mart_exporttri.csv');
my @tmp;
my $insert=$dbh->prepare("INSERT into Ensembl(UniProtKB_TrEMBL_ID, GeneStableID, TranscriptStableID, PlantReactionID)VALUES(?,?,?,?)");
while(<Ensembl>){
  chomp;
  @tmp= split(/,/, $_);
  $insert->execute($tmp[2],$tmp[0],$tmp[1],$tmp[3]);
  }

open(testtab, 'Uniprottri.tab.txt');
my @tmp2;
my $insert2=$dbh->prepare("INSERT into General(Entry, EntryName, Status, EnsemblPlant)VALUES(?,?,?,?)");
my $insert3=$dbh->prepare("INSERT into Protein(Entry, ProteinName, Sequence, Length)VALUES(?,?,?,?)");
my $insert4=$dbh->prepare("INSERT into Gene(Entry, GeneName, Synonym, GeneOnthology)VALUES(?,?,?,?)");
while(<testtab>){
  chomp;
  @tmp2= split(/\t/,$_);
  $insert2->execute($tmp2[0],$tmp2[1],$tmp2[2],$tmp2[8]);
  $insert3->execute($tmp2[0],$tmp2[3],$tmp2[9],$tmp2[5]);
  $insert4->execute($tmp2[0],$tmp2[4],$tmp2[6],$tmp2[7]);
}
