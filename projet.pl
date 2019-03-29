my $dbh = DBI->connect("DBI:Pg:dbname=alaporte006;host=dbserver","alaporte006","MDPBases",{'RaiseError'=>1});


open(EnsemblPlant, 'mart_export.csv') ; #ouverture en lecture seule
open(EnsemblPLanttrier, '>mart_exporttri.csv') ;
open(Uniprot, 'uniprot-arabidopsis+thaliana.tab.txt');
open(Uniprottri, '>Uniprottri.tab.txt') ;


######Table EnsemblPlant
while (<EnsemblPlant>) {
  chomp;
  @tmp= split(/,/,$_);
  $dupli=1;
  if(@tmp[2]){
    if (@tmp[3]){
    #  $dbh+=$dbh
      print FICHIER "@tmp[0],@tmp[1],@tmp[2],@tmp[3]";


    }
    else{
      @tmp==NULL;
    }
  }

}


# while(<Uniprot>){
#   chomp;
#   @tmp= split(/\t/,$_);
#   if (@tmp[4]=~/(.*)<Arabidopsis thaliana>(.*)/){
#     INSERT table
#   }
# }
