getwd()

library(gdata)
pf<-"D:/Tools/strawberry/perl/bin/perl.exe"

installXLSXsupport(perl=pf)

xlsFile<-"D:/Work/data/testdaten1/Testdatensatz_Forderungsmanagement_single_simplified.xls"
imp<-read.xls(xls=xlsFile, perl=pf)




str(imp)


eurocountries<-c("Austria","Belgium",  "Bulgaria","Croatia",  "Cyprus","Czech Republic","Denmark",  "Estonia","Finland",  "France","Germany",  "Greece","Hungary",  "Ireland","Italy","Latvia","Lithuania","Luxembourg",  "Malta",  "Netherlands",  "Poland",  "Portugal",  "Romania",  "Slovakia",  "Slovenia",  "Spain",  "Sweden",  "United Kingdom")

ind_orig<-which(imp$origin_country %in%  eurocountries)
ind_dest<-which(imp$destination_country %in%  eurocountries)

ind_pos<-which(imp$reisedauer >0)

imp$pos<-0
imp$pos[ind_pos]<-1


imp$euro<-0
imp$orig_euro<-0
imp$dest_euro<-0

imp$orig_euro[ind_orig]<-1
imp$euro[ind_orig]<-1

imp$dest_euro[ind_dest]<-1
imp$euro[ind_dest]<-1

table(imp$origin_country,imp$orig_euro )
table(imp$destination_country,imp$dest_euro )


table(imp$pos)
table(imp$)
table(imp$pos, imp$euro)
prop.table(table(imp$pos, imp$euro))

str(imp)


kundenname<-as.character(imp$kundenname)
fmt<-as.data.frame(kundenname)
fmt$kundenname<-as.character(fmt$kundenname)
fmt$code_transportunternehmen<-as.character(imp$code_transportunternehmen)
fmt$flugnummer<-(imp$flugnummer)
fmt$abreisedatum<-as.character(imp$abreisedatum)
fmt$zeit_abreise<-as.character(imp$zeit_abreise)
fmt$ankunftsdatum<-as.character(imp$ankunftsdatum)
fmt$ankunftszeit<-as.character(imp$ankunftszeit)


#####################################################################################

code_transportunternehmen<-as.character(imp$code_transportunternehmen)
refmt<-as.data.frame(code_transportunternehmen)

refmt$code_transportunternehmen<-as.character(refmt$code_transportunternehmen)
refmt$flugnummer<-imp$flugnummer

refmt$abreisedatum<-as.POSIXlt(fmt$abreisedatum, format="%d.%m.%Y")
refmt$ankunftsdatum<-as.POSIXlt(fmt$ankunftsdatum, format="%d.%m.%Y")

refmt$origin_airport_code<-as.character(imp$origin_airport_code)
refmt$destination_airport_code<-as.character(imp$destination_airport_code)

refmt$reisedauer<-imp$reisedauer
temp1<-gsub("a","", as.character(imp$fares_ex_tax))

refmt$fares_ex_tax<-as.numeric(temp1)

refmt$distance<-as.numeric(imp$distance)
str(refmt)

#######################################################################################
library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres") 
sqlSave(channel, dat=refmt, tablename="c_bayer_test1", rownames=FALSE, fast=TRUE)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)






