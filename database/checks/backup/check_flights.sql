select  iata, icao, count(*), min(city), max(city)
from staging.of_airports
group by iata,icao
order by count(*) desc