create view staging.v_airlines_iaic as
with airlines1 as
(select distinct on (iata,icao) * from staging.of_airlines
where iata != '' and icao not in ('', '\N')
),
airlines2 as
(
select a.*, 
count(*) over (partition by iata) as num_iata, 
count(*) over (partition by icao) as num_icao 
from airlines1 a
--where (iata,icao) not in (('BER','EDDB'), ('BFT','KBFT'))
)
select airline_id, name, alias, iata, icao, callsign, country from airlines2
where num_iata=1 and num_icao=1