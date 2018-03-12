#!/usr/bin/perl 


if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[0])))
{
print "Param :
\t#Argument 1 : bed file
\t#Argument 2 : file avec les coordonnes\n";
	die("\n");
}

#chr19	0	200000	NA	0	.	0	200000	255,255,255

#coordinate file
open(F1,$ARGV[1]) || die "pblm fichier $ARGV[1]\n";
my %ref;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	my $plop= $tline[1]."\t".$tline[2];
	$ref{$tline[0]}{$plop}=0;
	
}
close (F1);
#Input annotation file
open(F1,$ARGV[0]) || die "pblm fichier $ARGV[0]\n";
my $size = 0;
while(<F1>){
	chomp($_);
	my @tline = split("\t",$_);
	print "$_\n";
	foreachc
			my @position = split("\t",$key);
			if($position[0] >= $tline[1] && $position[1] <= $tline[2]){
				$size += $position[1]-$position[0] ;
				$ref{$tline[0]}{$key}++; 
			}
			elsif ($position[0] < $tline[1]  && $position[1] > $tline[1] && $position[1] <= $tline[2]){
				$size += $position[1]-$tline[1];
				$ref{$tline[0]}{$key}++; 
			}
			elsif($position[0] >= $tline[1] && $position[0] < $tline[2] && $position[1]> $tline[0]){
				$size += $tline[2]-$position[0] ;
				$ref{$tline[0]}{$key}++;
			}
			elsif($position[0] < $tline[1] && $position[0] > $tline[2]){
				$size += $tline[2]-$tline[1];
				$ref{$tline[0]}{$key}++; 
			}	
	
		}
}
close (F1);


my $sum = 0;
foreach my $key(keys(%ref)){
	foreach my $key1(keys(%{$ref{$key}})){
			$sum+=$ref{$key}{$key1};
			if($ref{$key}{$key1}>0){
			print "$key\t$key1\t$ref{$key}{$key1}\n";}
	}
}

print "$size\t$sum	\n"