library(RODBC)

qFile<-"database/routes_source_dest.sql"
myQuery<-paste(scan(qFile, what="", sep="\n"), collapse="\n")

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "production")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
res<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)

source_ind<-which(res$source_country=="Germany")
dest_ind<-which(res$dest_country=="Germany")

d<-sort(table(res$dest_iata[dest_ind]), decreasing=T)[1:20]
mids<-barplot(d)
text(mids, d, 1:20, pos=1)


s<-sort(table(res$source_iata[source_ind]), decreasing=T)[1:20]
mids<-barplot(s)
text(mids, s, 1:20, pos=1)


