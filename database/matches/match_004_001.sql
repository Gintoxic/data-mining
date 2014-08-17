--select count(*) from cd_001_01 

with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('minute', dep_sched_local), origin_iata, dest_iata)
	airline_iata, flightnumber, 
	
	date_trunc('minute', dep_sched_local) as dep_sched_local_min,
	date_trunc('hour', dep_sched_local) as dep_sched_local_hour, 
	date_trunc('day', dep_sched_local) as dep_sched_local_date, 

	origin_iata, dest_iata,
	flight_id, cancelled, diftime_utc, type_dist from v_flights
),

valid_rows as
(
	select 
	c.import_counter,
	c.airline_iata,
	c.flightnumber,
	c.origin_iata, 
	dest_iata,
	dep_sched_local,
	date_trunc('minute',dep_sched_local) as dep_sched_local_min,
	date_trunc('hour',dep_sched_local) as dep_sched_local_hour
	
	from (select import_counter, origin as origin_iata, destinat as dest_iata, rdepdttim as dep_sched_local, fltno as flightnumber, airline as airline_iata from cd_004_01) c
	where flightnumber  !~ '[^0-9]'

),
--select * from valid_rows1

match as
(
	select vr.*, --f.flight_id, f.cancelled, f.diftime_utc, f.type_dist
	f.*
	from valid_rows vr inner join distinct_flights f
	on vr.airline_iata=f.airline_iata
	and vr.flightnumber::numeric=f.flightnumber::numeric
	and vr.dep_sched_local_min=f.dep_sched_local_min
	--and vr.dep_sched_local_date=f.dep_sched_local_date
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata
)
--select * from match;
select cancelled, count(*), count(distinct flight_id), count(distinct import_counter) from match
group by cancelled

