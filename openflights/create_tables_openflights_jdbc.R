Sys.setenv(JAVA_HOME='D:\\Tools\\Java\\jre8') # for 64-bit version
#Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre7\\bin') # for 32-bit version
library(rJava)



library(rJava)
library( RJDBC ) 
postgres <- JDBC( "org.postgresql.Driver", "postgresql-9.3-1101.jdbc3.jar")

connectStaging=function()
{
con <- dbConnect(postgres, "jdbc:postgresql://localhost:5432/flightrefund", user = "postgres", password = "postgres" )
return(con)
}

disconnectStaging=function(con)
{
  dbDisconnect(con)
}





startzeit<-Sys.time()
#channel<-odbcConnect("staging", uid = "staging")  #, pwd = "locknload"
channel<-connectStaging()  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
myQuery<-"select now();"
res<-dbSendQuery(channel, myQuery)
disconnectStaging(channel)

print(res)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



###### Write Airports into openflights db
str(airports)
Encoding(airports$city)




startzeit<-Sys.time()
#channel<-odbcConnect("staging", uid = "staging") 
#sqlSave(channel, dat=airports, tablename="staging.of_airports", rownames=FALSE, fast=TRUE)

channel<-connectStaging()  #, pwd = "locknload"
dbWriteTable( channel, "of_airports", airports )
disconnectStaging(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(airlines)

startzeit<-Sys.time()

channel<-connectStaging() 
dbWriteTable( channel, "of_airlines", airlines )
disconnectStaging(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)


###### Write Airlines into openflights db
str(routes)

startzeit<-Sys.time()

#sqlSave(channel, dat=routes, tablename="staging.of_routes", rownames=FALSE, fast=TRUE)
channel<-connectStaging() 
dbWriteTable( channel, "of_routes", routes )
disconnectStaging(channel)



laufzeit<-Sys.time()-startzeit
print(laufzeit)



