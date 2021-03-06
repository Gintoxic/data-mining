﻿select * from staging.v_bayer_test bt inner join staging.v_flights f
on bt.origin_iata=f.origin_iata and bt.dest_iata=f.dest_iata 
and bt.flightnumber::numeric=f.flightnumber::numeric
and date_trunc('hour',bt.dep_sched_local)=date_trunc('hour',f.dep_sched_local)
order by cd_id