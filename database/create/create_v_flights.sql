create view v_flights as
with flights_temp1 as
(
select substr(ident,1,3) as airline_icao,
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
distance, 
enroute, 
cancelled

from staging.flights_2013 
)
select ft.*, va1.iata as origin_iata,
va2.iata as dest_iata
 from flights_temp1 ft 
left join v_airports_iaic va1
on ft.origin_icao=va1.icao
left join v_airports_iaic va2
on ft.dest_icao=va2.icao