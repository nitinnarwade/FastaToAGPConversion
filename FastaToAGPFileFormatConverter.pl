#!usr/bin/perl

##
##	This code is written by 'Nitin'
##

use strict;
use warnings;
use Getopt::Long;

my $inputFileName;
my $outputFileName;
my $scaffoldLenCutOff;
my $assemblyLevel;
my $prefixORAssemblyName;
my $organismName;
my $taxId;
my $assemblyDate;
my $genomeCenter;
my $assemblyType;
my $help;

my %hashFortabSepSequence;

GetOptions ('i=s' => \$inputFileName,
			'h' => \$help,
			'a=s' => \($assemblyLevel = "Scaffold"),
			'l=i' => \($scaffoldLenCutOff = 0),
			'p=s' => \($prefixORAssemblyName = "HG"),
			'org=s' => \($organismName = "-"),
			'taxanomicID=s' => \($taxId = "-"),
			'date=s' => \($assemblyDate = "-"),
			'center=s' => \($genomeCenter = "-"),
			't=s' => \($assemblyType = '-'),
			'o=s' => \($outputFileName = "$assemblyLevel" . "OuptuAGPFile" . ".agp")
			)
			
or die("ERROR:\n\tError in command line arguments.\n\n");

if($help) {
	&PrintHelp();
}
if(!$inputFileName) {
	die "ERROR:\n\tError occured Please provide input file.\n\n";
}

&fastaFileToTab();
my $count = 1;
my $countID = 1;
my $tempGapType;
my $tempLinkage;
my $tempLinkageEvidence;

if($assemblyLevel=~m/Scaffold/i) {
	$tempGapType = "scaffold";
	$tempLinkage = "yes";
	$tempLinkageEvidence = "0";
} elsif($assemblyLevel=~m/contig/i) {
	$tempGapType = "contig";
	$tempLinkageEvidence = "+";
} else {
	die "\n\tOnly two assembly levels are covered by this code.\n\t(i.e. scaffold level and contig level)."
}

open(AGP,"> $outputFileName") or die "Can not write to $outputFileName File\n";

print AGP "##agp-version	2.0\n";
print AGP "# ORGANISM: Homo sapiens\n";
print AGP "# TAX_ID: 9606\n";
print AGP "# ASSEMBLY NAME: EG1\n";
print AGP "# ASSEMBLY DATE: 09-November-2011\n";
print AGP "# GENOME CENTER: NCBI\n";
print AGP "# DESCRIPTION: AGP File specifying the assembly of $assemblyLevel\n";
print AGP "# object_ID\tobject_beg\tobject_end\tpart_number\tcomponent_type\tcomponentID_OR_GapLength\tcomponentBeg_OR_GapType\tcomponentEnd_OR_Linkage\tOrientation_OR_LinkageEvidence\n";

foreach my $seqID (sort {lc $a cmp lc $b} keys %hashFortabSepSequence) {
	my $colNo1_ID = $prefixORAssemblyName . "_" . $assemblyLevel . "$count";
	$count++;
	my $counterForGapType = 0;
	
	my $colNo2_Start = 1;
	my $colNo3_End;
	my $colNo4_PartNo = 0;
	my $colNo5_Type;
	my $colNo6_CompID_GapLen;
	my $colNo7_CompBeg_GapType;
	my $colNo8_CompEnd_Linkage;
	my $colNo9_Orientation_LinkageEvidence;
	
	foreach my $subseq ( split /(N+)/i, $hashFortabSepSequence{$seqID} ) {
		if($subseq=~m/^N+$/i) {
			$colNo3_End = ($colNo2_Start + length($subseq)) - 1;
			$colNo4_PartNo++;
			$colNo5_Type = 'N';
			$colNo6_CompID_GapLen = length($subseq);
			$colNo7_CompBeg_GapType = $tempGapType;
			$colNo8_CompEnd_Linkage = $tempLinkage;
			$colNo9_Orientation_LinkageEvidence = $tempLinkageEvidence;
		} elsif($subseq=~m/^[ATGC]+$/i) {
			$colNo3_End = ($colNo2_Start + length($subseq)) - 1;
			$colNo4_PartNo++;
			$colNo5_Type = 'W';
			$colNo6_CompID_GapLen = $assemblyLevel . "_" . $countID;
			$countID++;
			$colNo7_CompBeg_GapType = 1;
			$colNo8_CompEnd_Linkage = length($subseq);
			$colNo9_Orientation_LinkageEvidence = $tempLinkageEvidence;
		} else {
			die "Illegal characters present in sequence\n$subseq\n";
		}
		print AGP "$colNo1_ID\t$colNo2_Start\t$colNo3_End\t$colNo4_PartNo\t$colNo5_Type\t$colNo6_CompID_GapLen\t$colNo7_CompBeg_GapType\t$colNo8_CompEnd_Linkage\t$colNo9_Orientation_LinkageEvidence\n";
		$colNo2_Start += length ($subseq);
		$counterForGapType++;
	}
}
close(AGP);

sub fastaFileToTab() {
	my $header = "";
	my $sequence = "";
	
	open(IN,"$inputFileName") or die "can't open $inputFileName";
	
	while(my $line = <IN>) {
		chomp $line;
		if($line=~m/^\>/) {
			if(length($sequence) != 0) {
				$hashFortabSepSequence {$header} = $sequence;
				$sequence = "";
			}
			$header = $line;
		} else {
			$sequence .= $line;
		}
	}
	$hashFortabSepSequence {$header} = $sequence;
	close(IN);
}

sub PrintHelp() {
  print <<EndHelp;

	NAME:
		FastaToAGPFileFormatConverter.pl

	DESCRIPTION:
		This code will convert standard fasta file
		into AGP v.2.0 file format.
		This code is work for only scaffold level and
		contig level assemblies.
		 
	AUTHOR:
		Nitin N.
		Email: nitinnarwade1504\@gmail.com
	
	OPTIONS:
		-i
			Specify input file in standard fasta format.
			This option require input file name as an argument.
			(eg. -i inputFileName.fasta)
			Mandatory argument.
		
		-o
			Specify output file. 
			This option require output file name as an argument.
			(eg. -o ouptutIFleame.agp)
			Optional argument. By deffault output file name is 'ASSEMBLYLEVEL.agp'.
			
		-h
			print detailed help on consol.
			This option does not require any argument.
			(eg. perl code.pl -h).
			
		-a
			Specify the assembly level. This option require an argument.
			(eg. -a scaffold OR -a contig).
			[Optional argument. Default Value = scaffold].
			
		-l
			Specify the scaffold length cutoff.
			[Optional argument. Default Value = 0].
			
		-p
			Specify the prefix for id.
			[Optional argument. Defualt Value = HG].
			
		--org
			Specify organism name
			[Optional argument. Default Value = "-"].
		
		--taxanomicID
			Specify taxanomic Identifier for organism.
			[Optional argument. Default Value = "-"].
			
		--date
			Specify the date of assembly.
			[Optional argument. Default Value = "-"].
			
		--center
			Specify the assembly center.
			[Optional argument. Default Value = "-"].
		
		-t
			Specifiy assembly Type.
			[Optional argument. Default Value = "-"]
		
	EXAMPLE:
		perl FastaToAGPFileFormatConverter.pl -i datafile.fa

EndHelp
die "\n";
}
