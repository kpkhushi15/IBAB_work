################################################################################################################
####################################### QUALITY CONTROL ########################################################
# We will use FASTQC tool for quality control of the fastq files
#### Required Packages  Installation
#install.packages("fastqcr", dep=TRUE)
#install.packages('xml2')
#install.packages("pander")


# Load the Required Library 
library('pander')
library('xml2')
library("fastqcr")



# Set the working directory
setwd("/home/ibab/Application/II_sem/Project/Data/FASTQ")
# Input path to fastq files
inputpath="/home/ibab/Application/II_sem/Project/Data/FASTQ"
directory=list.dirs(path = inputpath,recursive=FALSE) 
for (i in directory){
   fastqc(fq.dir = i, qc.dir = NULL, threads = 4,fastqc.path = "/home/ibab/anaconda3/bin/fastqc")   # Fastqc command
    
}

# Read the aggregate fastqc report for each sample
for (i in directory){
  fastqc_dir=file.path(i,"FASTQC")
  qc=qc_aggregate(fastqc_dir, progressbar = FALSE)  #Aggregate Report
  print(qc)
  print(summary(qc))  #Summarizing Reports
  print(qc_stats(qc))#General statistics
  html=list.files(fastqc_dir,"html$",full=TRUE)
  for (one_html in html){
   openFileInOS(one_html) # Opening a fastqc report 
  }    
  
}

# Set the working directory for all the scripts if running from command prompt
# setwd("/home/ibab/Application/II_sem/Project/scripts")

