create view staging.v_bayer_test as
with bayer_test as
(
select 

teilstrecke_code_transportunternehmen as airline_iata,
teilstrecke_name_transportunternehmen as airline_name,
flugnummer as flightnumber,
segment_origin_airport_code as origin_iata,
segment_destination_airport_code as dest_iata,
(case when  substr(zeit_der_abreise,1,1) !='0' then to_timestamp(abreisedatum||' '||zeit_der_abreise, 'DD.MM.YYYY HH12:MI AM') end) ::timestamp without time zone as dep_sched_local,
(case when  substr(ankunftszeit,1,1) !='0' then to_timestamp(ankunftsdatum||' '||ankunftszeit, 'DD.MM.YYYY HH12:MI AM') end) ::timestamp without time zone as arr_sched_local,
c.*

from staging.cd_bayer_test c
 )
 select 
 cd_id,
 kundenname as customer,
airline_iata,
airline_name,
flightnumber,
origin_iata,
dest_iata,
dep_sched_local,
arr_sched_local, 
rechnungsnummer, 
to_number(segment_distance_miles,'999999999D99' ) as distance_miles
 
 from bayer_test b
 where dep_sched_local is not null and arr_sched_local is not null and teilstrecke_anzahl::numeric>0