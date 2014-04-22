create view staging.v_flights as
with flights_temp1 as
(
select 
flight_id,
substr(ident,1,3) as airline_icao,
ic.iata as airline_iata,
substr(ident, 4, length(ident)-3) as flightnumber,

origin_icao,
aic1.iata as origin_iata, 
origin_name, 
origin_city,

dest_icao, 
aic2.iata as dest_iata,
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
f.distance * 1.85200 as distance_km_fa,
enroute, 
cancelled,
d.distance as distance_km_cal,
ic.len_vec as airline_len_vec,
ic.airline_vec 


from staging.fa_flights_2013 f left join staging.v_airlines_ref_icao ic
on substr(f.ident,1,3)=ic.icao
left join staging.of_distances d
on f.origin_icao=d.origin and f.dest_icao=d.dest
left join staging.v_airports_ref_icao aic1 
on f.origin_icao=aic1.icao
left join staging.v_airports_ref_icao aic2 
on f.dest_icao=aic2.icao
)
select f.*, --arr_act_local,arr_sched_local,
extract ('epoch' from arr_act_utc-arr_sched_utc)/3600 as diftime_utc --,arr_act_utc,arr_sched_utc

from flights_temp1 f

--where airline_vec is null
--where origin_iata is null or dest_iata is null
