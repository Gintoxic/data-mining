select origin_country, dest_country, count(*) as anz from v_flights
where origin_country='Switzerland' OR dest_country='Switzerland'
group by origin_country,dest_country
--order by origin_country,dest_country
order by anz desc
