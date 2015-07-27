--select count(*) from cd_001_01 

with 
distinct_flights as
(
	select 
	distinct on (airline_iata, flightnumber, date_trunc('minute', dep_sched_local), origin_iata, dest_iata)
	airline_iata, flightnumber, airline_icao,origin_city,dest_city,dep_tz,arr_tz,
	dep_act_local,
	dep_sched_local,arr_sched_local, arr_act_local,
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
	date_trunc('hour',dep_sched_local) as dep_sched_local_hour,
	dep_date,dep_time,
	full_name, dok_nummer, ticketnumber, coupon
	
	from (select full_name, dok_nummer, ticketnumber, coupon, import_counter,  origin_iata, dest_iata, sched_iata as airline_iata , flightnumber_op as flightnumber, dep_date,dep_time,  to_timestamp(dep_date||' '||dep_time,'DD.MM.YYYY hh24:min')::timestamp without time zone as dep_sched_local from cd_908_02) c
	where flightnumber  !~ '[^0-9]' and dep_date!='[no data]'

),
--select * from valid_rows
match1 as
(
	select vr.* ,f.dep_sched_local as matched_dep_sched_local, f.flight_id, f.cancelled, f.diftime_utc, f.airline_icao,origin_city,dest_city,dep_act_local,
	dep_tz,arr_tz,arr_sched_local, arr_act_local,type_dist,
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
), 
match2 as (
select *
,position ('/' in full_name) as sep_pos 
from match1),
match3 as
(
select substring(full_name from 1 for sep_pos-1) as last_name, 
substring(full_name from sep_pos+1 for length(full_name) ) as fist_name, * from match2
), 
match4 as
(
select case when fist_name like '%Mrs' or fist_name like '%mrs' then 'f' else 'm' end as sex, 
replace(replace(replace(replace(fist_name, 'Mrs', ''), 'mrs', ''), 'Mr', ''), 'mr', '') as first_name_c, * from match3
)
--select * from match4

select 
'' as v_id,
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
ticketnumber as Ticket_Nr,
'EUR' as Währung, 
coupon as Tick_Preis,
'' as Tick_Geb, 
'' as Tick_ST_7,
'' as Tick_ST_19, 
'Konica Minolta' as U_Name_1, 
'Buisiness Solutions Europe GmbH' as U_Name_2,
'Europaallee 17' as U_Str,
'30855' as U_Plz,
'Langenhagen' as U_Ort,
'' as U_ASP,
'' as U_Tel, 
'' as U_Fax,
'' as U_Email,
'Commerzbank AG' as U_Bankname,
'COBADEFF250' as U_BIC, 
'IBANDE70250400660144744000' as U_IBAN,
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
'1000' as Berater
--,*

 from match4
order by vers_typ,airline