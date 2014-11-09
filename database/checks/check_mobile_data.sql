with prep as
(
select * from cd_015_201407
where estimated != 'NULL'
), 
prep2 as
(
select import_counter, to_timestamp(scheduled, 'YYYY-MM-DD HH24:MI:SS')::timestamp without time zone as scheduled, 
--estimated
to_timestamp(estimated, 'YYYY-MM-DD HH24:MI:SS')::timestamp without time zone as estimated
from prep
), 
prep3 as
(
select *,  date_part('epoch'::text,estimated-scheduled)/60 as difmin from prep2
)
select difmin, count(*)
from prep3
group by difmin
order by difmin

