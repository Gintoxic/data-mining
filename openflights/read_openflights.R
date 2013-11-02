#inputFileName<-"../../data/openflights/data/airports.dat"
inputFileName<-"../data/openflights/data/airports.dat"


airportsImport<-read.table(inputFileName, sep=",")
str(airportsImport)


airport_id<-airportsImport$V1
airports<-as.data.frame(airport_id)
str(airports)
str(airportsImport)

table(airportsImport$V2)
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
airports$dst<-airportsImport$V11

str(airports)


table(airports$country)

iata_de<-c("SXF","TXL","BRE","DRS","DUS","ERF","FRA","HAM","HAJ","CGN","LEJ","MUC","FMO","NUE","SCN","STR", "BER")

indDe<-which(airports$country=="Germany" & airports$iata %in% iata_de)

airportsd<-airports[indDe,]

table(airportsd$city)
table(airportsd$iata)
table(airportsd$icao)

table(airportsd$icao, airportsd$iata)

##### Airlines
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
table(airlines$country)

##################


inputFileName<-"../data/openflights/data/routes.dat"

routesImport<-read.table(inputFileName, sep=",")

airline<-as.character(routesImport$V1)  #   2-letter (IATA) or 3-letter (ICAO) code of the airline.
routes<-as.data.frame(airline)
routes$airline<-airline

str(routes)
    
routes$airline_id<-as.character(routesImport$V2)      #	Unique OpenFlights identifier for airline (see Airline).
routes$source_airport<-as.character(routesImport$V3) 	#3-letter (IATA) or 4-letter (ICAO) code of the source airport.
routes$source_airport_id<-as.character(routesImport$V4) 	#Unique OpenFlights identifier for source airport (see Airport)
routes$destination_airport<-as.character(routesImport$V5) 	#3-letter (IATA) or 4-letter (ICAO) code of the destination airport.
routes$destination_airport_id<-as.character(routesImport$V6) 	#Unique OpenFlights identifier for destination airport (see Airport)
routes$codeshare<-as.character(routesImport$V7) 	        #"Y" if this flight is a codeshare (that is, not operated by Airline, but another carrier), empty otherwise.
routes$stops<-routesImport$V8 	          #Number of stops on this flight ("0" for direct)
routes$equipment<-as.character(routesImport$V9) 	      #3-letter codes for plane type(s) generally used on this flight, separated by spaces

summary(routes)
str(routes)
bg_al<-sort(table(routes$airline), decreasing=T)[1:20]
mids<-barplot(bg_al)
text(mids, bg_al, names(bg_al))
table(routes$codeshare)
table(routes$stops)

table(routes$equipment)

sort(table(routes$source_airport))

str(airports)
str(routes)

routes$iata<-routes$source_airport

routes1<-merge(x=routes, y=airports, by=c("iata"))
str(routes1)




sort(table(routes1$country))

sort(table(routes1$iata))