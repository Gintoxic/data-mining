﻿with distinct_iata as
( 
	select distinct on (iata) iata, icao, name,country from staging.of_airlines a
	where iata  not in ('', 'N/A') and  icao not in ('', 'N/A')
), 
russia_adv as
(
select r.*, di.icao as airline_icao

--to_date(r.dep_date, 'DD.MM.YYYY') as de_date_test

from staging.cd_russia_test r left join distinct_iata di
on r.carrier_code=di.iata
where flightnumber!='ST1979'
),

--select * from russia_adv

match as 
(
select --r.*, 
f.* 
from russia_adv r
inner join staging.v_flights f
on 
to_date(r.dep_date, 'DD.MM.YYYY')=date_trunc('day',f.dep_sched_local)
 and r.flightnumber::numeric = f.flightnumber::numeric
and r.carrier_code=f.airline_iata
and r.dest_iata=f.dest_iata
and r.origin_iata=f.origin_iata
--order by f.flight_id nulls last, r.cd_id
order by dep_act_local
)
select distinct origin_icao, dest_icao, dep_sched_local, airline_icao, flightnumber from match