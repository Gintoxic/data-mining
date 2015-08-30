with p1 as
(
select  
substr(c.departure_time, 1,1) as first_num_dep, 
substr(c.arrival_time, 1,1) as first_num_arr,
c.departure_date||' '||c.departure_time,
c.*
from cd_009_01 c
), 
p2 as
(
select 
to_timestamp(p.departure_date||' '||p.departure_time,'DD.MM.YYYY HH:MI AM')::timestamp without time zone as dep_sched_local,
to_timestamp(p.arrival_date||' '||p.arrival_time,'DD.MM.YYYY HH:MI AM')::timestamp without time zone,
p.*
 from p1 p
 where first_num_dep!='0' and first_num_arr!='0'
 ),
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
	
	from 
	p2 c
	--where flightnumber  !~ '[^0-9]'

),
--select * from p2
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
	--and vr.flightnumber::numeric=f.flightnumber::numeric
	--vr.dep_sched_local_min=f.dep_sched_local_min
	and vr.flightnumber=f.airline_iata||f.flightnumber
	and vr.dep_sched_local_hour=f.dep_sched_local_hour
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata
)
--select * from match
--order by import_counter

select case when cancelled='Cancelled' then 'Cancelled' else 'Delayed' end as status, count(*), count(distinct flight_id), count(distinct import_counter) from match
group by cancelled

