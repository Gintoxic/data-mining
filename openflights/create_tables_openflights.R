
library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("staging", uid = "staging")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
myQuery<-"select now()"
result<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



###### Write Airports into openflights db
str(airports)
Encoding(airports$city)

startzeit<-Sys.time()
channel<-odbcConnect("staging", uid = "staging") 
sqlSave(channel, dat=airports, tablename="staging.of_airports", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(airlines)

startzeit<-Sys.time()
channel<-odbcConnect("staging", uid = "staging") 
sqlSave(channel, dat=airlines, tablename="staging.of_airlines", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(routes)

startzeit<-Sys.time()
channel<-odbcConnect("staging", uid = "staging") 
sqlSave(channel, dat=routes, tablename="staging.of_routes", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



