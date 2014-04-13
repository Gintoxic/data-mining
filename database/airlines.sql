with airlines1 as
(
select distinct on (iata) a.*,
count(*) over (partition by iata) as num_iata, 
count(*) over (partition by icao) as num_icao 

from airlines a
where iata not in ('', '\N') and icao not in ('', '\N')
) 
select * from airlines1
order by  num_icao desc, icao
