getwd()

library(gdata)
pf<-"D:/Tools/strawberry/perl/bin/perl.exe"

installXLSXsupport(perl=pf)


xlsFile<-"D:/Work/data/flightaware/2013/FlightAware_European_delays_harschack.xls"
imp<-read.xls(xls=xlsFile, perl=pf)

str(imp)

id<-seq(from=2013000001, to=2013000000+45760)

fmt<-as.data.frame(id)
str(fmt)

fmt$ident<-as.character(imp$ident)

fmt$registration<- as.character(imp$registration)
fmt$code_shares<-as.character(imp$code_shares)
fmt$aircraft_type<-as.character(imp$aircraft_type  )
fmt$origin_icao<-as.character(imp$origin_icao  )
#fmt$origin_name<-as.character(imp$origin_name  )
#fmt$origin_city<-as.character(imp$origin_city )
fmt$destination_icao<-as.character(imp$destination_icao)
#fmt$destination_name<-as.character(imp$destination_name)
#fmt$destination_city<-as.character(imp$destination_city)
#fmt$direct_distance<-as.character(imp$direct_distance)
#fmt$origin_gate<-as.character(imp$origin_gate)
#fmt$destination_gate<-as.character(imp$destination_gate)
fmt$scheduled_departure_time<-(as.character(imp$scheduled_departure_time))
fmt$scheduled_departure_time_utc<-(as.character(imp$scheduled_departure_time_utc))
fmt$scheduled_arrival_time<-(as.character(imp$scheduled_arrival_time))
fmt$scheduled_arrival_time_utc<-(as.character(imp$scheduled_arrival_time_utc))

fmt$actual_departure_time<-(as.character(imp$actual_departure_time))
fmt$actual_departure_time_utc<-(as.character(imp$actual_departure_time_utc))
fmt$actual_arrival_time<-(as.character(imp$actual_arrival_time))
fmt$actual_arrival_time_utc<-(as.character(imp$actual_arrival_time_utc))

fmt$enroute<-as.character(imp$enroute)
fmt$cancelled<-as.character(imp$cancelled)

str(fmt)

library(RODBC)

###### Write Airports into openflights db

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres") 
sqlSave(channel, dat=fmt, tablename="fa_2013_char", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)
