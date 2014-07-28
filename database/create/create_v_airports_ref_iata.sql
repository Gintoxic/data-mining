create view v_airports_ref_iata as
with airports1 as
(
select distinct on (iata, icao) * from of_airports
where iata not in ('', '\N') and icao not in ('', '\N')
), 


airports2 as
(
select iata, max(icao) as icao, count(*) as len_vec, string_agg(icao, ',') as icao_vec, string_agg(name, ',') as airline_vec from airports1
--rder by number_icao, icao desc
group by iata
)
select * from airports2
--select iata,icao, num_iata, count(*) over (partition by icao) as num_icao,  icao_vec, airline_vec from airports3 a
