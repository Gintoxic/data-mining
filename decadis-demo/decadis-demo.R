# install.packages("gdata")
# install.packages("RCurl") 
# install.packages("rjson")
# install.packages("RDSTK")
# install.packages("SDMTools")
# install.packages("sp")
# install.packages("colorspace")
colorspace

library(gdata)
library(RCurl)
library(rjson)
library(RDSTK)
library(SDMTools)
library(sp)

pf<-"d:/Tools/strawberry/perl/bin/perl.exe"
installXLSXsupport(perl=pf)

getwd()
xlsFile<-"Adressen.xls"
adressen_imp<-read.xls(xls=xlsFile, perl=pf)
str(adressen_imp)

Name<-adressen_imp$Name
adressen<-as.data.frame(Name)
adressen$Name<-as.character(adressen$Name)
adressen$Adresse<-as.character(adressen_imp$Adresse)

adressen$Name
adressen[2,1]


cur="Pfuhlgasse,Koblenz,Germany"
cur="Zeisigweg, Bonn, Germany"
base_url<-"http://nominatim.openstreetmap.org/search?q=<TO_REPLACE>&format=json&polygon=0&addressdetails=1"

base_url<-"http://maps.googleapis.com/maps/api/geocode/json?address=<TO_REPLACE>&sensor=false"

#cur<-adressen$Adresse[2]
requrl<-gsub("<TO_REPLACE>", cur, base_url)
requrl<-gsub(" ", "", requrl)


r <- getURL(requrl)
f <- fromJSON(r)
fs<-f[[1]]

fs$lat
fs$lon
#street2coordinates("2543 Graystone Place, Simi Valley, CA 93065")


load('DEU_adm3.RData')
# [1] "50.743342"
# > fs$lon
# [1] "7.073286"
# #plot(gadm, col="grey75", xlim=c(7,8), ylim=c(50,51))

de<-gadm
plot(de)


len<-length(de)
num<-1:len


def<-as.data.frame(num)
def$Kreis<-def$Bundesland<-def$Val<-NA

i=1
for (i in 1:len)
{
def$Bundesland[i]<-de[i,]$NAME_1
def$Kreis[i]<-de[i,]$NAME_3
#coo<-de[i,]@polygons[[1]]@Polygons[[1]]@coords
}

def
table(def$Bundesland)

bundeslaender<-c("Rheinland-Pfalz", "Nordrhein-Westfalen", "Hessen")



# 
# points(x=7.073286, 50.743342, col="red", lwd=10   )
# 
# de
# text()
# ?points
# 
# 
# str(de1)
# 
# de1p<-de1@polygons
# 
# de1p1<-de1p[[1]]
# 
# str(de1p1)
# 
# de1p1p<-de1p1@Polygons
# 
# str(de1p1p)
# 
# de1p1p[[1]]@coords
# 
# 
# 
# 
# #########################
library(SDMTools)

#define the points and polygon
pnts = expand.grid(x=seq(1,6,0.1),y=seq(1,6,0.1))
polypnts = cbind(x=c(2,3,3.5,3.5,3,4,5,4,5,5,4,3,3,3,2,2,1,1,1,1,2),
                 y=c(1,2,2.5,2,2,1,2,3,4,5,4,5,4,3,3,4,5,4,3,2,2))

#plot the polygon and all points to be checked
plot(rbind(polypnts, pnts))
polygon(polypnts,col='#99999990')

#create check which points fall within the polygon
out = pnt.in.poly(pnts,polypnts)
head(out)

#identify points not in the polygon with an X
points(out[which(out$pip==0),1:2],pch='X')