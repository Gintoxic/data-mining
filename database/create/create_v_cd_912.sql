create view cd_012_03 as
select --count(*)
m.*, 
b.import_counter as b_import_counter, 
b.ticketbetrag_eur, 
b.taxbetrag_eur, 
b.ticketbruttobetrag_eur
from cd_012_03_mp m left join cd_012_03_bp b
on m.ticketnumber=b.ticketnumber
and m.trav_name=b.trav_name
and m.origin_iata=b.origin_iata
and m.dest_iata=b.dest_iata
and m.airline_iata=b.airline_iata


