with prep as 
(select distinct on (ident_op, 	date_trunc('minute', dep_sched_local) ) * from v_flights)
select fa.*, tm.* from prep fa inner join 
tm_2013_03 tm 
on fa.ident_op= tm.carrieriata||tm.flightnumber --and
--date_trunc('minute', fa.dep_sched_local)=to_timestamp(tm.scheduled,'DD-MM-YYYY HH24:MI')
limit 100