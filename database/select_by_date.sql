select * from v_flights
where date_trunc('month',arr_sched_local)::date = to_date('2013-04', 'YYYY-MM')::date