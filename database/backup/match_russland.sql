with distinct_iata as
( 
	select distinct on (iata) iata, icao, name,country from staging.of_airlines a
	where iata  not in ('', 'N/A') and  icao not in ('', 'N/A')
), 
russia_adv as
(
select r.*, di.icao as airline_icao from staging.cd_russia_test r left join distinct_iata di
on r.airline_iata=di.iata
)
select r.*, f.* 
from russia_adv r
left join staging.v_flights f
on to_date(r.dep_date, 'DD.MM.YYYY')=date_trunc('day',f.dep_sched_local)
and r.flightnumber::numeric = f.flightnumber::numeric
and r.airline_icao=f.airline_icao
order by f.flight_id nulls last, r.cd_id

--limit 100
