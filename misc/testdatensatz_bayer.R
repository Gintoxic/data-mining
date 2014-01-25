library(gdata)
pf<-"D:/Tools/strawberry/perl/bin/perl.exe"

installXLSXsupport(perl=pf)


xlsFile<-"D:/Work/data/testdaten1/Testdatensatz_Forderungsmanagement_single.xls"
test<-read.xls(xls=xlsFile, perl=pf)

r<-dim(test)[1]
c<-dim(test)[2]
na<-names(test)


str(test)

for (i in 1:c)
{
  test[,i]<-as.character(test[,i])
}



  
  ori<-test$Segment.Origin.Airport.Code
  des<-test$Segment.Destination.Airport.Code
  orides<-c(ori,des)
  uorides<-unique(orides)

a<-paste(uorides,",")
cat(a)
a


library(RODBC)

startzeit<-Sys.time()
channel<-odbcConnect("odbc_production", uid = "postgres")  #, pwd = "locknload"
#sqlSave(channel, dat=airportFrame, tablename="AIRPORTS", rownames=FALSE, fast=TRUE)
#myQuery<-"select now()"
myQuery<-"select iata, count(*) as num_iata, max(name) as name, max(city) as city, max(country) as country, max(icao) as icao from airports
where iata is not null and iata!=''
group by iata
order by iata"

result<-sqlQuery(channel, myQuery)
odbcClose(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)

str(result)



fuorides<-as.data.frame(uorides)
str(fuorides)
fuorides$iata<-as.character(fuorides$uorides)

airportmatch<-merge(x=fuorides, y=result, by="iata", all.x=T)

str(airportmatch)

airportmatch$icao<-as.character(airportmatch$icao)
airportmatch$country<-as.character(airportmatch$country)

table(airportmatch$icao)
tab<-table(airportmatch$country)


countries<-as.data.frame(tab)

country<-c ("Austria",
        "Belgium",
        "Bulgaria",
        "Croatia",
        "Cyprus",
        "Czech Republic",
        "Denmark",
        "Estonia",
        "Finland",
        "France",
        "Germany",
        "Greece",
        "Hungary",
        "Ireland",
        "Italy",
        "Latvia",
        "Lithuania",
        "Luxembourg",
        "Malta",
        "Netherlands",
        "Poland",
        "Portugal",
        "Romania",
        "Slovakia",
        "Slovenia",
        "Spain",
        "Sweden",
        "United Kingdom")

eu<-as.data.frame(country)

str(eu)
eu$country<-as.character(eu$country)
eu$eu<-1


airportmatch2<-merge(x=airportmatch, y=eu, by="country", all.x=T)

euind<-which(airportmatch2$eu==1)

airportmatchexp<-airportmatch2[euind, ]

getwd()
write.table(airportmatchexp, file="../data/testdaten1/testdatensatz_eu_airports.csv",sep=";")

