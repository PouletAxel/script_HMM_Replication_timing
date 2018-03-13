#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[1])))
{
print "Param :
\t#Argument 1 : bed file of RT state
\t#Argument 2 : file\n";
	die("\n");
}


open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
my %RT;
my %plop;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	my $a=$tline[1]."\t".$tline[2];
	$RT{$tline[0]}{$a}=$tline[3];
	$plop{$tline[3]}++;
}
close (F1);



open(F1,$ARGV[1]) || die "pblm fichier $ARGV[0]\n";
my %tasnpNb;
my %snp;
my %resu;
my $li = <F1>;
$nb = 0;
$nbSansDoublon = 0;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	if(!(defined($snp{$tline[2]}))){
		$tasnpNb{$tline[1]}++;
		$snp{$tline[2]}="";
		my $chr ="chr".$tline[4];
		if(defined($RT{$chr})){
		foreach my $key (keys(%{$RT{$chr}})){
				my @tCoord = split("\t",$key);
				if($tline[5]>= $tCoord[0] && $tline[5]<=$tCoord[1]){
					$resu{$tline[1]}{$RT{$chr}{$key}}++;
					break;
				}
			}
		}
		$nbSansDoublon++;
	}
	$nb++;
}
close (F1);

print("prout $nb\t$nbSansDoublon\n");

my @tkey = keys(%plop);
my $li = join("\t",@tkey);
print "taSNP\t$li\tnb Of taSNP\n";
$li = "nb Bins";
for(my $i = 0; $i<=$#tkey; $i++ ){
	$li = $li."\t".$plop{$tkey[$i]};
}
print "$li\n";
foreach my $key1 (keys(%tasnpNb)){
	my $l = $key1;
	for(my $i = 0; $i<=$#tkey; $i++ ){
		if(defined($resu{$key1}{$tkey[$i]})){
			$l = $l."\t".$resu{$key1}{$tkey[$i]};
		}
		else{	$l = $l."\t0";}
	}
	print"$l\t$tasnpNb{$key1}\n";
}