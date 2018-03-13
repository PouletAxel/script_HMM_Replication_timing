#! /usr/bin/perl


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[0])))
{
print "# File of contiguous bins to computed the size of domains by chromosomes :
\t#Argument 0 : bed file of state\n";
	die("\n");
}

open(F1,$ARGV[0]) || die "File problem $ARGV[0]\n";
my @tpreced;
my @tnewLine;
my @tTmp;
my $i=0;
my %chrTailleBins;
my %nbChr;
my $nb50kb=0;
my %chrDistance;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	if($tline[0] eq $tpreced[0] && $tline[1] == $tpreced[2]){
		$tnewLine[2] = $tline[2];
		$tnewLine[$#tnewLine]++;
	}
	
	else{
		my $tmp = join ("\t", @tnewLine);
		push(@tTmp,$tmp);
		if($tnewLine[2]-$tnewLine[1] == 50000){$nb50kb++;}
		$nbChr{$tnewLine[0]}++;
		$chrTailleBins{$tnewLine[0]} = $chrTailleBins{$tnewLine[0]}+($tnewLine[2]-$tnewLine[1]);
		if($i > 0){
			my @a = split("\t",$tTmp[$i-1]);
			if ($a[0] eq $tnewLine[0]){
			 my $distance = $tnewLine[1]-$a[2];
			 #print "$a[0]\t$a[2]\t$tnewLine[1]\t$distance\n";
			 $chrDistance{$a[0]} = $chrDistance{$a[0]}+$distance;
			}
		}
		@tnewLine = @tline;
		push(@tnewLine,"1");
		$i++;
	}
	@tpreced = @tline;
}
close (F1);

my $meanSizeGlobal = 0;
my $meanDistanceGlobal = 0;
print "chr\tsize\tdistance\tnb of domains\n";
foreach my $key (keys(%nbChr)){
	my $meanSize = $chrTailleBins{$key}/$nbChr{$key};
	$meanSizeGlobal+= $chrTailleBins{$key};
	my $meanDistance = $chrDistance{$key}/$nbChr{$key};
	$meanDistanceGlobal+= $chrDistance{$key};
	print "$key\t$meanSize\t$meanDistance\t$nbChr{$key}\n";
}

$meanSizeGlobal = $meanSizeGlobal/$i;
$meanDistanceGlobal = $meanDistanceGlobal/$i;
print "nb of 50kb domains\tmean size\tmean distance\n$nb50kb\t$meanSizeGlobal\t$meanDistanceGlobal\n";