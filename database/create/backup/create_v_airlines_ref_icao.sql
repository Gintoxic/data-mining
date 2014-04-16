create view staging.v_airports_ref_icao as
with airports1 as
(
select distinct on (iata, icao) * from staging.of_airports
where iata not in ('', '\N') and icao not in ('', '\N')
), 
airports2 as
(select a.* ,
count(*) over (partition by icao) as count_icao, 
row_number() over (partition by icao order by airport_id) as row_icao
from airports1 a
), 
airports3 as
(
select icao, max(iata) as iata, string_agg(iata, ',') as iata_vec, max(count_icao) as num_icao, string_agg(name, ',') as airport_vec from airports2
group by icao
order by max(count_icao) desc
)
select icao, iata, num_icao, count(*) over (partition by iata) as num_iata,  iata_vec, airport_vec from airports3 a
order by num_icao desc, icao