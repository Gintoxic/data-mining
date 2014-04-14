library(RCurl)
library(rjson)
library(XML)
library(plyr)
library(RODBC)

qFile<-"database/source_dest.sql"
myQuery<-paste(scan(qFile, what="", sep="\n"), collapse="\n")

myQuery<-"select distinct iata from of.airports"

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
res<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


iatalist<-as.character(res$iata)

res$country<-res$place_id<-res$importance<-res$importance<-res$type<-res$class<-res$display_name<-res$lon<-res$lat<-NA
for (i in 1:length(iatalist))
#for (i in 1:100)
{
  cur<-iatalist[i]
  base_url<-"http://nominatim.openstreetmap.org/search?q=<AIRPORT>+airport&format=json&polygon=0&addressdetails=1"
    
  requrl<-gsub("<AIRPORT>", cur, base_url)
  r <- getURL(requrl)
  f <- fromJSON(r)
  
  if (length(f)>0)
  {
    for (j in 1:length(f))
    {
      print(paste(i, "number of results", length(f)))
#       try(print(f[[j]]$class))
#       try(print(f[[j]]$type))
      
      if(f[[j]]$class=="aeroway" |  (f[[j]]$class=="amenity"&  f[[j]]$type=="airport"))
      {
        res$lat[i]<-f[[j]]$lat
        res$lon[i]<-f[[j]]$lon
        
        res$display_name[i]<-f[[j]]$display_name
        res$importance[i]<-f[[j]]$importance
        res$place_id[i]<-f[[j]]$place_id
        res$class[i]<-f[[j]]$class
        res$type[i]<-f[[j]]$type
        
        if(!is.null(f[[j]]$address$country)){
        res$country[i]<-try(f[[j]]$address$country)
        }
                
      }#if  
    }#for
   
  }#if>0
  if (!i%%100){
  saveFile<-paste("../data/temp/airports_rc_openstreet_01_", i, ".Rda",sep="")
  save("res", file=saveFile)
  }  
}
getwd()


res[1:20,]
summary(res[1:20,])


#http://nominatim.openstreetmap.org/search?viewbox=8.62,49.85,8.68,49.89&bounded=1&format=xml&polygon=0&addressdetails=1&q=[cafe][,pub]
#"http://www.overpass-api.de/api/xapi?node[bbox=8.62,49.85,8.68,49.89][amenity=fast_food|pub][@meta]"
#"http://api.openstreetmap.org/api/0.6/nodes?nodes=307367745,24924135"