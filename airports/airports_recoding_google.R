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

res$country_code<-res$country<-res$display_name<-res$lon<-res$lat<-NA
#for (i in 1:length(iatalist))
for (i in 1001:2200)
{
  cur<-iatalist[i]
  #base_url<-"http://nominatim.openstreetmap.org/search?q=<AIRPORT>+airport&format=json&polygon=0&addressdetails=1"
  base_url<-"http://maps.googleapis.com/maps/api/geocode/json?address=<AIRPORT>%20airport&sensor=false"
  
  requrl<-gsub("<AIRPORT>", cur, base_url)
  r <- getURL(requrl)
  f <- fromJSON(r)
  
  if (length(f$results)>0)
  {
  
  if("airport" %in% f$results[[1]]$types )
  {  
      print(paste(i))
      #       try(print(f[[j]]$class))
      #       try(print(f[[j]]$type))
    
   
          res$lat[i]<-f$results[[1]]$geometry$location$lat
          res$lon[i]<-f$results[[1]]$geometry$location$lng
          res$display_name[i]<-f$results[[1]]$formatted_address
          
        ac<-f$results[[1]]$address_components
        
        for (j in 1:length(ac))
        {
          if("country" %in% ac[[j]]$types)
          {
          res$country[i]<-ac[[j]]$long_name
          res$country_code[i]<-ac[[j]]$short_name
          }
        }
          
      } #if
        
  } #if
  
  if (!i%%100){
    saveFile<-paste("../data/temp/airports_rc_google_01_", i, ".Rda",sep="")
    save("res", file=saveFile)
  }  
}


res[1980:2000,]
summary(res[1:20,])


#http://nominatim.openstreetmap.org/search?viewbox=8.62,49.85,8.68,49.89&bounded=1&format=xml&polygon=0&addressdetails=1&q=[cafe][,pub]
#"http://www.overpass-api.de/api/xapi?node[bbox=8.62,49.85,8.68,49.89][amenity=fast_food|pub][@meta]"
#"http://api.openstreetmap.org/api/0.6/nodes?nodes=307367745,24924135"


#
