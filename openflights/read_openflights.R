###AIRPORTS

inputFileName<-"../data/openflights/data/airports.dat"
airportsImport<-read.table(inputFileName, sep=",")
#str(airportsImport)

airport_id<-(airportsImport$V1)
airports<-as.data.frame(airport_id)
airports$airport_id<-airport_id

airports$name<-as.character(airportsImport$V2)

airports$city<-as.character(airportsImport$V3)
airports$country<-as.character(airportsImport$V4)
airports$iata<-as.character(airportsImport$V5)
airports$icao<-as.character(airportsImport$V6)
class(airportsImport$V7)

airports$latitutde<-airportsImport$V7
airports$longitude<-airportsImport$V8
airports$altitude_feet<-airportsImport$V9
airports$timezone<-airportsImport$V10
airports$dst<-as.character(airportsImport$V11)

str(airports)

##### AIRLINES
inputFileName<-"../data/openflights/data/airlines.dat"
airlinesImport<-read.table(inputFileName, sep=",")
str(airlinesImport)

airline_id<-airlinesImport$V1
airlines<-as.data.frame(airline_id)

airlines$name<-as.character(airlinesImport$V2)
airlines$alias<-as.character(airlinesImport$V3) 	
airlines$iata<-as.character(airlinesImport$V4) # 	2-letter IATA code, if available.
airlines$icao<-as.character(airlinesImport$V5) #	3-letter ICAO code, if available.
airlines$callsign<-as.character(airlinesImport$V6) 	#Airline callsign.
airlines$country<-as.character(airlinesImport$V7)

str(airlines)


####### ROUTES
inputFileName<-"../data/openflights/data/routes.dat"
routesImport<-read.table(inputFileName, sep=",")


str(routesImport)

routesNames<-c("airline",
"airline_id",
"source_airport",
"source_airport_id",
"destination_airport",
"destination_airport_id",
"codeshare",
"stops",
"equipment")


X1<-as.character(routesImport$V1)  #   2-letter (IATA) or 3-letter (ICAO) code of the airline.
routesTrans<-as.data.frame(X1)

routesTrans$X9<-routesTrans$X8<-routesTrans$X7<-routesTrans$X6<-routesTrans$X5<-routesTrans$X4<-routesTrans$X3<-routesTrans$X2<-routesTrans$X1<-NA

for (i  in 1:9)
{
  routesTrans[,paste("X", i, sep="")]<-as.character(routesImport[,paste("V", i, sep="")])
}
#

str(routesTrans)

routesTrans$X2[which(routesTrans$X2=="\\N")]<-(-1)
routesTrans$X4[which(routesTrans$X4=="\\N")]<-(-1)
routesTrans$X6[which(routesTrans$X6=="\\N")]<-(-1)



#colnames(routesTrans)<-routesNames
airline<-routesTrans$X1
routes<-as.data.frame(airline)
routes$airline<-airline

routes$airline_id<-as.integer(routesTrans$X2)      #	Unique OpenFlights identifier for airline (see Airline).
routes$source_airport<-routesTrans$X3 	            #3-letter (IATA) or 4-letter (ICAO) code of the source airport.
routes$source_airport_id<-as.integer(routesTrans$X4) 	#Unique OpenFlights identifier for source airport (see Airport)
routes$destination_airport<-(routesTrans$X5) 	#3-letter (IATA) or 4-letter (ICAO) code of the destination airport.
routes$destination_airport_id<-as.integer(routesTrans$X6) 	#Unique OpenFlights identifier for destination airport (see Airport)
routes$codeshare<-(routesTrans$X7) 	        #"Y" if this flight is a codeshare (that is, not operated by Airline, but another carrier), empty otherwise.
routes$stops<-routesTrans$X8 	          #Number of stops on this flight ("0" for direct)
routes$equipment<-(routesTrans$X9) 	      #3-letter codes for plane type(s) generally used on this flight, separated by spaces

# summary(routes)
# str(routes)
# bg_al<-sort(table(routes$airline), decreasing=T)[1:20]
# mids<-barplot(bg_al)
# text(mids, bg_al, names(bg_al))
# 
# table(routes$equipment)
# sort(table(routes$source_airport))
