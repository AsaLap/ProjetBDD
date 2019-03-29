#!/usr/bin/perl
use strict;
use DBI;



my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>0});

$dbh->do("drop table Ensembl");
$dbh->do("drop table General");
$dbh->do("drop table Protein");
$dbh->do("drop table Gene");
$dbh->do("create table Ensembl(UniProtKB_TrEMBL_ID varchar primary key, GeneStableID varchar, TranscriptStableID varchar, PlantReactionID varchar)");
$dbh->do("create table General(Entry varchar primary key, EntryName varchar, Status varchar, GeneName varchar, ProteinName varchar, EnsemblProt varchar)");
$dbh->do("create table Protein(ProteinName varchar primary key, Sequence varchar, Length int)");
$dbh->do("create table Gene(GeneName varchar primary key, Synonym varchar, GeneOnthology varchar)");

open(Ensembl, 'mart_exporttri.csv');
my @tmp;
my $insert=$dbh->prepare("INSERT into Ensembl(UniProtKB_TrEMBL_ID, GeneStableID, TranscriptStableID, PlantReactionID)VALUES(?,?,?,?)");
while(<Ensembl>){
  chomp;
  @tmp= split(/,/,$_);
  $insert->execute($tmp[2],$tmp[0],$tmp[1],$tmp[3]);
  }
