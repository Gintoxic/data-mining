with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('day', dep_sched_local), origin_iata, dest_iata)
	airline_opva,
	airline_iata, flightnumber, 
	dep_sched_local,
	date_trunc('minute', dep_sched_local) as dep_sched_local_min,
	date_trunc('hour', dep_sched_local) as dep_sched_local_hour, 
	date_trunc('day', dep_sched_local) as dep_sched_local_date, 

	origin_iata, dest_iata,
	flight_id, cancelled, diftime_utc, type_dist from v_flights
),


---------------------------------------------------------------------
prep1 as
(
select position ('/' in trav_name) as sep_pos,

 * from cd_012_02
where length(trav_name)>1 and dep_sched_local_date!='[no data]' 
and length(dep_sched_local_time)>1
), 
prep2 as
(select 
to_timestamp(dep_sched_local_date||' '||dep_sched_local_time,'DD.MM.YYYY HH24:MI')::timestamp without time zone as dep_sched_local ,
* from prep1
where sep_pos>0),

prep3 as
(
select 
substring(trav_name from 1 for sep_pos-1) as last_name, 
substring(trav_name from sep_pos+1 for length(trav_name) ) as fist_name, 
--substr(sep_pos, trav_name), 
*
from prep2
), 
prep4 as
(
select case when fist_name like '%Mrs' or fist_name like '%mrs' then 'f' else 'm' end as sex, 
replace(replace(replace(replace(fist_name, 'Mrs', ''), 'mrs', ''), 'Mr', ''), 'mr', '') as first_name_c,
* from prep3
),


valid_rows as
(
	select 
	c.import_counter,
	c.airline_iata_is as airline_iata,
	c.flighnumber as flightnumber,
	c.origin_iata, 
	dest_iata,
	dep_sched_local,
	date_trunc('minute',dep_sched_local) as dep_sched_local_min,
	date_trunc('hour',dep_sched_local) as dep_sched_local_hour
	
	from  prep4 c
	where flighnumber  !~ '[^0-9]'

),
--select * from valid_rows


match as
(
	select vr.* ,f.dep_sched_local as matched_dep_sched_local, f.flight_id, f.cancelled, f.diftime_utc,airline_opva,


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
--select * from match

select  cancelled as status, airline_opva, count(*), count(distinct flight_id), count(distinct import_counter) from match
group by cancelled, airline_opva


