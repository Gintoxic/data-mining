# R-Script: IP Ermitteln, TXT-Datei erstellen, TXT per FTP hochladen
library(RCurl)

# IP Ermitteln
ipurl<-"http://api.externalip.net/ip"
ip<-readLines(ipurl)

splitIpList<-strsplit(ip, "\\.")

splitIp<-unlist(splitIpList)

# TXT-Datei erstellen
sysTime<-Sys.time()

sysTimeStr<-format(sysTime, "%m%dT%HT%M%S")

conString<-""
for (i in 1:length(splitIp))
{
  randomLetter <-toupper( sample(letters, 1, replace = TRUE))
  conString<-paste(conString,splitIp[i],randomLetter, sep="")
    
}
conString<-paste(conString,sysTimeStr,sep="")

regexpr(".", ip)
setwd("D:/Work/data-mining/iptoftp")
source("../../credentials.R")

dataFolder<-"../../data/iptoftp/"
fileName<-paste(dataFolder,format(sysTime, "%y%m%d_%H%M%S"),".txt", sep="")
lastUpdate<-paste("Last Update:",format(sysTime, "%y-%m-%d %H:%M:%S"))

fileConn<-file(fileName)
writeLines(conString, fileConn)
close(fileConn)

# TXT per FTP hochladen
ftpUpload(fileName,
          "ftp://basicreports.de/server1.txt",
          userpwd = paste(credentials["ftp-info","user"],":",credentials["ftp-info","pass"], sep=""))

# temp. Datei löschen
#file.remove("ip_save.Rout")