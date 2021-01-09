###########################################################################################
#Script for Indexing and Alignment 

# Set the working directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

############################################################################################
########################## Download hg38 ###################################################
#Download the hg38 human reference genome for indexing and alignment
# Make a directory for reference genome
system2("mkdir","REF_GENOME")
ref_genome_path=paste(work_dir,"REF_GENOME",sep="/")
#Set the path to download the reference genome(hg38-Human reference genome)
setwd(ref_genome_path)
refgenome_address=paste("-c","https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz")
system2("wget",args=refgenome_address,stdout=TRUE)


#############################################################################################
######################### UNZIP THE GENOME FILE #############################################
# Unzip the hg38 zip file in the same directory

system2("tar",args=c("xvf","hg38.chromFa.tar.gz"))


# Concat all the chromosome fasta file in a single file
path=paste(ref_genome_path,"chroms",sep="/")
setwd(path)
system2("cat",args=c("*.fa",">hg38.fa"))
hg38=paste(path,"hg38.fa",sep="/")
system2("cp",args=c(hg38,ref_genome_path))
setwd(ref_genome_path)


# To free the storage space, we can remove the reference genome tar file
#system2("rm","hg38.chromFa.tar.gz")
# we can also remove the all the chromosome fasta file, if we are not working with individual chromosome
#system2("rmdir", "chroms")


##############################################################################################
########################## BUILD THE INDEX OF GENOME #########################################
# Build the index based on the your requirement of the aligner 
# If you are using Bowtie2 for alignment purpose then build the bowtie2 index or BWA
# Here we have used BWA aligner so we  will build BWA index of reference genome
#cmd=paste("hg38","hg38.fa",sep=" ")
system2("/home/ibab/anaconda3/bin/bwa",args=c("index hg38.fa hg38"))



#Create Alignment folder where all the alignment (sam or bam) files will be stored in their respective directory
setwd(work_dir)
system2("mkdir","ALIGNMENT")
alignment_dir=paste(work_dir,"ALIGNMENT",sep="/")


##############################################################################################
################################## ALIGNMENT #################################################
# Use trimmed fastq file after quality check
setwd(work_dir)
fastq_dir="/home/ibab/Application/II_sem/Project/Data/TRIMMED"
fastq=list.dirs(fastq_dir,recursive=FALSE)
for (sample in fastq){
    setwd(alignment_dir)
    var=unlist(strsplit(sample,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    sample_dir=paste(alignment_dir,dir,sep="/")
    setwd(sample_dir)
    files=list.files(sample,"fq$",full=TRUE)
    bwa_cmd=paste("mem -q -t 6",paste(ref_genome_path,"hg38.fa",sep="/"),files[1],files[2],">",paste(dir,"sam",sep="."),sep=" ")
    system2("/home/ibab/anaconda3/bin/bwa",args=bwa_cmd,stdout=TRUE)
    setwd(work_dir)
}



###############################################################################################
# Set the working directory for all the scripts 
#setwd("/home/ibab/Application/II_sem/Project/scripts")
