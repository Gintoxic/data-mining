
library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
myQuery<-"select now()"
result<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



###### Write Airports into openflights db
str(airports)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production") 
sqlSave(channel, dat=airports, tablename="of.airports", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(airlines)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production")  
sqlSave(channel, dat=airlines, tablename="of.airlines", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(routes)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production")  
sqlSave(channel, dat=routes, tablename="of.routes", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



