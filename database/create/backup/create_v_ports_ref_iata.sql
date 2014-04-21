create view staging.v_airports_ref_iata as
with airports1 as
(
select distinct on (iata, icao) * from staging.of_airports
where iata not in ('', '\N') and icao not in ('', '\N')
), 
airports2 as
(select a.* ,
count(*) over (partition by iata) as count_iata, 
row_number() over (partition by iata order by airport_id) as row_iata
from airports1 a
),
--select * from airports2 


airports3 as
(
select iata, max(icao) as icao, string_agg(icao, ',') as icao_vec, max(count_iata) as num_iata, string_agg(name, ',') as airport_vec from airports2
--rder by number_icao, icao desc
group by iata
order by max(count_iata) desc
)
--select * from airports3
select iata,icao, num_iata, count(*) over (partition by icao) as num_icao,  icao_vec, airport_vec from airports3 a
order by num_iata desc