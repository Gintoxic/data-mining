create view staging.v_flights as
with flights_temp1 as
(
select 
flight_id,
substr(ident,1,3) as airline_icao,
ia.iata as airline_iata,
substr(ident, 4, length(ident)-3) as flightnumber,

origin_icao, 
origin_name, 
origin_city,

dest_icao, 
dest_name, 
dest_city,

to_timestamp(dep_sched_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as dep_sched_local,
substr(dep_sched_local, 18,4) as dep_tz,
to_timestamp(dep_sched_utc, 'YYYY-MM-DD HH24:MI') :: timestamp without time zone as dep_sched_utc,

to_timestamp(arr_sched_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as arr_sched_local,
substr(arr_sched_local, 18,4) as arr_tz,
to_timestamp(dep_sched_utc, 'YYYY-MM-DD HH24:MI') :: timestamp without time zone as arr_sched_utc,

to_timestamp(dep_act_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as dep_act_local,
to_timestamp(dep_act_utc, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as dep_act_utc,

to_timestamp(arr_act_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as arr_act_local,
to_timestamp(arr_act_utc, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as arr_act_utc,

registration,
code_shares,
f.distance,
enroute, 
cancelled,
d.distance as distance_check

from staging.fa_flights_2013 f left join staging.v_airlines_iaic ia
on substr(f.ident,1,3)=ia.icao
left join staging.of_distances d
on f.origin_icao=d.origin and f.dest_icao=d.dest
)
select ft.*, va1.iata as origin_iata,
va2.iata as dest_iata
 from flights_temp1 ft 
left join staging.v_airports_iaic va1
on ft.origin_icao=va1.icao
left join staging.v_airports_iaic va2
on ft.dest_icao=va2.icao