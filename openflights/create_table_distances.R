load(file="distBayer.Rdata")
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
channel<-odbcConnect("staging", uid = "staging") 
sqlSave(channel, dat=myFrameAll, tablename="staging.of_distances", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


