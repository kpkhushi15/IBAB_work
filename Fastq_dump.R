#############################################################################
## Split the SRA file to fastq files Using Fastq_dump tools

#############################################################################
#Set the working directory where your SRA file is stored
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

#You can also provide SRA file path as input for the following processing
inputpath="/home/ibab/Application/II_sem/Project/Data/SRA"
#directory=dir(path = inputpath,full=FALSE,all.files=FALSE,pattern="[0-9]$") 

#Check how many SRA files is in SRA dircetory and their path
input_files=list.files(path = inputpath,recursive=FALSE,pattern="[0-9]$",full=TRUE)
SRA_files=list.files(path = inputpath,recursive=FALSE,pattern="[0-9]$")
print(paste("Number of SRA files for the following processing :",  length(SRA_files)))
print(paste("SRA IDs : " ,SRA_files))
print(paste("Path for SRA files are : ",input_files))


##############################################################################
# Create FASTQ file directory in which all the fastq file will be stored after fastq-dump

system2("mkdir","FASTQ")
output_path=file.path("/home/ibab/Application/II_sem/Project/Data","FASTQ")
# path of the fastq files
print(paste("All fastq files will be stored in the following path : ",output_path))

###############################################################################
# Split the SRA files to fastq 
for(file in input_files) {
  setwd(output_path)
  var=unlist(strsplit(file,split="/"))
  dir=var[length(var)]
  system2("mkdir",dir)
  sample_dir=paste(work_dir,"FASTQ",dir,sep="/")
  setwd(sample_dir)
  cmd = paste("/home/ibab/software/sratoolkit.2.10.8-ubuntu64/bin/fastq-dump --split-files", file,sep=" ")
  print(cmd)
  print(cat(cmd,"\n")) #print the current command
  system(cmd) # invoke command
  setwd(work_dir)
}
#################################################################################
# If you are running the scripts from terminal then use set the wiorking directory where all the scripts are there
#setwd("/home/ibab/Application/II_sem/Project/scripts")


