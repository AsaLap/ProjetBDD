#!/usr/bin/perl
use strict;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>1});



sub requete{
  my ($requete,$statement) = @_;
  my $prep = $dbh->prepare($requete);
  my $exec = $prep->execute(); # $exec va contenir le nombre de réponses
  if ($statement eq "search"){ #lancer le fetchrow_array ou pas
    while(my @ref = $prep->fetchrow_array()){
      print join(" | ",@ref),"\n";
    }
  }
  $prep->finish;
}

sub ajouterProteine{
  print "Donnez l'entrée : \n";
  my $entry = <STDIN>;
  chomp($entry);
  print "Donnez le nom de la protéine : \n";
  my $protName = <STDIN>;
  chomp($protName);
  print "Donnez la séquence : \n";
  my $seq = <STDIN>;
  chomp($seq);
  my $length = length($seq); #Calcul de la taille de la séquence donnée
  requete("INSERT INTO Protein(Entry, ProteinName, Sequence, Length) VALUES('$entry', '$protName', '$seq', $length)","add");
}

sub modifier{
  print "Donnez l'entrée à modifier : \n";
  my $entry = <STDIN>;
  chomp($entry);
  print "Donnez la nouvelle séquence : \n";
  my $seq = <STDIN>;
  chomp($seq);
  my $length = length($seq); #Calcul de la taille de la séquence donnée
  requete("UPDATE Protein set Sequence='$seq', length=$length WHERE Entry='$entry'","modify");
}

sub afficherEnsemblProt{
  requete("SELECT UniProtKB_TrEMBL_ID FROM Ensembl","search");
}

sub afficherGenes{
  requete("SELECT GeneName FROM Gene JOIN Ensembl ON Gene.Entry=Ensembl.UniProtKB_TrEMBL_ID","search");
}

sub afficherProtByLen{
  print "Quelle taille minimale souhaitez-vous ? :\n";
  my $length = <STDIN>;
  chomp($length);
  requete("SELECT Entry,ProteinName,Length FROM Protein WHERE Length>=$length","search");
}

sub afficherProtByName{
  print "Quelle EC voulez-vous aller chercher ? (format X.X.X.X) :\n";
  my $EC = <STDIN>;
  chomp($EC);
  while ($EC !~ /\d+\.\d+\.\d+\.\d+/){
    print "Format non respecté, veuillez réessayer (X.X.X.X) :\n";
            $EC = <STDIN>;
            chomp $EC;
  }

  requete("
  SELECT p.entry, gl.status, p.ProteinName, g.GeneName, p.length, p.Sequence FROM Protein p
                JOIN General gl ON p.entry = gl.Entry
                JOIN Gene g ON p.entry = g.Entry
                JOIN Ensembl e ON p.entry = e.UniProtKB_TrEMBL_ID
  WHERE p.ProteinName LIKE '%$EC%'","search");
}

sub menu(){
  print "Veuillez choisir une option :\n";
  print "1 - Ajouter une protéine\n";
  print "2 - Modifier une séquence\n";
  print "3 - Afficher les protéines du fichier EnsemblPlant\n";
  print "4 - Afficher le nom des gènes présents dans Uniprot et EnsemblPlant\n";
  print "5 - Afficher les protéines en fonction d'une longueur\n";
  print "6 - Afficher les caractéristiques de protéine(s) correspondant à un E.C. number\n";
  print "0 - Quitter\n";
  my $reponse = <STDIN>;
  chomp($reponse);
  print "Vous avez choisi la réponse : $reponse\n";
  if ($reponse == 1){
    ajouterProteine();
  } elsif ($reponse == 2){
    modifier();
  } elsif ($reponse == 3){
    afficherEnsemblProt();
  } elsif ($reponse == 4){
    afficherGenes();
  } elsif ($reponse == 5){
    afficherProtByLen();
  } elsif ($reponse == 6){
    afficherProtByName();
  } elsif ($reponse == 0){
    exit;
  } else {
    print "Veuillez répéter la saisie : ";
  }
  menu();
}

menu();

# my $start = time;
# La fonction
# my $duration = time - $start;
# print "Execution time : $duration s\n";

$dbh->disconnect();
