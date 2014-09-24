library(RCurl)
library(rjson)

currencySource="RUB"


cf<-getRateTo_EUR(currencySource)


#############################################################
#############################################################
#############################################################
#Sys.setenv(JAVA_HOME='D:\\Tools\\Java\\jre8') # for 64-bit version

library(rJava)
library( RJDBC ) 
postgres <- JDBC( "org.postgresql.Driver", "postgresql-9.3-1101.jdbc3.jar")


startzeit<-Sys.time()
channel<-connectStaging()  #, pwd = "locknload"
myQuery<-paste("select max(date) from conv_rates where currency='", currencySource,"'",sep="")
res<-dbGetQuery(channel, myQuery,... =  )
disconnectStaging(channel)

res$max<
  
cf$date

?dbGetQuery






startzeit<-Sys.time()
channel<-connectStaging()  #, pwd = "locknload"
#myQuery<-"select now();"
#res<-dbSendQuery(channel, myQuery)

dbWriteTable( channel, "conv_rates", fr )

disconnectStaging(channel)

print(res)
laufzeit<-Sys.time()-startzeit
print(laufzeit)



