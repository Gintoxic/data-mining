setwd("D:/Work/data/airports/")
#source("../../credentials.R")

airports_raw<-read.table("airports.csv", sep=",",encoding="UTF-8")

airports<-airports_raw[2:45379,]

names(airports)<-
  c('id','ident','type','name','latitude_deg','longitude_deg','elevation_ft','continent','iso_country','iso_region','municipality','scheduled_service','gps_code','iata_code','local_code','home_link','wikipedia_link','keywords')

for (i in 1:18)
{
  if (i %in% c(5,6)){
    airports[,i]<-as.numeric(as.character(airports[,i]))  
  }else{
    airports[,i]<-as.character(airports[,i])
  }
}
airports$continent[which(is.na(airports$continent))]<-"NA"
airports$iso_country[which(is.na(airports$iso_country))]<-"NA"

save("airports", file="airports.Rda")