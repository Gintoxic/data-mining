select icao, longitude, latitude from v_airports_iaic a inner join 

(select distinct origin_icao from v_flights) f1
on a.icao=f1.origin_icao
inner join
(select distinct dest_icao from v_flights) f2
on a.icao=f2.dest_icao