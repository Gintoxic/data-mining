CREATE OR REPLACE VIEW v_cities AS 
 SELECT DISTINCT of_airports.icao,
    of_airports.city,
    of_airports.country
   FROM of_airports
  WHERE of_airports.icao::text <> '\N'::text;

ALTER TABLE v_cities
  OWNER TO flightrefund;
