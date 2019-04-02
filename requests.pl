#!/usr/bin/perl
use strict;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>1});

my $requete = 'SELECT * FROM General';
my $prep = $dbh->prepare($requete);
my $exec = $prep->execute();
while(my $ref = $prep->fetchrow_hashref()){
  print "$ref->{'a'} $ref->{'b'}\n";
}
$prep->finish;
$dbh->disconnect();
