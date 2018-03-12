#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[3])))
{
print "Param :
\t#Argument 1 : Directory with bed file of chroHMM resu
\t#Argument 2 : bed file with the RT state coordinate and the state name
\t#Argument 3 : output directory\n";
	die("\n");
}


#    State 1 -  Bright Red  - Active Promoter
#    State 2 -  Light Red  -Weak Promoter
#    State 3 -  Purple  - Inactive/poised Promoter
#    State 4 -  Orange  - Strong enhancer
#    State 5 -  Orange  - Strong enhancer
#    State 6 -  Yellow  - Weak/poised enhancer
#    State 7 -  Yellow  - Weak/poised enhancer
#    State 8 -  Blue  - Insulator
#    State 9 -  Dark Green  - Transcriptional transition
#    State 10 -  Dark Green  - Transcriptional elongation
#    State 11 -  Light Green  - Weak transcribed
#    State 12 -  Gray  - Polycomb-repressed
#    State 13 -  Light Gray  - Heterochromatin; low signal
#    State 14 -  Light Gray  - Repetitive/Copy Number Variation
#    State 15 -  Light Gray  - Repetitive/Copy Number Variation 


## Change if the state are not the same
my @chromState = ("1_Active_Promoter", "2_Weak_Promoter", "3_Poised_Promoter", "4_Strong_Enhancer", "5_Strong_Enhancer","6_Weak_Enhancer", "7_Weak_Enhancer", "8_Insulator","9_Txn_Transition", "10_Txn_Elongation", "11_Weak_Txn", "12_Repressed", "13_Heterochrom/lo", "14_Repetitive/CNV", "15_Repetitive/CNV");
my @rtState = ("Early1","Early2","Early3","Dyn1","Dyn2","Dyn3","Dyn4","Dyn5","Dyn6","Dyn7","Dyn8","Dyn9","Late1","Late2","Late3");

my $rtsum = 0;
my %refRT;
my $dirResu = $ARGV[2];

open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	$refRT{$tline[3]}++;
	$rtsum++;
}
close (F1);


foreach my $key (keys(%refRT)){
		$refRT{$key} = $refRT{$key}/$rtsum;
}

my $directory = $ARGV[1];
my $liste= `ls $directory`;
my @tliste=split("\n", $liste);


for(my $i=0; $i<=$#tliste; $i++){
	
	my $currentFile =  $directory."/".$tliste[$i];
	my @tName =split("_", $tliste[$i]);
	$tliste[$i] =~s/\.bed//g;
	my $pdf = $dirResu."/".$tName[0].".pdf";
	my $bedtools = $directory."/".$tliste[$i]."_inter.txt";
	my $resuProportion = $dirResu."/".$tliste[$i]."_prop.txt";
	`bedtools intersect -wb -a $ARGV[0] -b $currentFile > $bedtools`;

	
	open(F1,$currentFile);
	my %refChroHMM;
	my $sumChroHMM=0;
		while(<F1>){
		chomp($_);
		my @tline = split("\t",$_);
		my $size= $tline[2]-$tline[1];
		$refChroHMM{$tline[3]}+=$size;
		$sumChroHMM+=$size;
	}
	close (F1);

	#chr1	800000	800537	2	chr1	794337	800537	13_Heterochrom/lo	0	.	794337	800537	245,245,245
	#chr1	800000	800800	2	chr1	799800	800800	14_ReprPCWk
	open(F1,$bedtools) || die "pblm fichier $ARGV[2]\n";

	my %hCouple;
	my $totalOverlap =0;
	while(<F1>){
		chomp($_);
		my @tline = split("\t",$_);
		my $rt = $tline[3];
		my $chrom = $tline[7];
		my $size = $tline[2]-$tline[1];
		$hCouple{$rt}{$chrom} += $size;
		$totalOverlap+=$size;
	}
	close (F1);

	foreach my $key (keys(%refChroHMM)){
		$refChroHMM{$key} = $refChroHMM{$key}/$sumChroHMM;
	}

	
	open(F1,">$resuProportion");
	my $alinec=join("\t",@chromState);
	print F1 "State\t$alinec\n";
	for(my $i = 0; $i <=$#rtState; $i++){
		my $key = $rtState[$i];
		print F1 "$key";
		for(my $j=0; $j<= $#chromState; $j++){
			my $key2 = $chromState[$j];
			if(defined($hCouple{$key}{$key2})){
				$hCouple{$key}{$key2} = ($hCouple{$key}{$key2}/$totalOverlap)/($refRT{$key}*$refChroHMM{$key2});
				print F1 "\t$hCouple{$key}{$key2}";
			}
			else{print F1"\t0";}
		}
		print F1"\n";
	}
	close(F1);
	print "$fileName{$tName[0]}\n";
}