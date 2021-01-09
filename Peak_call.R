#######################################################################################################################
##################################### PEAK CALL USING GENRICH #########################################################
# Call peaks with Genrich, which was developed in the Informatics Group
# Genrich was designed to be able to run all of the post-alignment steps through peak-calling with one command. It also possesses a few novel features.
# Follow the documentation for Genrich "https://github.com/jsh58/Genrich"

# Set the working directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"


# Create PEAK_CALL directory 
system2("mkdir","PEAK_CALL")
peakcall_dir=paste(work_dir,"PEAK_CALL",sep="/")


# Alignment for the peak call has been done
# We will use the sequence alignment file for further processing and peak calls
# Sort the SAM file by read name and convert it to BAM ( SAM binary format) using
# This file is used by Genrich

# Here the input is SAM file stored in PEAK_ALIGNMENT directory
alignment_dir=paste(work_dir,"PEAK_ALIGNMENT",sep="/")
alignment_sample_dir=list.dirs(alignment_dir,recursive=FALSE)
print(alignment_sample_dir)


# Processing for each sample in alignment directory and output will be stored in PEAK_ALIGNMENT directory 
for (sample in alignment_sample_dir){
    setwd(peakcall_dir)
    var=unlist(strsplit(sample,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    sample_dir=paste(peakcall_dir,dir,sep="/")
    # For each sample call the peaks
    setwd(sample_dir)
    sam_file=list.files(sample,"sam$",full=TRUE)

    ############################################################################################
    # Convert the sam to bam
    sam_to_bam_cmd=paste(sam_file,paste("> ",dir,"_noadapt.bam",sep=""),sep=" ")
    #system2("/usr/local/bin/samtools",args=c("view -@ 5 -u -Sb",sam_to_bam_cmd),stdout=TRUE)


    ############################################################################################
    # sort the BAM file by the leftmost mapping coordinate
    # Input file for sorting
    bam_file=list.files(sample_dir,"_noadapt.bam$")
    sort_bam_cmd=paste("-o",paste(dir,"_noadapt.sorted.bam",sep=""),sep=" ")
    system2("/usr/local/bin/samtools",args=c("sort -@ 5 -n",bam_file,sort_bam_cmd),stdout=TRUE)


    # Peak call command 
    sorted_bam_file=list.files(sample_dir,"_noadapt.sorted.bam$",full=TRUE)
    genrich_cmd=paste("-t",sorted_bam_file,"-j -y -r -e chrM  -v","-o",paste(dir,"_noadapt.narrowPeak",sep=""),sep=" ")
    system2("/home/ibab/anaconda3/bin/Genrich",args=genrich_cmd,stdout=TRUE)
    setwd(work_dir)
}




