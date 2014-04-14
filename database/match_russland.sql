--select distinct origin_name, origin_city from staging.cd_russia_test

select count(distinct f.flight_id)
--select r.*, f.* 
from staging.cd_russia_test r
left join staging.v_flights f
on to_date(r.dep_date, 'DD.MM.YYYY')=date_trunc('day',f.dep_sched_local)
and r.flightnumber::numeric = f.flightnumber::numeric
--order by f.flight_id nulls last, r.cd_id

--limit 100