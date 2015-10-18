with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('day', dep_sched_local), origin_iata, dest_iata)
	airline_opva,
	airline_iata, flightnumber, 
	airline_icao,
	dep_sched_local,
	date_trunc('minute', dep_sched_local) as dep_sched_local_min,
	date_trunc('hour', dep_sched_local) as dep_sched_local_hour, 
	date_trunc('day', dep_sched_local) as dep_sched_local_date, 
dep_act_local,
dep_tz,
arr_sched_local,
arr_act_local,
arr_tz ,

	origin_iata, dest_iata, origin_city , dest_city ,
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

	c.airline_iata_is as airline_iata,

	c.flighnumber as flightnumber,
	
	date_trunc('minute',dep_sched_local) as dep_sched_local_min,
	date_trunc('hour',dep_sched_local) as dep_sched_local_hour,
*	
	from  prep4 c
	where flighnumber  !~ '[^0-9]'

),
--select * from valid_rows


match as
(
	select vr.* ,f.dep_sched_local as matched_dep_sched_local, f.flight_id, 
	f.cancelled, f.diftime_utc,airline_opva,

f.airline_icao,
f.origin_city ,
f.dest_city ,
f.dep_act_local,
f.dep_tz,
f.arr_sched_local,
f.arr_act_local,
f.arr_tz ,
f.type_dist,
case when f.type_dist =1 then 'kurz'
when f.type_dist=2 then 'mittel'
when f.type_dist=3 then 'lang' end as dist
--f.dep_sched_local-vr.dep_sched_local as dif
	
	
	from valid_rows vr inner join distinct_flights f
	on vr.airline_iata=f.airline_iata
	and vr.flightnumber::numeric=f.flightnumber::numeric
	and vr.dep_sched_local_min=f.dep_sched_local_min
	--and vr.dep_sched_local_hour=f.dep_sched_local_hour
	--and vr.dep_sched_local=f.dep_sched_local_date
	
	and vr.origin_iata=f.origin_iata
	and vr.dest_iata=f.dest_iata

	--where cancelled='Delayed'
)
select '' as v_id,
to_char(current_timestamp, 'DD.MM.YYYY HH24:MI:SS') as erst_datum,
'A'  as V_Typ,
airline_iata||' '||flightnumber as flugnummer, 
airline_icao as airline, 
origin_city as abflugort, 
dest_city as zielort, 
to_char(dep_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as startflug_soll, 
to_char(dep_act_local, 'DD.MM.YYYY HH24:MI:SS') as startflug_ist,

case when dep_tz ='CET' then 'MEZ' 
when dep_tz ='CEST' then 'MESZ'
else dep_tz end as Z_AB,
to_char(arr_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as anflug_soll, 
to_char(arr_act_local, 'DD.MM.YYYY HH24:MI:SS') as anflug_ist,
case 
when arr_tz='CET' then 'MEZ' 
when arr_tz='CEST' then 'MESZ'
else arr_tz end as Z_AN, 

case when type_dist=1 then 'K'
when type_dist=2 then 'M'
when type_dist=3 then 'L' end as Typ_K_M_L, 
case when cancelled ='Cancelled' then  'C' else '2' end as Vers_Typ,
case when type_dist=1 then '250,00'
when type_dist=2 then '400,00'
when type_dist=3 then '600,00' end as Ersatz, 
dokumentationsnummer as Ticket_Nr,
'EUR' as Währung, 
'' as Tick_Preis,
'' as Tick_Geb, 
'' as Tick_ST_7,
'' as Tick_ST_19, 
'Merck KGaA' as U_Name_1, 
'' as U_Name_2,
'Frankfurter Straße 250' as U_Str,
'64293' as U_Plz,
'Darmstadt' as U_Ort,
'' as U_ASP,
'' as U_Tel, 
'' as U_Fax,
'' as U_Email,
'' as U_Bankname,
'' as U_BIC, 
'' as U_IBAN,
'' as U_BLZ,
'' as U_Konto,
first_name_c as R_VName, 
last_name as R_NName, 
'' as R_Str,
'' as R_PLZ,
'' as R_Ort,
'' as R_ASP,
' ' as R_Tel, 
' ' as R_Fax,
'' as R_Email,
'' as R_Mphone,	
'' as R_Bankname,
'' as R_BIC,
'' as R_IBAN,
'' as R_BLZ,
'' as R_Konto,
'U' as Anspruch,
'1000' as Berater,
* from match 
--where cancelled='Delayed'
order by airline

