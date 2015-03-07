--select * from cd_012_01 

with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('day', dep_sched_local), origin_iata, dest_iata)
	airline_opva,
	airline_iata, 
	airline_icao,
	flightnumber, 
	dep_sched_local,
	date_trunc('minute', dep_sched_local) as dep_sched_local_min,
	date_trunc('hour', dep_sched_local) as dep_sched_local_hour, 
	date_trunc('day', dep_sched_local) as dep_sched_local_date, 
	dep_act_local,
	arr_act_local,
	arr_sched_local,
origin_city,
dep_tz,
dest_name,
dest_city,

arr_tz,
	origin_iata, dest_iata,
	flight_id, cancelled, diftime_utc, type_dist from v_flights
),
prep1 as
(
select * from  cd_012_01
where dep_sched_local_date != '[no data]' and dep_sched_local_time is not null
),

prep2 as
(select import_counter, origin_iata, dest_iata, airline_iata_op as airline_iata, flightnumber_op as flightnumber, 
to_timestamp(dep_sched_local_date || ' ' || dep_sched_local_time,'DD.MM.YYYY HH24:MI')::timestamp without time zone as dep_sched_local 
from prep1
),
--select * from prep2

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
	
	from  prep2 c
	where flightnumber  !~ '[^0-9]'

),
--select * from valid_rows

match as
(
	select vr.*, f.flight_id, f.cancelled, f.diftime_utc,f.arr_act_local,f.origin_city,f.dest_city,dep_tz, arr_tz, f.dep_act_local,f.arr_sched_local,f.dest_name,f.airline_icao,


case when type_dist =1 then 'kurz'
when type_dist=2 then 'mittel'
when type_dist=3 then 'lang' end as dist
--f.dep_sched_local-vr.dep_sched_local as dif
	
	
	from valid_rows vr inner join distinct_flights f
	on vr.airline_iata=f.airline_iata
	and vr.flightnumber::numeric=f.flightnumber::numeric
	and vr.dep_sched_local_min=f.dep_sched_local_min
	--and vr.dep_sched_local_hour=f.dep_sched_local_hour
	--and vr.dep_sched_local=f.dep_sched_local_date
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata
)
select import_counter, airline_iata, airline_icao, flightnumber, origin_iata, origin_city, dest_iata, coalesce(dest_city, dest_name) as dest_city,
to_char(dep_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as dep_sched_local, 
to_char(dep_act_local, 'DD.MM.YYYY HH24:MI:SS')  as dep_act_local, 
coalesce(v1.tz_de, dep_tz) as dep_tz,

to_char(arr_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as arr_sched_local, 
to_char(arr_act_local, 'DD.MM.YYYY HH24:MI:SS')  as arr_act_local, 
coalesce(v2.tz_de, arr_tz) as dep_tz,
 diftime_utc, cancelled, dist from 

  match m 
  left join v_tzlookup v1 on m.dep_tz=v1.tz
  left join v_tzlookup v2 on m.arr_tz=v2.tz


order by import_counter



--select  cancelled as status, airline_opva, count(*), count(distinct flight_id), count(distinct import_counter), sum(airline_opva) from match
--group by cancelled, airline_opva

