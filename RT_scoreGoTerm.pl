#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[3]))){
print "Param :
\t#Argument 1: GO annoatation
\t#Argument 2: gtf file 
\t#Argument 3: GO databse (to have the name of the GO term) 
\t#Argument 4: bed RT state\n";
	die("\n");
}
#UniProtKB       A0A075B6H7      IGKV3-7         GO:0002377      GO_REF:0000033  IBA     PANTHER:PTN000587099    P       Immunoglobulin kappa variable 3-7 (non-functional)      A0A075B6H7_HUMAN|IGKV3-7        protein taxon:9606      20150528        GO_Central

open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
my %GeneVsGoTerm;
my $li = <F1>;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	$GeneVsGoTerm{$tline[2]}{$tline[4]}=$_;
	#print("$tline[2]\t$tline[4]\n");
}
close (F1);

#chr1    HAVANA  gene    11869   14412   .       +       .       gene_id "ENSG00000223972.4"; transcript_id "ENSG00000223972.4"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "DDX11L1"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "DDX11L1"; level 2; havana_gene "OTTHUMG00000000961.2";

open(F1,$ARGV[1]) || die "pblm fichier $ARGV[0]\n";
my %tss_gene;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	my @attributes = split(";",$tline[8]);
	if ($_=~/^chr/ && $tline[2] eq "gene"){
		$attributes[4] =~/gene_name.+\"(.+)\"/;
		my $geneName = $1;
		#print "$geneName\n";
		$tss_gene{$tline[0]}{$tline[3]}=$geneName;
	}
}
close (F1);

#[Term]
#id: GO:0000001
#name: mitochondrion inheritance
#namespace: biological_process
#def: "The distribution of mitochondria, including the mitochondrial genome, into daughter cells after mitosis or meiosis, mediated by interactions between mitochondria and the cytoskeleton." [GOC:mcc, PMID:10873824, PMID:11389764]
#synonym: "mitochondrial inheritance" EXACT []
#is_a: GO:0048308 ! organelle inheritance
#is_a: GO:0048311 ! mitochondrion distribution

#[Term]

open(F1,,$ARGV[2]) || die "pblm fichier prout bis\n";
my $idGO;
my %go_name;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	if($_=~/^\[Term\]/){
		$li = <F1>;
		chomp($li);
		my @id = split(": ",$li);
		$li = <F1>;
		chomp($li);
		my @name = split(": ",$li);
		$li = <F1>;
		chomp($li);
		my @nameSpace = split(": ",$li);
		$go_name{$id[1]}=$nameSpace[1]."\t".$name[1];
	}
}
close (F1);

my %mf;
my %bp;
my %plop;
open(F1,$ARGV[3]) || die "pblm fichier $ARGV[3]\n";
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	foreach my $key(keys(%{$tss_gene{$tline[0]}})){
		my $gene = $tss_gene{$tline[0]}{$key};
		if($tline[1] <= $key && $tline[2] >= $key){
			foreach my $go (keys(%{$GeneVsGoTerm{$gene}})){
				my @tGoInfo = split("\t",$go_name{$go});
				if($tGoInfo[0] eq "biological_process"){
					#print("$gene\t$go\t$tGoInfo[1]\t$tline[3]\n");
					$bp{$tGoInfo[1]."\t".$go}{$tline[3]}++;
				}
				elsif( $tGoInfo[0] eq "molecular_function"){
					#print("$gene\t$go\t$tGoInfo[1]\t$tline[3]\n");
					$mf{$tGoInfo[1]."\t".$go}{$tline[3]}++;
				}
			}
			delete($tss_gene{$tline[0]}{$key});
		}
	}
	$plop{$tline[3]}++;
}
close (F1);


my @tkey = keys(%plop);
my $li = join("\t",@tkey);
print "GO\tidGo\t$li\n";

foreach my $key1 (keys(%mf)){
	my $l = $key1;
	for(my $i = 0; $i<=$#tkey; $i++ ){
		if(defined($mf{$key1}{$tkey[$i]})){
			$l = $l."\t".$mf{$key1}{$tkey[$i]};
		}
		else{	$l = $l."\t0";}
	}
	print "$l\n";
}




