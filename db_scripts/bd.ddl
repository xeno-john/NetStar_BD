-- Generated by Oracle SQL Developer Data Modeler 20.3.0.283.0710
--   at:        2020-12-30 13:39:02 EET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



DROP TABLE appointments CASCADE CONSTRAINTS;

DROP TABLE clients CASCADE CONSTRAINTS;

DROP TABLE computer_configuration CASCADE CONSTRAINTS;

DROP TABLE computers CASCADE CONSTRAINTS;

DROP TABLE ic_employees CASCADE CONSTRAINTS;

DROP TABLE rooms CASCADE CONSTRAINTS;

DROP SEQUENCE appointment_id_seq;

DROP SEQUENCE computer_cfg_seq;

DROP SEQUENCE computer_id_seq;

DROP SEQUENCE employee_id_seq;

DROP SEQUENCE room_id_seq;

DROP SEQUENCE user_id_seq;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE SEQUENCE appointment_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE computer_cfg_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE computer_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE employee_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE room_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE user_id_seq START WITH 1 NOCACHE ORDER;

CREATE TABLE appointments (
    appointment_id    NUMBER NOT NULL,
    computer_id       NUMBER NOT NULL,
    client_id         NUMBER NOT NULL,
    appointment_date  DATE NOT NULL,
    start_time        DATE NOT NULL,
    end_time          DATE NOT NULL,
    price             NUMBER NOT NULL,
    employee_id_pk    NUMBER
)
LOGGING;

ALTER TABLE appointments ADD CONSTRAINT time_validation CHECK ( end_time > start_time );

ALTER TABLE appointments
    ADD CONSTRAINT pk_appointment PRIMARY KEY ( appointment_date,
                                                start_time,
                                                computer_id,
                                                appointment_id );

ALTER TABLE appointments
    ADD CONSTRAINT appointment_1 UNIQUE ( start_time,
                                          end_time,
                                          computer_id );

ALTER TABLE appointments ADD CONSTRAINT appointment_2 UNIQUE ( computer_id,
                                                               end_time );

CREATE TABLE clients (
    user_id_pk         NUMBER NOT NULL,
    user_name          VARCHAR2(16) NOT NULL,
    e_mail             VARCHAR2(64) NOT NULL,
    password           VARCHAR2(64) NOT NULL,
    registration_date  DATE NOT NULL,
    account_credits    NUMBER NOT NULL,
    photo              BLOB
)
LOGGING;

ALTER TABLE clients
    ADD CONSTRAINT user_name_ck CHECK ( length(user_name) >= 4 );

ALTER TABLE clients ADD CONSTRAINT client_email_ck CHECK ( e_mail LIKE '%_@__%.__%' );

ALTER TABLE clients
    ADD CONSTRAINT password_ck CHECK ( length(password) > 4 );

ALTER TABLE clients ADD CONSTRAINT account_credits_ck CHECK ( account_credits >= 0 );

COMMENT ON TABLE clients IS
    'Table which contains all of te business clients with necessary information.';

ALTER TABLE clients ADD CONSTRAINT e_mail_ck CHECK ( e_mail LIKE '%_@__%.__%' );

ALTER TABLE clients ADD CONSTRAINT employees_pk PRIMARY KEY ( user_id_pk );

ALTER TABLE clients ADD CONSTRAINT c_email_unique UNIQUE ( e_mail );

ALTER TABLE clients ADD CONSTRAINT c_user_name_unique UNIQUE ( user_name );

CREATE TABLE computer_configuration (
    computer_cfg_id_pk  NUMBER NOT NULL,
    cpu                 VARCHAR2(32) NOT NULL,
    gpu                 VARCHAR2(32) NOT NULL,
    ram                 VARCHAR2(32) NOT NULL,
    monitor             VARCHAR2(32) NOT NULL,
    mouse               VARCHAR2(32) NOT NULL,
    keyboard            VARCHAR2(32) NOT NULL
)
LOGGING;

COMMENT ON TABLE computer_configuration IS
    'Computer configurations.';

ALTER TABLE computer_configuration ADD CONSTRAINT computer_configuration_pk PRIMARY KEY ( computer_cfg_id_pk );

CREATE TABLE computers (
    computer_id_pk      NUMBER NOT NULL,
    room_fk             NUMBER NOT NULL,
    computer_cfg_id_pk  NUMBER NOT NULL
)
LOGGING;

COMMENT ON TABLE computers IS
    'Table for all the computers of the business.';

ALTER TABLE computers ADD CONSTRAINT computers_pk PRIMARY KEY ( computer_id_pk );

CREATE TABLE ic_employees (
    employee_id_pk  NUMBER NOT NULL,
    first_name      VARCHAR2(32) NOT NULL,
    last_name       VARCHAR2(32) NOT NULL,
    e_mail          VARCHAR2(32),
    phone_number    VARCHAR2(10) NOT NULL,
    salary          NUMBER NOT NULL,
    hiring_date     DATE NOT NULL
)
LOGGING;

ALTER TABLE ic_employees
    ADD CONSTRAINT first_name_ck CHECK ( REGEXP_LIKE ( first_name,
                                                       '^[^0-9]+$' ) );

ALTER TABLE ic_employees
    ADD CONSTRAINT last_name_ck CHECK ( REGEXP_LIKE ( last_name,
                                                      '^[^0-9]+$' ) );

ALTER TABLE ic_employees ADD CONSTRAINT employees_email_ck CHECK ( e_mail LIKE '%_@__%.__%' );

COMMENT ON TABLE ic_employees IS
    'Table for all current employees.';

ALTER TABLE ic_employees ADD constraint phone_number_ck CHECK ( REGEXP_LIKE ( phone_number,
                                                      '^[0-9]{10}$' ))
;
ALTER TABLE ic_employees ADD CONSTRAINT employees_pkv1 PRIMARY KEY ( employee_id_pk );

ALTER TABLE ic_employees ADD CONSTRAINT e_email_unique UNIQUE ( e_mail );

ALTER TABLE ic_employees ADD CONSTRAINT e_phone_unique UNIQUE ( phone_number );

CREATE TABLE rooms (
    room_id_pk             NUMBER NOT NULL,
    name                   VARCHAR2(16) NOT NULL,
    number_of_computers    NUMBER NOT NULL,
    configuration_type_fk  NUMBER NOT NULL
)
LOGGING;

COMMENT ON TABLE rooms IS
    'Rooms in which the business location is separated, that offer different conditions for playing video games.';

ALTER TABLE rooms ADD CONSTRAINT rooms_pk PRIMARY KEY ( room_id_pk );

ALTER TABLE rooms ADD CONSTRAINT rooms_name_un UNIQUE ( name );

ALTER TABLE appointments
    ADD CONSTRAINT appointments_clients_fk FOREIGN KEY ( client_id )
        REFERENCES clients ( user_id_pk )
    NOT DEFERRABLE;

ALTER TABLE appointments
    ADD CONSTRAINT appointments_computers_fk FOREIGN KEY ( computer_id )
        REFERENCES computers ( computer_id_pk )
    NOT DEFERRABLE;

ALTER TABLE appointments
    ADD CONSTRAINT appointments_employees_fk FOREIGN KEY ( employee_id_pk )
        REFERENCES ic_employees ( employee_id_pk )
    NOT DEFERRABLE;

ALTER TABLE computers
    ADD CONSTRAINT computer_configuration_fk FOREIGN KEY ( computer_cfg_id_pk )
        REFERENCES computer_configuration ( computer_cfg_id_pk )
    NOT DEFERRABLE;

ALTER TABLE computers
    ADD CONSTRAINT computers_rooms_fk FOREIGN KEY ( room_fk )
        REFERENCES rooms ( room_id_pk )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER appointment_id_trg BEFORE
    INSERT ON appointments
    FOR EACH ROW
    WHEN ( new.appointment_id IS NULL )
BEGIN
    :new.appointment_id := appointment_id_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER user_id_trg BEFORE
    INSERT ON clients
    FOR EACH ROW
    WHEN ( new.user_id_pk IS NULL )
BEGIN
    :new.user_id_pk := user_id_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER computer_cfg_trg BEFORE
    INSERT ON computer_configuration
    FOR EACH ROW
    WHEN ( new.computer_cfg_id_pk IS NULL )
BEGIN
    :new.computer_cfg_id_pk := computer_cfg_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER computer_id_trg BEFORE
    INSERT ON computers
    FOR EACH ROW
    WHEN ( new.computer_id_pk IS NULL )
BEGIN
    :new.computer_id_pk := computer_id_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER employee_id_trg BEFORE
    INSERT ON ic_employees
    FOR EACH ROW
    WHEN ( new.employee_id_pk IS NULL )
BEGIN
    :new.employee_id_pk := employee_id_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER room_id_trg BEFORE
    INSERT ON rooms
    FOR EACH ROW
    WHEN ( new.room_id_pk IS NULL )
BEGIN
    :new.room_id_pk := room_id_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             28
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           6
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          6
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
