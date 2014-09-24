
select rate from conv_rates where currency='RUB' and date=(select max(date) from conv_rates)