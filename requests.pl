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
  return $prep;
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
  requete("SELECT UniProtKB_TrEMBL_ID FROM Ensembl","search","");
}

sub afficherGenes{
  my $rep = requete("SELECT GeneName FROM Gene JOIN Ensembl ON Gene.Entry=Ensembl.UniProtKB_TrEMBL_ID","search");
  print "Voulez-vous sauvegarder les résultats ? (O/N) (format HTML) : \n";
  my $answer = <STDIN>;
  chomp($answer);
  if ($answer eq "O" || $answer eq "o"){
    print "Donner un nom de fichier (sans l'extension): \n";
    my $saveName = <STDIN>;
    chomp($saveName);
    save($rep,$saveName,"Nom des gènes du fichier Uniprot","GeneName");
  } else {print "résultats non sauvegardés";}
}

sub afficherProtByLen{
  print "Quelle taille minimale souhaitez-vous ? :\n";
  my $length = <STDIN>;
  chomp($length);
  my $rep = requete("SELECT Entry,ProteinName,Length FROM Protein WHERE Length>=$length","search");
  print "Voulez-vous sauvegarder les résultats ? (O/N) (format HTML) : \n";
  my $answer = <STDIN>;
  chomp($answer);
  if ($answer eq "O" || $answer eq "o"){
    print "Donner un nom de fichier (sans l'extension): \n";
    my $saveName = <STDIN>;
    chomp($saveName);
    save($rep,$saveName,"Protéines récupérées en fonction de leur longueur","Entry","ProteinName","Length");
  } else {print "résultats non sauvegardés";}
}

sub afficherProtByEC{
  print "Quelle EC voulez-vous aller chercher ? (format X.X.X.X) :\n";
  my $EC = <STDIN>;
  chomp($EC);
  while ($EC !~ /\d+\.\d+\.\d+\.\d+/){
    print "Format non respecté, veuillez réessayer (X.X.X.X) :\n";
    $EC = <STDIN>;
    chomp $EC;
  }
  my $rep = requete("
  SELECT DISTINCT gl.entry, gl.EntryName, gl.status, p.proteinName, p.length,
    g.GeneName, g.Synonym, g.GeneOnthology, gl.EnsemblPlant,
    e.GeneStableID, e.TranscriptStableID, e.PlantReactionID, p.Sequence
        FROM Protein p
        JOIN General gl ON p.entry = gl.Entry
        JOIN Gene g ON p.entry = g.Entry
        LEFT OUTER JOIN Ensembl e ON p.entry = e.UniProtKB_TrEMBL_ID
        WHERE p.proteinName LIKE '%$EC%'","search");
  print "Voulez-vous sauvegarder les résultats ? (O/N) (format HTML) : \n";
  my $answer = <STDIN>;
  chomp($answer);
  if ($answer eq "O" || $answer eq "o"){
    print "Donner un nom de fichier (sans l'extension): \n";
    my $saveName = <STDIN>;
    chomp($saveName);
    save($rep,$saveName,"Protéines récupérées par leur EC","Entry", "EntryName", "Status", "ProteinName", "Length","GeneName", "Synonym", "GeneOnthology", "EnsemblPlant", "GeneStableID", "TranscriptStableID", "PlantReactionID", "Sequence");
  } else {print "résultats non sauvegardés";}
}

sub save{
  my $resultQuery = shift;
  my $fileName = shift;
  my $title = shift;
  my @columns = @_;
  $resultQuery->execute();
  $fileName = $fileName.".html";
  open(my $file, '>',$fileName);
  print $file "<!DOCTYPE html>\n<head>\n<meta charset='UTF-8'>\n</head>\n<body>\n";
  print $file "<h1>$title</h1>\n";
  print $file "<table>\n<thead>\n<tr>\n<th>";
  print $file join("</th>\n<th>", @columns);
  print $file "</th>\n</tr>\n</thead>\n<tbody>\n";
  while (my @q = $resultQuery->fetchrow_array()){
    for (@q){$_ = 'N.A' if !defined($_);}
    print $file "<tr>\n<td>";
    print $file join("</td>\n<td>", @q);
    print $file "</td>\n</tr>\n";
  }
  print $file "</tbody>\n</table>\n</body>";
  close($file);
  print("Résultats sauvegardés\n");
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
    afficherprotByEC();
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
