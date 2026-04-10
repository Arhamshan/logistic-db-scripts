
-- liquibase formatted sql

-- changeset Arham_Muhammadh:2026_04_07_21_30_30
CREATE TABLE "Locations" (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location_code VARCHAR(20),
    type VARCHAR(20),
    city VARCHAR(20),
    country VARCHAR(20),
    latitude VARCHAR(20),
    longitude VARCHAR(20),
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    CONSTRAINT unq_city_name UNIQUE (location_code)
);
--rollback drop table "Locations";

-- changeset Rizquan:2026_04_09_14_43_30
CREATE TABLE "Contacts"(
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(30),
    address VARCHAR(50),
    state VARCHAR(30),
    suburb VARCHAR(30),
    postcode VARCHAR(30),
    country VARCHAR(30),
    latitude VARCHAR(50),
    longitude VARCHAR(50),
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50)
);
--rollback drop table "Contacts";

-- changeset Rizquan:2026_04_09_17_43_00
CREATE TABLE "Consignments"(
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consignment_id VARCHAR(50) NOT NULL,
    sender_contact_id BIGINT,
    destination_contact_id BIGINT,
    status VARCHAR(20),
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    CONSTRAINT fk_sender_contact FOREIGN KEY (sender_contact_id) REFERENCES "Contacts"(id),
    CONSTRAINT fk_destination_contact FOREIGN KEY (destination_contact_id) REFERENCES "Contacts"(id)
);
--rollback drop table "Consignments";

-- changeset Rizquan:2026_04_09_17_54_00
CREATE TABLE "Items"(
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_id VARCHAR(50) NOT NULL,
    cons_id BIGINT,
    status VARCHAR(20),
    current_location_code VARCHAR(20),
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    CONSTRAINT fk_consignment FOREIGN KEY (cons_id) REFERENCES "Consignments"(id)
);
--rollback drop table "Items";

-- changeset Rizquan:2026_04_09_18_00_00
CREATE TABLE "Events"(
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cons_item_id BIGINT,
    event_type VARCHAR(20),
    event_location_code VARCHAR(20),
    description VARCHAR(255),
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    CONSTRAINT fk_item FOREIGN KEY (cons_item_id) REFERENCES "Items"(id)
);
--rollback drop table "Events";