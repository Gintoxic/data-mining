setwd("D:/Work/data/airports/")

load(file="airports.Rda")


table(airports$type)
choice<-airports[which(airports$type=='large_airport' & airports$iata_code!=""),] #& airports$continent=='EU' &

table(choice$continent)
table(choice$iso_country)
table(choice$iso_region)

library(gmt)

len<-dim(choice)[1]
num<-1:((len*len)/2)-len

myFrame<-as.data.frame(num)
colnames(myFrame)<-"num"
counter<-1

myFrame$DE<-myFrame$EU<-myFrame$dist<-myFrame$to<-myFrame$from<-NA
str(myFrame)


for (i in 1:len)
{
  print(paste(Sys.time(), "-", i,"von", len))
  la_from<-choice$latitude_deg[i]
  lo_from<-choice$longitude_deg[i]
  ia_from<-choice$iata_code[i]
  
  for (j in 1:len)
  { 
    
    if (i<j)
    {
      la_to<-choice$latitude_deg[j]
      lo_to<-choice$longitude_deg[j]
      ia_to<-choice$iata_code[j]
      if(choice$continent[i]=='EU' | choice$continent[j]=='EU')
      {myFrame$EU<-T
      }else{myFrame$EU<-F}
      
      if(choice$iso_country[i]=='DE' | choice$iso_country[j]=='DE')
      {myFrame$DE<-T
      }else{myFrame$DE<-F}
      
      
      myFrame$from[counter]<-ia_from
      myFrame$to[counter]<-ia_to
      myFrame$dist[counter]<-geodist(la_from,lo_from,la_to,lo_to,"km")
      myFrame$from_to[counter]<-paste(ia_from,"-", ia_to, sep="")
      counter<-counter+1
    }
  }  
}


###############################################
hist(myFrame$dist, breaks=100)

table(myFrame$DE)
table(myFrame$EU)

#myFrame[which(myFrame$DE),]
#table(myFrame$DE)
#save(myFrame, file="airports_dist_20131026.Rda")
