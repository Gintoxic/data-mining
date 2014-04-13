create view v_airports_iaic as
with airports1 as
(select distinct on (iata,icao) * from airports
where iata != '' and icao not in ('', '\N')
),
airports2 as
(
select a.*, 
count(*) over (partition by iata) as num_iata, 
count(*) over (partition by icao) as num_icao 
from airports1 a
where (iata,icao) not in (('BER','EDDB'), ('BFT','KBFT'))
)
select * from airports2
where num_iata=1 and num_icao=1