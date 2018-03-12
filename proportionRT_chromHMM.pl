#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[3])))
{
print "Param :
\t#Argument 1 : bed file of chroHMM of one specific cell
\t#Argument 2 : bed file with the RT state coordinate and the state name\n";
	die("\n");
}

#1_Active_Promoter
#2_Weak_Promoter
#3_Poised_Promoter
#4_Strong_Enhancer
#5_Strong_Enhancer
#6_Weak_Enhancer
#7_Weak_Enhancer
#8_Insulator
#9_Txn_Transition
#10_Txn_Elongation
#11_Weak_Txn
#12_Repress

#1	TssA	Active TSS	Red	255,0,0#2	TssAFlnk	Flanking Active TSS	Orange Red	255,69,0
#3	TxFlnk	Transcr. at gene 5' and 3'	LimeGreen	50,205,50
#4	Tx	Strong transcription	Green	0,128,0
#5	TxWk	Weak transcription	DarkGreen	0,100,0
#6	EnhG	Genic enhancers	GreenYellow	194,225,5
#7	Enh	Enhancers	Yellow	255,255,0
#8	ZNF/Rpts	ZNF genes & repeats	Medium Aquamarine	102,205,170
#9	Het	Heterochromatin	PaleTurquoise	138,145,208
#10	TssBiv	Bivalent/Poised TSS	IndianRed	205,92,92
#11	BivFlnk	Flanking Bivalent TSS/Enh	DarkSalmon	233,150,122
#12	EnhBiv	Bivalent Enhancer	DarkKhaki	189,183,107
#13	ReprPC	Repressed PolyComb	Silver	128,128,128
#14	ReprPCWk	Weak Repressed PolyComb	Gainsboro	192,192,192
#15	Quies	Quiescent/Low	White	255,255,255

#Early2 Early1
#Early13 Early2 
#Early10 Early3 
#DevE7 Dyn1 
#DevE1 Dyn2 
#Dev4 Dyn3 
#Dev11 Dyn4 
#Dev5 Dyn5 
#DevL3 Dyn6 
#DevL9 Dyn7 
#DevL6 Dyn8
# DevL15 Dyn9
# Late12 Late1 
#Late14 Late2
#Late8 Late3 


my @chromState = ("1_TssA", "2_TssAFlnk", "3_TxFlnk", "4_Tx", "5_TxWk","6_EnhG", "7_Enh", "8_ZNF/Rpts","9_Het", "10_TssBiv", "11_BivFlnk", "12_EnhBiv", "13_ReprPC", "14_ReprPCWk", "15_Quies");
my @rtState = ("Early1","Early2","Early3","Dyn1","Dyn2","Dyn3","Dyn4","Dyn5","Dyn6","Dyn7","Dyn8","Dyn9","Late1","Late2","Late3");
my %plop =(
	"2"=> "Early1", "13" => "Early2", "10" => "Early3","7" => "Dyn1", "1" => "Dyn2", "4" => "Dyn3",
	"11" => "Dyn4", "5" => "Dyn5", "3" => "Dyn6", "9" => "Dyn7", "6" => "Dyn8", "15"=> "Dyn9", "12" => "Late1", "14" => "Late2", "8" => "Late3" 
);
my $rtsum = 0;
my %refRT;
my $dirResu = $ARGV[2];

open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	$refRT{$plop{$tline[3]}}++;
	$rtsum++;
}
close (F1);


my %fileName;
open(F1,$ARGV[3]) || die "pblm fichier $ARGV[3]\n";
while(<F1>){
	chomp($_);
	$_=~/(E\w{3}).{1}(.+)/;
	my $b = $1;
	my $a= $2;
	$a=~s/\s/_/g;
	$fileName{$b}=$a;
	#print "$b\t$a\n";
	
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
	my $pdf = $dirResu."/".$fileName{$tName[0]}.".pdf";
	my $bedtools = $directory."/".$tliste[$i]."_inter.txt";
	my $resuProportion = $dirResu."/".$tliste[$i]."_prop.txt";
	`bedtools intersect -wb -a $ARGV[0] -b $currentFile > $bedtools`;

	
	open(F1,$currentFile) || die "pblm fichier $ARGV[1]\n";
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
		$hCouple{$plop{$rt}}{$chrom} += $size;
		$totalOverlap+=$size;
	}
	close (F1);

	foreach my $key (keys(%refChroHMM)){
		$refChroHMM{$key} = $refChroHMM{$key}/$sumChroHMM;
	}

	
	open(F1,">$resuProportion") || die "pblm fichier $ARGV[2]\n";
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