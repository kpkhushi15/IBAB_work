##################################################################################################
##################################### ECCDNA IDENTIFICATION ######################################

# Here Circle map pipeline is being used for ECCDNA identification
# Install the Circle-Map tool from github
# Installation using pip:
#command: "python -m pip install Circle-Map"

# Installation using conda:
#Command: "conda install -c bioconda circle-map"


# Set the working directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

##################################################################################################
################################### SORTING and INDEXING #########################################

# Create ECCDNA directory 
system2("mkdir","ECCDNA")
eccdna_dir=paste(work_dir,"ECCDNA",sep="/")


# Alignment has been done
# We will use the sequence alignment file for further processing and identification of eccDNA
# Sort the SAM file by read name and convert it to BAM ( SAM binary format) using:
# This file is used by Circle-Map to extract the circular DNA read candidates and to estimate the paremeters of the prior distribution.

# Here the input is SAM file stored in ALIGNMENT directory
alignment_dir=paste(work_dir,"ALIGNMENT",sep="/")
alignment_sample_dir=list.dirs(alignment_dir,recursive=FALSE)
print(alignment_sample_dir)

# Processing for each sample in alignment directory and output will be stored in ECCDNA directory 
for (sample in alignment_sample_dir){
    setwd(eccdna_dir)
    var=unlist(strsplit(sample,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    sample_dir=paste(eccdna_dir,dir,sep="/")
    # For each sample identify the eccDNA 
    setwd(sample_dir)
    sam_file=list.files(sample,"sam$",full=TRUE)

    ###########################################################################################
    # Convert the sam to bam
    sam_to_bam_cmd=paste(paste(dir,".bam",sep=""),sam_file,sep=" ")
    system2("/usr/local/bin/samtools",args=c("sort -@ 5 -n -o",sam_to_bam_cmd),stdout=TRUE)


    ############################################################################################
    # sort the BAM file by the leftmost mapping coordinate
    # This file is used by Circle-Map to calculate the genomic coverage metrics
    # Input file for sorting
    
    sort_bam_cmd=paste(paste(dir,"_sorted",".bam",sep=""),sam_file,sep=" ")
    system2("/usr/local/bin/samtools",args=c("sort -@ 5 -o",sort_bam_cmd),stdout=TRUE)
    
    #############################################################################################
    # we will extract the reads that indicate circular DNA rearrangements ( partially mapped reads and discordant read pairs) using Circle-Map:
    # Here input is the bam file
    bam_file=list.files(sample_dir,paste(dir,"bam",sep="."))
    read_extract_cmd=paste(bam_file,"-o",paste(dir,"_circular_read_candidates.bam",sep=""),sep=" ")
    system2("/home/ibab/anaconda3/bin/Circle-Map",args=c("ReadExtractor -i",read_extract_cmd),stdout=TRUE)
    


    #############################################################################################
    # We will sort the read candidates by coordinate with SAMtools:
    read_candidate_file=list.files(sample_dir,"_circular_read_candidates.bam$")
    sort_read_candidate_cmd=paste(paste(dir,"_sort_circular_read_candidates.bam",sep=""),read_candidate_file,sep=" ")
    system2("/usr/local/bin/samtools",args=c("sort -@ 5 -o",sort_read_candidate_cmd),stdout=TRUE)

    #############################################################################################
    # Index the bam file
    sort_read_candidate_file=list.files(sample_dir,"_sort_circular_read_candidates.bam$")
    index_bam_cmd=paste(sort_read_candidate_file,sep=" ")
    system2("/usr/local/bin/samtools",args=c("index -@ 5",index_bam_cmd),stdout=TRUE)
    

    #############################################################################################
    sorted_bam_file=list.files(sample_dir,"_sorted.bam$")
    index_sorted_bam_cmd=paste(sorted_bam_file,sep=" ")
    system2("/usr/local/bin/samtools",args=c("index -@ 5",index_sorted_bam_cmd),stdout=TRUE)
     
    ##############################################################################################
    #Finally, we are ready to use Circle-Map Realign to detect the circular DNA. Circle-Map will take as input the following files we have generated above:
    # sort_circular_read_candidates.bam: The circular DNA read candidates. Used for detecting the circular DNA
    # qname_unknown_circle.bam: The read name sorted BAM file. Used for calculating the realignment prior
    # sorted_unknown_circle.bam: The coordinate sorted BAM. Used for calculating circular DNA coverage metrics
    # hg38.fa: Reference sequence. Used for realignment of the partially mapped reads.
    ref_genome_path="/home/ibab/Application/II_sem/Project/Data/REF_GENOME/hg38.fa"
    realign_cm=paste(sort_read_candidate_file,"-qbam",bam_file,"-sbam",sorted_bam_file,"-fasta",ref_genome_path,"-o",paste(dir,".bed",sep=""),sep=" ")
    system2("/home/ibab/anaconda3/bin/Circle-Map",args=c("Realign -t 5 -i",realign_cm),stdout=TRUE)
    setwd(work_dir)

}





