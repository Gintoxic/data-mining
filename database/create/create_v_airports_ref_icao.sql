create view staging.v_airports_ref_icao as
with airports1 as
(
select distinct on (iata, icao) * from staging.of_airports
where iata not in ('', '\N') and icao not in ('', '\N')
), 


airports2 as
(
select icao, max(iata) as iata, count(*) as len_vec, string_agg(iata, ',') as iata_vec, string_agg(name, ',') as airline_vec from airports1
--rder by number_icao, icao desc
group by icao
)
select * from airports2
--select iata,icao, num_iata, count(*) over (partition by icao) as num_icao,  icao_vec, airline_vec from airports3 a
order by len_vec desc