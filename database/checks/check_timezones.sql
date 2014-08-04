with timezones as
(
select distinct dep_tz as tz, timezone_dif_dep as timezone_dif from v_flights
union
select distinct arr_tz as tz, timezone_dif_arr as timezone_dif from v_flights
)
select * from timezones
order by timezone_dif desc, tz

--select * from v_flights