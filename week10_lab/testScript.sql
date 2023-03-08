/*
||  Name:          testScript.sql
||  Date:          28 Feb 2023
||  Purpose:       Test components seperatly before adding to full
*/

-- logfile
SPOOL 'logs/testScript.txt'

-- environment settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF


-- subtype contact_t declaration
CREATE OR REPLACE TYPE contact_t UNDER base_t (
    -- properties unique to subtype
    contact_id          NUMBER,
    member_id           NUMBER,
    contact_type        NUMBER,
    first_name          VARCHAR2(60),
    middle_name         VARCHAR2(60),
    last_name           VARCHAR2(60),
    created_by          NUMBER,
    creation_date       DATE,
    last_updated_by     NUMBER,
    last_updated_date   DATE,

    -- subtype constructor
    CONSTRUCTOR FUNCTION contact_t(
        oname               VARCHAR2,
        name                VARCHAR2,
        contact_id          NUMBER,
        member_id           NUMBER,
        contact_type        NUMBER,
        first_name          VARCHAR2,
        middle_name         VARCHAR2,
        last_name           VARCHAR2,
        created_by          NUMBER,
        creation_date       DATE,
        last_updated_by     NUMBER,
        last_updated_date   DATE
    ) RETURN SELF AS RESULT,

    -- overriding members
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
/

-- subtype item_t body
CREATE OR REPLACE TYPE BODY contact_t IS

    -- constructor
    CONSTRUCTOR FUNCTION contact_t(
        oname               VARCHAR2,
        name                VARCHAR2,
        contact_id          NUMBER,
        member_id           NUMBER,
        contact_type        NUMBER,
        first_name          VARCHAR2,
        middle_name         VARCHAR2,
        last_name           VARCHAR2,
        created_by          NUMBER,
        creation_date       DATE,
        last_updated_by     NUMBER,
        last_updated_date   DATE
    ) RETURN SELF AS RESULT IS
        BEGIN
            -- assign base properties
            self.oname := oname;
            IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
                self.name := name;
            END IF;

            -- assign properties
            self.contact_id := contact_id;
            self.member_id := member_id;
            self.contact_type := contact_type;
            self.first_name := first_name;
            self.middle_name := middle_name;
            self.last_name := last_name;
            self.created_by := created_by;
            self.creation_date := creation_date;
            self.last_updated_by := last_updated_by;
            self.last_updated_date := last_updated_date;
        RETURN;
    END;

    -- overrided members
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
        BEGIN
        RETURN (self AS base_t).get_name();
    END get_name;

    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
        BEGIN
        RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
END;
/

-- verify item_t
DESC contact_t

list
SHOW errors

-- close log file
SPOOL OFF