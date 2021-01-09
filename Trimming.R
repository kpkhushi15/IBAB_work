
########################################### TRIMMING #######################################################
# USE OF TRIM GALORE SYSTEM COMMAND
# After quality control we will perform trimming of adapters and remove the reads below quality threshold and remove reads whose length is less than 20
# Perform Trimming Using system command (trim_galore)

# Set the working directory directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

#######################################################################################################
# Create a TRIMMED directory for storing all the trimmed fastq file in their respective sample directory
system2("mkdir","TRIMMED")
trim_dir=paste(work_dir,"TRIMMED",sep="/")
print(paste("The path of trimmed fastq files ",trim_dir))

########################################################################################################
#Go to fastq file directory
inputpath="/home/ibab/Application/II_sem/Project/Data/FASTQ"

# Go to respective sample dircetory
directory=list.dirs(path = inputpath,recursive=FALSE) 


#########################################################################################################
# Parameters to be used 
# fastqc to perform quality check after trimming
# q threshold for qulaity check
# paired for paired end reads
# length for the length of the reads
# j for core 

#Trimming 
for (fastq in directory){
    setwd(trim_dir)
    var=unlist(strsplit(fastq,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    sample_dir=paste(work_dir,"TRIMMED",dir,sep="/")
    setwd(sample_dir)
    files=list.files(fastq,"fastq$",full=TRUE)
    #files=list.files(fastq, "fastq$", full=TRUE)
    cmd=paste("--fastqc -q 10 -j 4 --paired --nextera --length 20 --path_to_cutadapt /home/ibab/anaconda3/bin/cutadapt",files[1],files[2])
    cat(cmd,"\n") #print the current command
    #system(cmd) # invoke command
    #setwd(work_dir)
    #print(file)
    system2("/home/ibab/anaconda3/bin/trim_galore",args=cmd,stdout=TRUE)
    setwd(work_dir) 
}


# Set the working directory for all the scripts 
#setwd("/home/ibab/Application/II_sem/Project/scripts")
















