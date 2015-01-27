create table tm_flightstates as
with flightstates as
(
select '0'::varchar(255) as flightstate,  'scheduled'::varchar(255) as flightstate_desc union
select '1'::varchar(255) as flightstate,  'delayed'::varchar(255) as flightstate_desc union
select '2'::varchar(255) as flightstate,  'landed'::varchar(255) as flightstate_desc union
select '3'::varchar(255) as flightstate,  'landing finished'::varchar(255) as flightstate_desc union
select '4'::varchar(255) as flightstate,  'canceled'::varchar(255) as flightstate_desc union
select '5'::varchar(255) as flightstate,  'baggage_claim'::varchar(255) as flightstate_desc union
select '6'::varchar(255) as flightstate,  'approaching'::varchar(255) as flightstate_desc union
select '7'::varchar(255) as flightstate,  'started'::varchar(255) as flightstate_desc union
select '8'::varchar(255) as flightstate,  'boarding finished'::varchar(255) as flightstate_desc union
select '9'::varchar(255) as flightstate,  'boarding'::varchar(255) as flightstate_desc union
select '10'::varchar(255) as flightstate,  'early'::varchar(255) as flightstate_desc union
select '11'::varchar(255) as flightstate,  'no information'::varchar(255) as flightstate_desc union
select '12'::varchar(255) as flightstate,  'diverted'::varchar(255) as flightstate_desc union
select '13'::varchar(255) as flightstate,  'confirmed'::varchar(255) as flightstate_desc union
select '14'::varchar(255) as flightstate,  'check-in open'::varchar(255) as flightstate_desc 
 )
 select flightstate, flightstate::integer as flightstate_num, flightstate_desc from flightstates
 order by flightstate_num