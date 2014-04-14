library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("flightrefund", uid = "flightrefund")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
myQuery<-"select icao, longitude, latitude from v_airports_iaic a inner join 
(select distinct origin_icao from v_flights) f1
on a.icao=f1.origin_icao
inner join
(select distinct dest_icao from v_flights) f2
on a.icao=f2.dest_icao"

result<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


choice<-result
choice$icao=as.character(choice$icao)
str(choice)


library(gmt)

len<-dim(choice)[1]
num<-1:(((len*len)/2)-len)

min(num)
max(num)

myFrame<-as.data.frame(num)
colnames(myFrame)<-"num"
counter<-1


myFrame$dist<-myFrame$to<-myFrame$from<-NA
str(myFrame)


for (i in 1:len)
{
  print(paste(Sys.time(), "-", i,"von", len))
  la_from<-choice$latitude[i]
  lo_from<-choice$longitude[i]
  ia_from<-choice$icao[i]
  
  for (j in 1:len)
  {     
    if (i<j)
    {
      if (!j%%100)
      { print(paste(j,"von", len))  }
      la_to<-choice$latitude[j]
      lo_to<-choice$longitude[j]
      ia_to<-choice$icao[j]
           
      myFrame$from[counter]<-ia_from
      myFrame$to[counter]<-ia_to
      myFrame$dist[counter]<-geodist(la_from,lo_from,la_to,lo_to,"km")
      myFrame$from_to[counter]<-paste(ia_from,"-", ia_to, sep="")
      counter<-counter+1
    }
  }  
}

myFrame[1:10,]
save("myFrame", file="distBayer.Rdata")
