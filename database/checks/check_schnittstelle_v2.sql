select 
'1'||to_char(flight_id,'FM0000000') as v_id,
to_char(current_timestamp, 'DD.MM.YYYY HH24:MI:SS') as erst_datum,
'A' as V_Typ,
airline_iata||' '||flightnumber as flugnummer, 
airline_icao as airline, 
origin_city as abflugort, 
dest_city as zielort, 

to_char(dep_sched_local, 'DD.MM.YYYY HH12:MI:SS')  as startflug_soll, 
to_char(dep_act_local, 'DD.MM.YYYY HH12:MI:SS') as startflug_ist,
case when dep_tz ='CEST' then 'MESZ' 
when dep_tz='CET' then 'MEZ'
else dep_tz end as Z_AB,
to_char(arr_sched_local, 'DD.MM.YYYY HH12:MI:SS')  as anflug_soll, 
to_char(arr_act_local, 'DD.MM.YYYY HH12:MI:SS') as anflug_ist,

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
987654321 as Ticket_Nr,
'EUR' as Währung, 
'100,00' as Tick_Preis,
'10,00' as Tick_Geb, 
'7,00' as Tick_ST_7,
'19,00' as Tick_ST_19, 
'Testfirma' || row_number() over (partition by 1) as U_Name_1, 
'Test' as U_Name_2,
'Teststr.' as U_Str,
'12345' as U_Plz,
'Testort' as U_Ort,
'Herr Test' as U_ASP,
'001 234567' as U_Tel, 
'001 234568' as U_Fax,
'test'|| row_number() over (partition by 1)||'@testfirma.de' as U_Email,
'Testbank' as U_Bankname,
'TESTBIC' as U_BIC, 
'DE111222330000112233' as U_IBAN,
'123456789012' as U_BLZ,
'6789012' as U_Konto,
'Testing' as R_VName, 
'Tester' as R_NName, 
'Testweg '|| row_number() over (partition by 1) as R_Str,
'54321' as R_PLZ,
'Obertestingen' as R_Ort,
'Testing Tester'|| row_number() over (partition by 1) as R_ASP,
'001 234569' as R_Tel, 
'001 234560' as R_Fax,
'test@testkunde.de' as R_Email,
'001 1234 1234567' as R_Mphone,	
'Andere Testbank' as R_Bankname,
'TEST222' as R_BIC,
'DE1234567890123456789013' as R_IBAN,
'123456789012' as R_BLZ	,
'23456789013' as R_Konto,
case when random()<=0.4 then 'U' else 'A' end as Anspruch,
'1234' as Berater
 from v_flights f
 where dep_tz in ('CET','CEST', 'EET', 'CFT') and arr_tz in ('CET','CEST', 'EET', 'CFT')