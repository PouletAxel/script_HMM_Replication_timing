#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[1])))
{
print "Param :
\t#Argument 1 : gff
\t#Argument 2 : file avec les coordonnes\n";
	die("\n");
}

#Chr	Start	End	ESC_BG01_R1	ESC_BG02_AVG	ESC_Cyt49_AVG

open(F1,$ARGV[1]) || die "pblm fichier $ARGV[1]\n";
my %ref;
my %hGene;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	my $plop= $tline[1]."\t".$tline[2]."\t".$tline[3];
	$ref{$tline[0]}{$plop}="";
}
close (F1);


open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
my %hGeneType;
my %pcByState;
my %lncRNAByState;
my %ncRNAByState;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	my @attributes = split(";",$tline[8]);
	if ($_=~/^chr/ && $tline[2] eq "gene"){
		$attributes[3] =~/gene_type=(.+)/;
		my $geneType = $1;
		$attributes[5] =~/gene_name=(.+)/;
		my $geneName = $1;
		my $gene =$geneType."_".$1;
		$attributes[1]=~/gene_id=(.+)\./;
		my $idGene = $1;
		foreach my $key(keys(%{$ref{$tline[0]}})){
			my @position = split("\t",$key);
			if($tline[3] >= $position[0] && $tline[4] <=$position[1]){
				$hGeneType{$geneType}++;
				$hGene{$geneName}++;
				$ref{$tline[0]}{$key} =$ref{$tline[0]}{$key}.$gene."\t";
				if ($geneType eq  "protein_coding" ||$geneType eq  "polymorphic" || $geneType eq "IG_V_gene" || $geneType eq "IG_C_gene" || $geneType eq "TR_V_gene" || $geneType eq "TR_C_gene" || $geneType eq "TR_D_gene" || $geneType eq "TR_J_gene" || $geneType eq "IG_D_gene" || $geneType eq "IG_J_gene"){
					$pcByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "lincRNA" || $geneType eq "3prime_overlapping_ncrna" || $geneType eq "antisense"|| $geneType eq "sense_intronic" || $geneType eq "sense_overlapping" || $geneType eq "non_coding"|| $geneType eq "macro_lncRNA" || $geneType eq "bidirectional_lncRNA" ){
					$lncRNAByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "miRNA" || $geneType eq "piRNA" || $geneType eq "rRNA" || $geneType eq "siRNA" ||$geneType eq "snRNA" || $geneType eq "snoRNA" || $geneType eq "tRNA"|| $geneType eq "vaultRNA" || $geneType eq "misc_RNA"){
					$ncRNAByState{$position[2]}{$idGene}++;
				}				break;
			}
			elsif ($tline[4] > $position[0] && $tline[4] < $position[1]){
				$ref{$tline[0]}{$key} =$ref{$tline[0]}{$key}.$gene."\t";
				$hGeneType{$geneType}++;
				$hGene{$geneName}++;
				if ($geneType eq  "protein_coding" ||$geneType eq  "polymorphic" || $geneType eq "IG_V_gene" || $geneType eq "IG_C_gene" || $geneType eq "TR_V_gene" || $geneType eq "TR_C_gene" ||$geneType eq "TR_D_gene" || $geneType eq "TR_J_gene" || $geneType eq "IG_D_gene" ||	$geneType eq "IG_J_gene"){
					$pcByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "lincRNA" || $geneType eq "3prime_overlapping_ncrna" || $geneType eq "antisense" || $geneType eq "sense_intronic" || $geneType eq "sense_overlapping" || $geneType eq "non_coding" || $geneType eq "macro_lncRNA" || $geneType eq "bidirectional_lncRNA" ){
					$lncRNAByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "miRNA" || $geneType eq "piRNA" || $geneType eq "rRNA" || $geneType eq "siRNA" || $geneType eq "snRNA" || $geneType eq "snoRNA" || $geneType eq "tRNA"|| $geneType eq "vaultRNA" || $geneType eq "misc_RNA"){
					$ncRNAByState{$position[2]}{$idGene}++;
				}	
			}
			elsif($tline[3] > $position[0] && $tline[3] < $position[1]){
				$ref{$tline[0]}{$key} =$ref{$tline[0]}{$key}.$gene."\t";
				$hGeneType{$geneType}++;
				$hGene{$geneName}++;
				if ($geneType eq  "protein_coding" ||$geneType eq  "polymorphic" || $geneType eq "IG_V_gene" || $geneType eq "IG_C_gene" || $geneType eq "TR_V_gene" || $geneType eq "TR_C_gene" || $geneType eq "TR_D_gene" || $geneType eq "TR_J_gene" || $geneType eq "IG_D_gene" ||	$geneType eq "IG_J_gene"){
					$pcByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "lincRNA" || $geneType eq "3prime_overlapping_ncrna" || $geneType eq "antisense" || $geneType eq "sense_intronic" || $geneType eq "sense_overlapping" || $geneType eq "non_coding" || $geneType eq "macro_lncRNA" || $geneType eq "bidirectional_lncRNA" ){
					$lncRNAByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "miRNA" || $geneType eq "piRNA" || $geneType eq "rRNA" || $geneType eq "siRNA" || $geneType eq "snRNA" || $geneType eq "snoRNA" || $geneType eq "tRNA"|| $geneType eq "vaultRNA"|| $geneType eq "misc_RNA"){
					$ncRNAByState{$position[2]}{$idGene}++;
				}					
			}
			elsif($tline[3] < $position[0] && $tline[4] > $position[1]){
				$ref{$tline[0]}{$key} =$ref{$tline[0]}{$key}.$gene."\t";
				$hGeneType{$geneType}++;
				$hGene{$geneName}++;
				if ($geneType eq  "protein_coding" ||$geneType eq  "polymorphic" || $geneType eq "IG_V_gene" || $geneType eq "IG_C_gene" || $geneType eq "TR_V_gene" || $geneType eq "TR_C_gene" || $geneType eq "TR_D_gene" || $geneType eq "TR_J_gene" || $geneType eq "IG_D_gene" || $geneType eq "IG_J_gene"){
					$pcByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "lincRNA" || $geneType eq "3prime_overlapping_ncrna" || $geneType eq "antisense" || $geneType eq "sense_intronic" || $geneType eq "sense_overlapping" || $geneType eq "non_coding"	|| $geneType eq "macro_lncRNA" || $geneType eq "bidirectional_lncRNA" ){
					$lncRNAByState{$position[2]}{$idGene}++;
				}
				elsif ($geneType eq "miRNA" || $geneType eq "piRNA" || $geneType eq "rRNA" || $geneType eq "siRNA" || $geneType eq "snRNA" || $geneType eq "snoRNA" || $geneType eq "tRNA"|| $geneType eq "vaultRNA" || $geneType eq "misc_RNA"){
					$ncRNAByState{$position[2]}{$idGene}++;
				}

			}	
		}
	}
}
close (F1);

open(RESU1,">/compbio/data/axel/GlobalCount_hepato_EtoL.txt") || die "pblm fichier yata";
foreach my $key(keys(%hGeneType)){
	print RESU1 "$key\t$hGeneType{$key}\n";
}

my $nb =0;

open(RESU,">/compbio/data/axel/pc_hepato_EtoL.txt") || die "pblm fichier yata";
print RESU "State\tGene\n";
foreach my $key(keys(%pcByState)){
	print RESU "$key\t";
	foreach my $key1(keys(%{$pcByState{$key}})){
		print RESU"$key1;";
	}
	print RESU "\n";
	
}
close (RESU);

open(RESU,">/compbio/data/axel/ncRNA_hepato_EtoL.txt") || die "pblm fichier yata";
print RESU "State\tGene\n";
foreach my $key(keys(%ncRNAByState)){
	print RESU "$key\t";
	foreach my $key1(keys(%{$ncRNAByState{$key}})){
		print RESU "$key1;";
	}
	print RESU "\n";
	
}
close (RESU);

open(RESU,">/compbio/data/axel/lncRNA_hepato_EtoL.txt") || die "pblm fichier yata";
print RESU "State\tGene\n";
foreach my $key(keys(%lncRNAByState)){
	print RESU "$key\t";
	foreach my $key1(keys(%{$lncRNAByState{$key}})){
		print RESU "$key1;";
	}
	print RESU "\n";
}
close (RESU);



foreach my $key(keys(%ref)){
	foreach my $key1(keys(%{$ref{$key}})){
		my @tline = split("\t",$ref{$key}{$key1});
		if($#tline >=0){
			print RESU1 "$key\t$key1\t$ref{$key}{$key1}\n";
		}
		else{	
			print RESU1 "$key\t$key1\t$ref{$key}{$key1}\n";
			$nb++;
		}
	}
}

foreach my $key(keys(%hGene)){
	print RESU1 "$key\t$hGene{$key}\n";
}
close(RESU1);

print RESU1 "nb frag without nothing: $nb\n"; 