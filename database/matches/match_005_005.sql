with p1 as
(
select  500000+row_number() over (partition by 1) as v_id,
c.* from cd_005_02 c
), 



p2 as
(
select p.v_id,
substr(p.ticket_number,1,10) as ticket_number,
ticket_price_rub,
ticketed_taxes_rub, 
address_street, 
address_street_number,
address_city,
address_postal_code,
first_name,
last_name,
f.airline_iata,f.flightnumber,
f.origin_city, f.dest_city,f.dep_sched_local,
f.dep_act_local,
f.dep_tz,
f.arr_tz,
f.arr_sched_local,
f.arr_act_local,
f.type_dist,
f.cancelled, 
f.airline_icao

from p1 p left join v_flights f
on p.flight_id = f.flight_id
)

select 
v_id,
to_char(current_timestamp, 'DD.MM.YYYY HH24:MI:SS') as erst_datum,
'A' as V_Typ,
airline_iata||' '||flightnumber as flugnummer,
airline_icao as airline,
origin_city as abflugort, 
dest_city as zielort,

to_char(dep_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as startflug_soll, 
to_char(dep_act_local, 'DD.MM.YYYY HH24:MI:SS') as startflug_ist,
case when dep_tz ='CEST' then 'MESZ' 
when dep_tz='CET' then 'MEZ'
else dep_tz end as Z_AB,
to_char(arr_sched_local, 'DD.MM.YYYY HH24:MI:SS')  as anflug_soll, 
to_char(arr_act_local, 'DD.MM.YYYY HH24:MI:SS') as anflug_ist,
case when arr_tz  ='CEST' then 'MESZ' 
when arr_tz ='CET' then 'MEZ'
else arr_tz  end as Z_AN,

case when type_dist=1 then 'K'
when type_dist=2 then 'M'
when type_dist=3 then 'L' end as Typ_K_M_L, 
case when cancelled is not null then 'C' else '2' end as Vers_Typ,
case when type_dist=1 then '250,00'
when type_dist=2 then '400,00'
when type_dist=3 then '600,00' end as Ersatz,
ticket_number as Ticket_Nr, 
'EUR' as Währung,
trim(
to_char(
(select rate from conv_rates where currency='RUB' and date=(select max(date) from conv_rates))* 
ticket_price_rub, '99G999D99')) as Tick_Preis,
trim(
to_char(
(select rate from conv_rates where currency='RUB' and date=(select max(date) from conv_rates))*
ticketed_taxes_rub, '99G999D99')) as Tick_Geb,

--ticket_price_rub- ticket_price_rub/1.07 as Tick_ST_7,
--ticket_price_rub- ticket_price_rub/1.19 as Tick_ST_19,

'' as Tick_ST_7,
'' as Tick_ST_19,

'Continent Express'  as U_Name_1, 
'' as U_Name_2,
'Leninskyi pr. 4/1A' as U_Str,
'RU-119049' as U_Plz,
'Moscow' as U_Ort,
'' as U_ASP,
'' as U_Tel, 
'' as U_Fax,
'' as U_Email,
'' as U_Bankname,
'' as U_BIC, 
'' as U_IBAN,
'' as U_BLZ,
'' as U_Konto,
first_name as R_VName, 
last_name as R_NName, 
address_street || ' ' || address_street_number as R_Str, 
'RU-'||address_postal_code as R_PLZ,
address_city as R_Ort,
v_id as R_ASP,
'' as R_Tel, 
'' as R_Fax,
'' as R_Email,
'' as R_Mphone,	
'' as R_Bankname,
'' as R_BIC,
'' as R_IBAN,
'' as R_BLZ,
'' as R_Konto,
'U' as Anspruch,
'1001' as Berater




from p2 p
order by v_id

