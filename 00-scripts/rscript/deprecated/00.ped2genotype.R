#!/usr/bin/Rscript
##!/usr/local/bioinfo/src/R/R-3.2.2/bin/Rscript

#Script by QR - 15-09-16
#Miniscript to reshape a classical ped file into a genotypic matrix (usefull for several programms)
#Input files: 1) ped file 
#Output: genotypic matrix (AC, TG, AA, CC, etc. with inds in row, mk in cols)

argv <- commandArgs(TRUE) #Ped file

dat<-argv[1] 

dat2<-as.matrix(read.table(dat,h=F)) 
dat3<-dat2[,-c(1:6)] 

dat3[dat3 == "0"] <- NA

start <- seq(1, by = 2, length = ncol(dat3) / 2)
sdf <- sapply(start,function(i, dat3) paste(as.character(dat3[,i]),as.character(dat3[,i+1]), sep="/") ,dat3 = dat3) 
sdf[sdf=="N/A"] <- ""
sdf[sdf=="C/C"] <- "C"
sdf[sdf=="T/T"] <- "T"
sdf[sdf=="A/A"] <- "A"
sdf[sdf=="G/G"] <- "G"

#if("[-]" %in% dat2[,2] ==TRUE) {gsub("[-]","_",dat2[,2])}
#substring(dat2[1,2],4,4)
dat2[,2] <- gsub("[-]","_",dat2[,2]) #rajouter test conditionel

write.table(t(cbind(dat2[,c(2)],as.data.frame(sdf))),"01-input/genotypic_matrix.txt",quote=F,col.names=F,row.names=F, sep="\t")
