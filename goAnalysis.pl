#! /usr/bin/perl
use strict;
use Spreadsheet::ParseExcel;

if (($ARGV[0] eq "-h") || ($ARGV[0] eq "--h") || ($ARGV[0] eq "-help" )|| ($ARGV[0] eq "--help")|| (!defined($ARGV[0])))
{
print "# Dossier contenant le ou les fichiers a parcourir :
\t#Argument 0 : xls file\n";
	die("\n");
}

## Parcours peaks files cat broad and narrow peaks file of road map


my $directory = $ARGV[0];
my $liste= `ls $directory`;
my @tliste=split("\n", $liste);
my @nameState;
my %plop;
# count peak density on function of the RT file coordinate
for(my $i=0; $i<=$#tliste; $i++){
	
	my $currentFile =  $directory."/".$tliste[$i];
	$tliste[$i] =~s/\.xls//g;
	my $output = $tliste[$i]."_resu.txt";
	open(F1, ">$output");
	my $parser   = Spreadsheet::ParseExcel->new();
	my $workbook = $parser->parse($currentFile);
    if ( !defined $workbook ) {
      die $parser->error(), ".\n";
    }
	my $worksheet = $workbook->worksheet(0);
	my $name = $worksheet->get_name();
	my ( $row_min, $row_max ) = $worksheet->row_range();
	my ( $col_min, $col_max ) = $worksheet->col_range();
	for my $row ( 1 .. $row_max ) {
		my $cellGo = $worksheet->get_cell( $row, 0);
		my $cellFunction = $worksheet->get_cell($row, 1);
		my $function = $cellFunction->value();
		my $cell = $worksheet->get_cell( $row, $col_max);
		my $pvalue2 = $cell->value();
		my $cellNbProt = $worksheet->get_cell( $row, 6);
		my $bis = $cellNbProt->value();
		#print "$bis\n";
		my @t = split ("on",$bis);
		if($t[1] < 5000 && $t[1] ne "ERROR"){
			if ( $pvalue2 ne "NS" && $pvalue2 < 0.00001){
				my $value = $cellGo->value();
				my $function =$cellFunction->value();
				my $key = $value."\t".$function;
				print F1 "$function\t$pvalue2\n";
			}
		}
	}
	close(F1);
}	







