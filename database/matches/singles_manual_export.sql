with prep as
(
select s.*, a.iata as airline_iata, a.icao as airline_icao
from singles s left join of_airlines a
on substr(s.flugnummer,1,2)=a.iata
)

select 
* ,

'' as v_id,
'' erst_datum,
'A'  as V_Typ, 
flugnummer as flugnummer, 
airline_icao as airline,
abflugort, 
plan_zielort as zielort,
'' as startflug_soll, 
'' as startflug_ist,
'MESZ' as Z_AB,
''  as anflug_soll,
'' as anflug_ist,
'MESZ' as Z_AN,
'' as Typ_K_M_L, 
'' as Vers_Typ,
'' as	Ersatz	,
ticket_nummer as	Ticket_Nr	,
'' as	Währung	,
'' as	Tick_Preis	,
'' as	Tick_Geb	,
'' as	Tick_ST_7	,
'' as	Tick_ST_19	,
'' as	U_Name_1	,
'' as	U_Name_2	,
'' as	U_Str	,
'' as	U_PLZ	,
'' as	U_Ort	,
'' as	U_ASP	,
'' as	U_Tel	,
'' as	U_Fax	,
'' as	U_Email	,
'' as	U_Bankname	,
'' as	U_BIC	,
'' as	U_IBAN	,
'' as	U_BLZ	,
'' as	U_Konto	,
vorname as	R_Vname	,
nachname as	R_Nname	,
strasse as	R_Str	,
plz as	R_PLZ	,
ort as	R_Ort	,
'' as	R_ASP	,
tel as	R_Tel	,
'' as	R_Fax	,
email as	R_Email	,
'' as	R_Mphone	,
'' as	R_Bank	,
bic as	R_BIC	,
iban as	R_IBAN	,
'' as	R_BLZ	,
'' as	R_Konto	,
'R' as	Anspruch	,
'999' as	Berater	

from prep


/*
case when dep_tz ='CET' then 'MEZ' 
when dep_tz ='CEST' then 
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
'1000' as Berater*/

--where cancelled='Cancelled'
--order by airline