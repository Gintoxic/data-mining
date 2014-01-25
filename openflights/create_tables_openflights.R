
library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres")  #, pwd = "locknload"
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
channel<-odbcConnect("odbc_production", uid = "postgres") 
sqlSave(channel, dat=airports, tablename="airports", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(airlines)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres")  
sqlSave(channel, dat=airlines, tablename="airlines", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(routes)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres")  
sqlSave(channel, dat=routes, tablename="routes", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



