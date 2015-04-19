with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('minute', dep_sched_local), origin_iata, dest_iata)
	airline_iata,airline_iata_op, flightnumber, 
	dep_sched_local,
	airline_opva,
	date_trunc('minute', dep_sched_local) as dep_sched_local_min,
	date_trunc('hour', dep_sched_local) as dep_sched_local_hour, 
	date_trunc('day', dep_sched_local) as dep_sched_local_date, 
	origin_iata, dest_iata,
	flight_id, cancelled, diftime_utc, type_dist from v_flights
)
--select * from distinct_flights
,
prep1 as
(
	select *
	from  cd_920_01
)
--select * from prep1
,
prep2 as
(
	select import_counter, substr(directional_pair,1,3) as origin_iata, substr(directional_pair,5,3) as dest_iata
	, airline_iata
	, flightnumber,
	--to_timestamp(substr(ticket_departure_date,1,10)||' '||coupon_level_departure_time,'DD.MM.YYYY HH24:MI')::timestamp without time zone as dep_sched_local
	to_timestamp(dep_date||' '||substr(dep_time,1,4),'DD.MM.YYYY HH24MI')::timestamp without time zone as dep_sched_local, 
	trav_name 
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
	select --f.dest_iata as dest_iata_test, 
	vr.* ,f.dep_sched_local as matched_dep_sched_local, f.flight_id, f.cancelled, f.diftime_utc, f.airline_opva,f.airline_iata_op,
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
--select m.*, count(*) over (partition by flight_id) from match m order by import_counter 


select case when cancelled='Cancelled' then 'Cancelled' else 'Delayed' end as status, 
--airline_iata_op,
count(*) as vorgaenge, 
count(distinct flight_id) as fluege, 
count(distinct import_counter), 
sum(airline_opva)
 from match
group by cancelled --,airline_iata_op
--order by airline_iata_op

