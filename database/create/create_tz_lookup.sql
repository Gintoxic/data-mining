create materialized view m_tzlookup as 
select 'CET' as tz, 'MEZ' as tz_de
union
select 'CEST' as tz, 'MESZ' as tz_de
