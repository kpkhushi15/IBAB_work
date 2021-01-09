#######################################################################################################################################
################################### ADAPTER REMOVAL USING NGmerge FOR PEAK CALL #######################################################
# After quality control we will perform trimming of adapters and remove the reads below quality threshold and remove reads whose length is less than 2

# Set the working directory directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

#######################################################################################################
# Create a ADAPTER REMOVAL directory for storing all the trimmed fastq file in their respective sample directory
system2("mkdir","ADAPTER_RMV")
adpat_rmv_dir=paste(work_dir,"ADAPTER_RMV",sep="/")
print(paste("The path of adapter removed fastq files ",adpat_rmv_dir))

########################################################################################################
#Go to fastq file directory
inputpath="/home/ibab/Application/II_sem/Project/Data/FASTQ"

# Go to respective sample dircetory
directory=list.dirs(path = inputpath,recursive=FALSE) 


#########################################################################################################
# Parameters to be used 

# Adapter Removal 
for (fastq in directory){
    setwd(adpat_rmv_dir)
    var=unlist(strsplit(fastq,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    sample_dir=paste(work_dir,"ADAPTER_RMV",dir,sep="/")
    setwd(sample_dir)
    files=list.files(fastq,"fastq$",full=TRUE)
    cmd=paste("-a -1",files[1],"-2",files[2],"-u 41 -n 8","-o",dir,"-v",sep=" ")
    cat(cmd,"\n") #print the current command
    system2("/home/ibab/software/NGmerge/NGmerge",args=cmd,stdout=TRUE)
    #setwd(work_dir) 
}
##########################################################################################################
