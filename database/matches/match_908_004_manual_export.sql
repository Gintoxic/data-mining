with rawdat as 
(select f.*, traveler_name as  trav_name, ticketnumber from cd_012_04 c left join v_flights f
on c.flight_id::bigint = f.flight_id
and c.flightnumber=f.flightnumber
and c.airline_iata=f.airline_iata
),

prep1 as
(
select position ('/' in trav_name) as sep_pos,

 * from rawdat
where length(trav_name)>1 

),

prep2 as
(
select 
substring(trav_name from 1 for sep_pos-1) as last_name, 
substring(trav_name from sep_pos+1 for length(trav_name) ) as fist_name, 
--substr(sep_pos, trav_name), 
*
from prep1
), 
prep3 as
(
select case when fist_name like '%Mrs' or fist_name like '%mrs' then 'f' else 'm' end as sex, 
replace(replace(replace(replace(fist_name, 'Mrs', ''), 'mrs', ''), 'Mr', ''), 'mr', '') as first_name_c, * from prep2
)
--select * from prep3

select '' as v_id,
to_char(current_timestamp, 'DD.MM.YYYY HH24:MI:SS') as erst_datum,
'A'  as V_Typ,
airline_iata||' '||flightnumber as flugnummer, 
airline_icao_op as airline, 
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
'' as Tick_Preis,
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
from prep3 
where cancelled='Cancelled'
order by airline