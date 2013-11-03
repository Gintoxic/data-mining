with r as
(
select r.airline,
r.airline_id, 
aps.iata as source_iata, 
aps.icao as source_icao,
aps.name as source_name,
aps.city as source_city, 
aps.country as source_country, 

apd.iata as dest_iata, 
apd.icao as dest_icao,
apd.name as dest_name,
apd.city as dest_city, 
apd.country as dest_country

from of.routes r 
left join of.airports aps
on r.source_airport_id=aps.airport_id
left join of.airports apd
on r.destination_airport_id=apd.airport_id

)
select distinct source_iata, dest_iata from r where source_country='Germany'
union
select distinct source_iata, dest_iata from r where dest_country='Germany'
