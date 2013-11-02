library(RCurl)
library(rjson)
library(XML)
library(plyr)

teslurl<-"http://nominatim.openstreetmap.org/search?q=JFK+airport&format=json&polygon=0&addressdetails=1"

ATL PVG JFK BCN DEN AMS FRA LHR CDG LAX PEK ORD 

r <- getURL(teslurl)

j <- fromJSON(r)

length(j)

i=1
for (i in 1:length(j))
{
  print(i)
  print(j[[i]]$class=="aeroway")
}



#http://nominatim.openstreetmap.org/search?viewbox=8.62,49.85,8.68,49.89&bounded=1&format=xml&polygon=0&addressdetails=1&q=[cafe][,pub]
#"http://www.overpass-api.de/api/xapi?node[bbox=8.62,49.85,8.68,49.89][amenity=fast_food|pub][@meta]"
#"http://api.openstreetmap.org/api/0.6/nodes?nodes=307367745,24924135"

teslurl<-"http://nominatim.openstreetmap.org/search?q=cafe+hamburg+DE&format=json&polygon=0&addressdetails=1"
r <- getURL(teslurl)
j <- fromJSON(r)
length(j)