with flights as
(select distinct on (origin_iata, dest_iata, flightnumber, date_trunc('minute', f.dep_sched_local)) f.* from v_flights f)

select * from cd_100_reimport r left join flights f 
on r.origin_iata=f.origin_iata
and r.dest_iata=f.dest_iata
and r.flightnumber=f.flightnumber
and to_timestamp(r.dep_sched_local, 'DD.MM.YYYY HH24:MI')::timestamp without time zone=date_trunc('minute', f.dep_sched_local)
order by counter

