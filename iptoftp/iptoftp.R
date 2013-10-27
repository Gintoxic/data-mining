## R-Script: IP Ermitteln, TXT-Datei erstellen, TXT per FTP hochladen

source("../../credentials.R")

library(RCurl)

# IP Ermitteln
ipurl<-"http://api.externalip.net/ip"

ip<-readLines(ipurl)

# TXT-Datei erstellen
sysTime<-Sys.time()
setwd("D:/Work/data-mining/iptoftp")

dataFolder<-"../../data/iptoftp/"

fileName<-paste(dataFolder,format(sysTime, "%y%m%d_%H%M%S"),".txt", sep="")

lastUpdate<-paste("Last Update:",format(sysTime, "%y-%m-%d %H:%M:%S"))

fileConn<-file(fileName)
writeLines(c(ip,lastUpdate), fileConn)
close(fileConn)

# TXT per FTP hochladen
ftpUpload(fileName,
          "ftp://harschack.de/server1.txt",
          userpwd = paste(credentials["ftp-info","user"],":",credentials["ftp-info","pass"], sep=""))

# temp. Datei löschen
#file.remove("ip_save.Rout")