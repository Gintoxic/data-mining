create view v_airlines_ref_iata as
with airlines1 as
(
select distinct on (iata, icao) * from of_airlines
where iata not in ('', '\N') and icao not in ('', '\N')
), 


airlines2 as
(
select iata, max(icao) as icao, count(*) as len_vec, string_agg(icao, ',') as icao_vec, string_agg(name, ',') as airline_vec from airlines1
--rder by number_icao, icao desc
group by iata
)
select * from airlines2
--select iata,icao, num_iata, count(*) over (partition by icao) as num_icao,  icao_vec, airline_vec from airlines3 a
