create materialized view v_flights as
with flights_temp0 as
(
select * , unnest(ident::text||string_to_array(code_shares, ' ')) ident_va
from fa_flights_2013
),
flights_temp1 as
(
select 
flight_id,
ident as ident_op,
 
substr(ident,1,3) as airline_icao_op,
icop.iata as airline_iata_op,
substr(ident, 4, length(ident)-3) as flightnumber_op,

code_shares,
ident_va,
case when ident_va=ident then 1 else 0 end as airline_opva,

substr(ident_va,1,3) as airline_icao,

icva.iata as airline_iata,
substr(ident_va, 4, length(ident_va)-3) as flightnumber,

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
to_timestamp(arr_sched_utc, 'YYYY-MM-DD HH24:MI') :: timestamp without time zone as arr_sched_utc,

to_timestamp(dep_act_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as dep_act_local,
to_timestamp(dep_act_utc, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as dep_act_utc,

to_timestamp(arr_act_local, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as arr_act_local,
to_timestamp(arr_act_utc, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as arr_act_utc,

registration,
f.distance * 1.85200 as distance_km_fa,
td.type_dist,

enroute, 
case when cancelled in ('Cancelled','Yes') then 'Cancelled' else 'Delayed' end as cancelled ,
d.distance as distance_km_cal,
icop.len_vec as airline_len_vec,
icop.airline_vec 

from flights_temp0 f left join v_airlines_ref_icao icop
on substr(f.ident,1,3)=icop.icao

left join v_airlines_ref_icao icva
on substr(f.ident_va,1,3)=icva.icao


left join of_distances d
on f.origin_icao=d.origin and f.dest_icao=d.dest
left join v_airports_ref_icao aic1 
on f.origin_icao=aic1.icao
left join v_airports_ref_icao aic2 
on f.dest_icao=aic2.icao
left join type_dist td on 
f.distance between td.dist_min and td.dist_max
), 
flights_temp2 as
(
select f.*, 

arr_act_utc-arr_sched_utc as diftime_utc_raw,
arr_act_local-arr_sched_local as diftime_locla_raw,
extract ('epoch' from arr_act_utc-arr_sched_utc)/60 as diftime_utc, 
extract ('epoch' from arr_act_local-arr_sched_local)/60 as diftime_local,

extract ('epoch' from dep_sched_local-dep_sched_utc)/3600 as timezone_dif_dep, 
extract ('epoch' from arr_sched_local-arr_sched_utc)/3600 as timezone_dif_arr,

v1.country as origin_country,
v2.country as dest_country

from flights_temp1 f
left join v_cities v1
on f.origin_icao=v1.icao
left join v_cities v2
on f.dest_icao=v2.icao

--order by diftime_utc nulls last
)
select * from flights_temp2
where (diftime_utc is null or diftime_utc >=180) 
and origin_iata is not null and dest_iata is not null
--order by flight_id

