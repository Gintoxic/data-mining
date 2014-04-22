--CREATE SEQUENCE staging.cd_id_ru_seq;
--ALTER TABLE staging.cd_russia_test2 ALTER COLUMN cd_id SET DEFAULT nextval('staging.cd_id_ru_seq');
--ALTER TABLE staging.cd_russia_test2 ALTER COLUMN cd_id SET NOT NULL;

--SELECT MAX(cd_id) FROM staging.cd_russia_test2

--SELECT setval('staging.cd_id_ru_seq', 2001430);

select * from staging.cd_russia_test2