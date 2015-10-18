library(dplyr)
library(RCurl)
# Load package
library(networkD3)
source("quickdb.R")


query<-"
with prep as(
select origin_country as c from v_flights
union
select dest_country as c from v_flights
) 
select distinct c as name from prep 
where c in ('Germany','United States','United Kingdom') 
order by name
"
con<-connectPg()
countries<-dbGetQuery(conn = con, statement = query)
disconnectPg(con)

table(countries$name)

contries_plot<-countries
contries_plot$name<-as.factor(1:length(countries$name))
levels(contries_plot$name)<-countries$name
countries$num<-1:length(countries$name)

query<-"select origin_country as source_name, dest_country as target_name, count(*) as value  
from v_flights 
where origin_country in ('Germany','United States','United Kingdom') and dest_country in ('Germany','United States','United Kingdom')
group by origin_country, dest_country"
con<-connectPg()
flights<-dbGetQuery(conn = con, statement = query)
disconnectPg(con)

str(flights)


flights$source<-as.integer(match(x = flights$source_name, table = countries$name))
flights$target<-as.integer(match(x = flights$target_name, table = countries$name))

flights_plot<-flights[,c("source", "target", "value")]
flights_plot$value<-as.integer(flights_plot$value)



############
URL <- "https://raw.githubusercontent.com/christophergandrud/networkD3/master/JSONdata/energy.json"
Energy <- getURL(URL, ssl.verifypeer = FALSE)

# Convert to data frame
EndLinks <- JSONtoDF(jsonStr = Energy,
                     array = "links")
EngNodes <- JSONtoDF(jsonStr = Energy,
                     array = "nodes")
str(EngNodes)
str(EndLinks)
# Plot
str(contries_plot)
str(flights_plot)

sankeyNetwork(Links = flights_plot, Nodes = contries_plot,
              Source = "source", Target = "target",
              Value = "value", NodeID = "name",
              width = 700, fontSize = 12, nodeWidth = 30)%>%  saveNetwork(file = 'Flights.html')





flights_plot_red<-flights_plot[1:10,]

num<-unique(c(flights_plot_red$source,flights_plot_red$target))
countries$name[num]
contries_plot_red<-contries_plot[,]



str(MisLinks)
str(MisNodes)

str(contries_plot)
str(flights_plot)

contries_plot$group<-1:dim(countries)[1]

library(dplyr)
forceNetwork(Links = flights_plot, Nodes = contries_plot,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8) %>%  saveNetwork(file = 'Net2.html')

getwd()










# 
# flights_temp2.flight_id,
# flights_temp2.ident_op,
# flights_temp2.airline_icao_op,
# flights_temp2.airline_iata_op,
# flights_temp2.flightnumber_op,
# flights_temp2.code_shares,
# flights_temp2.ident_va,
# flights_temp2.airline_opva,
# flights_temp2.airline_icao,
# flights_temp2.airline_iata,
# flights_temp2.flightnumber,
# flights_temp2.origin_icao,
# flights_temp2.origin_iata,
# flights_temp2.origin_name,
# flights_temp2.origin_city,
# flights_temp2.dest_icao,
# flights_temp2.dest_iata,
# flights_temp2.dest_name,
# flights_temp2.dest_city,
# flights_temp2.dep_sched_local,
# flights_temp2.dep_tz,
# flights_temp2.dep_sched_utc,
# flights_temp2.arr_sched_local,
# flights_temp2.arr_tz,
# flights_temp2.arr_sched_utc,
# flights_temp2.dep_act_local,
# flights_temp2.dep_act_utc,
# flights_temp2.arr_act_local,
# flights_temp2.arr_act_utc,
# flights_temp2.registration,
# flights_temp2.distance_km_fa,
# flights_temp2.type_dist,
# flights_temp2.enroute,
# flights_temp2.cancelled,
# flights_temp2.distance_km_cal,
# flights_temp2.airline_len_vec,
# flights_temp2.airline_vec,
# flights_temp2.diftime_utc_raw,
# flights_temp2.diftime_locla_raw,
# flights_temp2.diftime_utc,
# flights_temp2.diftime_local,
# flights_temp2.timezone_dif_dep,
# flights_temp2.timezone_dif_arr,
# flights_temp2.origin_country,
# flights_temp2.dest_country
# 