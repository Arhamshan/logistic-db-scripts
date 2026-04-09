
-- liquibase formatted sql

-- changeset Arham_Muhammadh:2026_04_07_21_30_00
CREATE TABLE "Locations" (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location_code VARCHAR(20),
    type VARCHAR(20),
    city VARCHAR(20),
    country VARCHAR(20),
    latitude VARCHAR(20),
    longitude VARCHAR(20),
    CONSTRAINT unq_city_name UNIQUE (location_code)
);
--rollback drop table "Locations";
