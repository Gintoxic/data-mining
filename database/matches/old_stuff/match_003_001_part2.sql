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

valid_rows1 as
(
	select 
	c.import_counter,
	c.airline_iata_op,
	c.flightnumber_op,
	c.origin_iata, 
	dest_iata,
	dep_sched_local_date as dep_sched_local_date_orig,
	to_date(c.dep_sched_local_date_rep, 'DD. Mon YY') as dep_sched_local_date ,

	to_timestamp(c.dep_sched_local_date ||' '||c.dep_sched_local_time, 'DD.MM.YYYY HH24:MI')::TIMESTAMP WITHOUT TIME ZONE as dep_sched_local_timestamp
	
	--dep_sched_local_date
	from (select *, 
		replace(replace(replace(replace(dep_sched_local_date, 'Mrz', 'Mar'),'Mai', 'May'), 'Okt', 'Oct'), 'Dez', 'Dec') as dep_sched_local_date_rep
		from cd_003_01 c where dep_sched_local_date  ~ '[A-Z]') c
	where flightnumber_op  !~ '[^0-9]'

),
valid_rows2 as
(select v.*, 
date_trunc('hour', dep_sched_local_timestamp) as dep_sched_local_hour ,
date_trunc('minute', dep_sched_local_timestamp) as dep_sched_local_min
from valid_rows1 v),

--select * from valid_rows
--limit 1000;


match as
(
	select vr.*, --f.flight_id, f.cancelled, f.diftime_utc, f.type_dist
	f.*
	from valid_rows2 vr inner join distinct_flights f
	on vr.airline_iata_op=f.airline_iata
	--and vr.flightnumber_op::numeric=f.flightnumber::numeric
	and vr.dep_sched_local_min=f.dep_sched_local_min
	--and vr.dep_sched_local_date=f.dep_sched_local_date
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata
)
--select * from match;
select cancelled, count(*), count(distinct flight_id), count(distinct import_counter) from match
group by cancelled

