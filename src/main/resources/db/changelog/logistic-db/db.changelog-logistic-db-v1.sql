
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

-- changeset Rizquan:2026_04_15_10_15_15
ALTER TABLE "Items"
    ADD COLUMN IF NOT EXISTS height NUMERIC(10,2),
    ADD COLUMN IF NOT EXISTS width NUMERIC(10,2),
    ADD COLUMN IF NOT EXISTS length NUMERIC(10,2),
    ADD COLUMN IF NOT EXISTS weight NUMERIC(10,2);

-- changeset Rizquan:2026_04_21_13_15_00
CREATE TABLE "Users"(
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(150) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50)
);
--rollback drop table "Users";

-- changeset Arham_Muhammadh:2026_04_26_21_30_30
ALTER TABLE "Contacts"
DROP COLUMN address,
ADD COLUMN IF NOT EXISTS address_line1 VARCHAR(150),
ADD COLUMN IF NOT EXISTS address_line2 VARCHAR(150);


-- changeset Rizquan:2026_05_07_12_52_00
ALTER TABLE "Consignments"
ALTER COLUMN status TYPE VARCHAR(40);

-- changeset Rizquan:2026_05_07_12_52_30
ALTER TABLE "Items"
ALTER COLUMN status TYPE VARCHAR(40);

-- changeset Rizquan:2026_05_07_17_27_00
ALTER TABLE "Events"
ALTER COLUMN event_type TYPE VARCHAR(40);

-- changeset Rizquan:2026_05_08_15_10_00
ALTER TABLE "Consignments"
ADD CONSTRAINT uq_consignment_id UNIQUE (consignment_id);

-- changeset Rizquan:2026_05_23_15_30_31
CREATE TABLE "Pods" (
     id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
     cons_item_id BIGINT NOT NULL REFERENCES "Items"(id),
     received_by VARCHAR(100),
     receiver_contact VARCHAR(50),
     remarks TEXT,
     pod_path TEXT,
     delivered_at TIMESTAMPTZ,
     delivered_by VARCHAR(100),
     created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     created_by VARCHAR(50),
     updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     updated_by VARCHAR(50)
);
--rollback DROP TABLE "Pods";

-- changeset Rizquan:2026_05_26_16_10_03
ALTER TABLE "Items" ADD COLUMN barcode_number VARCHAR(20) UNIQUE;
--rollback ALTER TABLE "Items" DROP COLUMN barcode_number;

-- changeset Rizquan:2026_06_08_16_50_01
ALTER TABLE "Items"
DROP CONSTRAINT fk_consignment,
ADD CONSTRAINT fk_consignment
    FOREIGN KEY (cons_id)
    REFERENCES "Consignments"(id)
    ON DELETE CASCADE;
--rollback ALTER TABLE "Items" DROP CONSTRAINT fk_consignment, ADD CONSTRAINT fk_consignment FOREIGN KEY (cons_id) REFERENCES "Consignments"(id);

-- changeset Rizquan:2026_06_08_17_07_30
ALTER TABLE "Events"
DROP CONSTRAINT fk_item,
ADD CONSTRAINT fk_item
    FOREIGN KEY (cons_item_id)
    REFERENCES "Items"(id)
    ON DELETE CASCADE;
--rollback ALTER TABLE "Events" DROP CONSTRAINT fk_item, ADD CONSTRAINT fk_item FOREIGN KEY (cons_item_id) REFERENCES "Items"(id);

-- changeset Rizquan:2026_06_23_16_00_00
CREATE TABLE "Notifications" (
   id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   cons_id BIGINT NOT NULL,
   event_code VARCHAR(50),
   recipient_email VARCHAR(100),
   recipient_phone VARCHAR(30),
   subject VARCHAR(255),
   message TEXT,
   status VARCHAR(20),
   sent_date TIMESTAMPTZ,
   created_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
   created_by VARCHAR(50),
   updated_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
   updated_by VARCHAR(50),
   CONSTRAINT fk_notification_consignment FOREIGN KEY (cons_id) REFERENCES "Consignments"(id) ON DELETE CASCADE
);
--rollback DROP TABLE "Notifications";