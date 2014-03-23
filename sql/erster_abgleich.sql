with al_prep as
(
select * from airlines
where iata is not null and iata not in ('-', '')
and icao not in ('', '\N', '***', '???', '===')
), 
ba_prep as
(
select bt.*, ap.icao,ap.icao||bt.flugnummer as ident, abreisedatum::date as dep_date from c_bayer_test1 bt left join al_prep ap
on bt.code_transportunternehmen=ap.iata
)
--select * from ba_prep
,
fa_prep as
(select f.*,substr(scheduled_departure_time,1,10)::date as dep_date from fa_2013_char f)
select * from ba_prep bp inner join fa_prep fp
on bp.ident=fp.ident and bp.dep_date=fp.dep_date
order by reisedauer, cancelled
