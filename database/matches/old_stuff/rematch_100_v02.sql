with flights as
(select distinct on (origin_iata, dest_iata, flightnumber, date_trunc('minute', f.dep_sched_local)) f.* from v_flights f)

select *, 


to_char(f.dep_sched_local, 'DD.MM.YYYY HH12:MI:SS') as dep_sched_local_,
to_char(f.dep_act_local, 'DD.MM.YYYY HH12:MI:SS') as dep_act_local_,


to_char(f.arr_sched_local, 'DD.MM.YYYY HH12:MI:SS') as arr_sched_local_,
to_char(f.arr_act_local, 'DD.MM.YYYY HH12:MI:SS') as arr_act_local_



 from cd_100_reimport r left join flights f 
on r.origin_iata=f.origin_iata
and r.dest_iata=f.dest_iata
and r.flightnumber=f.flightnumber
and to_timestamp(r.dep_sched_local, 'DD.MM.YYYY HH24:MI')::timestamp without time zone=date_trunc('minute', f.dep_sched_local)
order by counter

