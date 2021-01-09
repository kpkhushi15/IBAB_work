
##################################################################################################################
####################################### Downstream Analysis of eccDNA ############################################
# Install dplyr package 
#install.packages("dplyr")
# Load the library
library(dplyr)


# Set the working directory
setwd("/home/ibab/Application/II_sem/Project/Data")
work_dir="/home/ibab/Application/II_sem/Project/Data"

# Now store all the eccDNA file from ECCDNA/Sample to a common folder
system2("mkdir","DOWNSTREAM_ECCDNA")
downstream=paste(work_dir,"DOWNSTREAM_ECCDNA",sep="/")
print(downstream)


##################################################################################################################
# Go to each ECCDNA/sample and copy the sample.bed file and paste it into the DOWNSTREAM_ECCDNA
eccdna_dir=paste(work_dir,"ECCDNA",sep="/")
dir=list.dirs(eccdna_dir,recursive=FALSE)
for (files in dir){
    setwd(downstream)
    var=unlist(strsplit(files,split="/"))
    dir=var[length(var)]
    system2("mkdir",dir)
    downstream_sample=paste(downstream,dir,sep="/")
    setwd(downstream_sample)
    bed_file=list.files(files,".bed$",full=TRUE)
    system2("mv",args=c(bed_file,downstream_sample))
    setwd(work_dir)
}

###################################################################################################################
# Go to each PEAK/sample and copy the sample.narrowpeak file and paste it into the DOWNSTREAM_ECCDNA
peakcall_dir=paste(work_dir,"PEAK_CALL",sep="/")
peak_dir=list.dirs(peakcall_dir,recursive=FALSE)
peak_dir
for (peak_files in peak_dir){
    setwd(downstream)
    var=unlist(strsplit(peak_files,split="/"))
    dir=var[length(var)]
    downstream_sample=paste(downstream,dir,sep="/")
    #setwd(downstream_sample)
    peak_file=list.files(peak_files,".narrowPeak$",full=TRUE)
    system2("mv",args=c(peak_file,downstream_sample))
    setwd(work_dir)
}

#####################################################################################################################
# Set the working directory as downstream 
setwd(downstream)
downstream_sample=list.dirs(downstream,recursive=F)
for (sample_dir in downstream_sample){
    setwd(sample_dir)
    eccDNA_file=list.files(sample_dir,".bed$")
    # Read the file
    file=read.csv(eccDNA_file,sep="\t",header=FALSE)
    # View the dataframe
    #View(s)
    # Rename the column name as described in Circle-Map outout file
    colnames(file)=c("Chromosome","Start_coordinate","End_coordinate","Disc_reads","Split_reads","Circle_score","Mean_coverage","Standard_deviation","Coverage_start","Coverage_end","Coverage_continuity")
    # Calculate the length of the eccDNA
    file$Len_eccDNA=file$End_coordinate-file$Start_coordinate
    # Filter the eccDNA using the criteria defined by Circle-Map for the quality of the eccDNA
    file=filter(file,Disc_reads>0,Split_reads>0,Circle_score>40,Coverage_continuity<0.5,Chromosome!="chrM")
    # Write the filtered output to new file
    var=unlist(strsplit(eccDNA_file,split="\\."))
    output_filename=paste(var[1],"_filtered.bed",sep="")
    write.table(file,output_filename,row.names=F,col.names=F,sep="\t",quote=FALSE)
    setwd(work_dir)
}

#####################################################################################################################
# Find the overlapping regions in eccDNA and peak call based on the chromosome start and end coordinates 
# Here bedtools intersect is used to find overlapping region and columns from both the files has been combined in single file along the overlapping region length
setwd(downstream)
downstream_sample=list.dirs(downstream,recursive=F)
for (sample_dir in downstream_sample){
    setwd(sample_dir)
    filtered_bedfile=list.files(sample_dir,"_filtered.bed$")
    peak_file=list.files(sample_dir,".narrowPeak$")
    var=unlist(strsplit(peak_file,split="\\."))
    overlap_output_filename=paste(var[1],"_overlap.bed",sep="")
    bedtool_intesect_cmd=paste("intersect -a",filtered_bedfile,"-b",peak_file,"-F 0.4 -wo",">",overlap_output_filename,sep=" ")
    system2("/home/ibab/anaconda3/bin/bedtools",args=bedtool_intesect_cmd,stdout=T)
    ################################################################################################
    # Read the Overlap region file 
    overlap_file=list.files(sample_dir,"_noadapt_overlap.bed$")
    file=read.csv(overlap_file,sep="\t",header=FALSE)
    colnames(file)=c("Chromosome","Start_coordinate","End_coordinate","Disc_reads","Split_reads","Circle_score","Mean_coverage","Standard_deviation","Coverage_start","Coverage_end","Coverage_continuity","Len_eccDNA","Chromosomep","Start_coordinatep","End_coordinatep","name","score","strand","signalValue","pValue","q_value","peak","Overlap")
    system2("mv",args=c(file,downstream))
    View(file)
    setwd(downstream)
}



