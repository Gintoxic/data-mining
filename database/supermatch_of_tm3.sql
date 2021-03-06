﻿with prep_tm1 as
(
select *
from tm_2013_04
where substr(scheduled,1,4)='2013' and substr(estimated,1,4)='2013' and flightnumber  !~ '[^0-9]'
), 
prep_tm as
(
select *,
to_timestamp(scheduled, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as scheduled_t, 
to_timestamp(estimated, 'YYYY-MM-DD HH24:MI'):: timestamp without time zone as estimated_t 
 from prep_tm1
where target='1'::varchar(255)
), 
prep_of as
(select * from v_flights
where date_trunc('month',arr_sched_local)::date = to_date('2013-04', 'YYYY-MM')::date)
--select * from prep_of --limit 100
,
res as
(
select date_part('epoch'::text, tm.estimated_t - tm.scheduled_t) / 60 as diftime_tm,diftime_local,
((date_part('epoch'::text, tm.estimated_t - tm.scheduled_t) / 60) - diftime_local)/ diftime_local::double precision as diftime_prct,
* from prep_tm tm inner join prep_of of
on tm.carrieriata = of.airline_iata and
 tm.airportiata=of.dest_iata and
 tm.flightnumber::numeric=of.flightnumber::numeric and
 date_trunc('hour', scheduled_t)= date_trunc('hour', of.arr_sched_local)
)
select round(diftime_prct::numeric,2) as round_diftime_prct,* from res
order by 1 desc nulls last
--order by diftime_local desc nulls last
/*
select date_trunc('hour', scheduled_t), count(*) from prep1
group by date_trunc('hour', scheduled_t)
order by date_trunc('hour', scheduled_t)
*/