create view airports_iaic as 

with ap1 as
(select a.*, 
row_number() over (partition by iata) as num_iata, 
row_number() over (partition by icao) as num_icao
from airports a
where iata !='' and icao not in ('', '\N')
order by num_iata desc, iata
)
select * from ap1 a
where a.iata!='BER' and num_iata=1 and num_icao=1