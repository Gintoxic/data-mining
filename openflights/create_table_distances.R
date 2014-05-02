
getwd()
load(file="../data/openflights_calc/dist_flights_2013.Rdata")
myFrame[93740:93744,]
myFrameTemp[93740:93744,]

myFrameTemp<-myFrame

myFrameTemp$from<-myFrame$to
myFrameTemp$to<-myFrame$from
myFrameTemp$from_to<-paste(myFrameTemp$from, "-", myFrameTemp$to, sep="")

myFrameAll<-merge(x=myFrame,y=myFrameTemp, all=T)
myFrameAll$num<-1:dim(myFrameAll)[1]


names(myFrameAll)<-c("id","origin","dest", "distance", "origin_dest" )
myFrameAll[1:10,]

startzeit<-Sys.time()
channel<-connectStaging() 
dbWriteTable( channel, "staging.of_distances", myFrameAll )
disconnectStaging(channel)

#sqlSave(channel, dat=myFrameAll, tablename="staging.of_distances", rownames=FALSE, fast=TRUE)

laufzeit<-Sys.time()-startzeit
print(laufzeit)


