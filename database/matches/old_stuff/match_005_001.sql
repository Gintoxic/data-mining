--select count(*) from cd_001_01 

with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('minute', dep_sched_local), origin_iata, dest_iata)
	airline_iata, flightnumber, 
	dep_sched_local,
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
	--date_trunc('minute',dep_sched_local) as dep_sched_local_min,
	date_trunc('hour',dep_sched_local) as dep_sched_local_hour
	
	from (select import_counter, origin_airport_iata as origin_iata, dest_airport_iata as dest_iata, dep_sched_local_time,to_timestamp(dep_sched_local_date||' '||dep_sched_local_time, 'DD.MM.YYYY HH24:MIN')::timestamp without time zone as dep_sched_local, flightnumber, airline_iata from cd_005_01) c
	where flightnumber  !~ '[^0-9]'

),
--select * from valid_rows

match as
(
	select vr.* ,f.dep_sched_local as matched_dep_sched_local, f.flight_id, f.cancelled, f.diftime_utc,


case when type_dist =1 then 'kurz'
when type_dist=2 then 'mittel'
when type_dist=3 then 'lang' end as dist
--f.dep_sched_local-vr.dep_sched_local as dif
	
	
	from valid_rows vr inner join distinct_flights f
	on vr.airline_iata=f.airline_iata
	and vr.flightnumber::numeric=f.flightnumber::numeric
	--vr.dep_sched_local_min=f.dep_sched_local_min
	and vr.dep_sched_local_hour=f.dep_sched_local_hour
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata
)
select * from match
order by import_counter;
--select cancelled, count(*), count(distinct flight_id), count(distinct import_counter) from match
--group by cancelled

