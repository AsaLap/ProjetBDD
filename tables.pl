#!bin/usr/perl

$dbh->do("create table UniProt(UniProtKB_TrEMBL_ID varchar primary key, GeneStableID varchar, TranscriptStableID varchar, PlantReactionID varchar)");
$dbh->do("create table General(Entry varchar primary key, EntryName varchar, Status in ("reviewed", "unreviewed"), Organism varchar, GeneName varchar, ProteinName varchar, EnsemblProt varchar)");
$dbh->do("create table Protein(ProteinName varchar primary key, Sequence varchar, Length int)");
$dbh->do("create table Gene(GeneName varchar primary key, Synonym varchar, GeneOnthology varchar)");
