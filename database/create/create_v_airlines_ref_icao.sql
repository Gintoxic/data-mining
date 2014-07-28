create view v_airlines_ref_icao as
with airlines1 as
(
select distinct on (iata, icao) * from of_airlines
where iata not in ('', '\N') and icao not in ('', '\N')
), 


airlines2 as
(
select icao, max(iata) as iata, count(*) as len_vec, string_agg(iata, ',') as iata_vec, string_agg(name, ',') as airline_vec from airlines1
--rder by number_icao, icao desc
group by icao
)
select * from airlines2
--select iata,icao, num_iata, count(*) over (partition by icao) as num_icao,  icao_vec, airline_vec from airlines3 a
order by len_vec desc