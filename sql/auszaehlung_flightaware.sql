
with orig as
(
select origin_icao as icao, count(*) as num_orig from fa_2013_char
group by origin_icao
), 
dest as
(select destination_icao as icao, count(*) as num_dest from fa_2013_char
group by destination_icao
), 
numbers as
(
select o.icao, num_orig, num_dest from orig o inner join dest d
on o.icao=d.icao

)
select n.*, a.city, a.country from numbers n left join airports a
on n.icao=a.icao
order by num_orig+num_dest desc
