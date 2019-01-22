# Code for Fasta to AGP Format Conversion


This perl script will convert WGS assembly file (.fasta format) to Standard AGP file format. The rules for format conversion are followed by the NCBI guidelines given <a href="https://www.ncbi.nlm.nih.gov/projects/genome/assembly/agp/AGP_Specification_1_1.pdf">here</a>.

	NAME:
		FastaToAGPFileFormatConverter.pl

	DESCRIPTION:
		This code will convert standard fasta file
		into AGP v.2.0 file format.
		This code is work for only scaffold level and
		contig level assemblies.
		 
	AUTHOR:
		Nitin N.
		Email: nitinnarwade1504@gmail.com
	
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
