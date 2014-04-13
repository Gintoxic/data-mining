create view airlines_iaic as
select a.*, 
row_number() over (partition by iata) as num_iata, 
row_number() over (partition by icao) as num_icao
 from airlines a
 where iata  !='' and icao not in ('\N', '', ':::', '\\''\\', '???', '---')