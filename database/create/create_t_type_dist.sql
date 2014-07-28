create table type_dist as
with type_dist as
(
select 1 as type_dist, 0 as dist_min, 1500 as dist_max union
select 2 as type_dist, 1500 as dist_min, 3500 as dist_max union
select 3 as type_dist, 3500 as dist_min, 99999 as dist_max 
)
select * from type_dist