/*
||  Name:          apply_plsql_lab10.sql
||  Date:          07 Mar 2023
||  Purpose:       Complete 325 Chapter 11 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab10.txt

/* Clean up database */
DROP TABLE logger;
DROP SEQUENCE logger_s;
DROP TYPE contact_t FORCE;
DROP TYPE item_t FORCE;
DROP TYPE base_t FORCE;

SET SERVEROUTPUT ON SIZE UNLIMITED

/* Create new base object */
-- base_t declaration
CREATE OR REPLACE TYPE base_t IS OBJECT(
    -- properties
    oname VARCHAR2(30),
    name  VARCHAR2(30),

    -- constructors
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT,
    CONSTRUCTOR FUNCTION base_t(
        oname VARCHAR2, 
        name VARCHAR2
    ) RETURN SELF AS RESULT,

    -- getters and setters
    MEMBER FUNCTION get_oname RETURN VARCHAR2,
    MEMBER FUNCTION get_name RETURN VARCHAR2,
    MEMBER PROCEDURE set_oname (oname VARCHAR2),

    --other
    MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
-- end base_t declaration
/

-- base_t object body
CREATE OR REPLACE TYPE BODY base_t IS

    -- constructors
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
        BEGIN
            self.oname := 'BASE_T';
        RETURN;
    END;

    CONSTRUCTOR FUNCTION base_t(
        oname VARCHAR2,
        name VARCHAR2
    ) RETURN SELF AS RESULT IS
        BEGIN
            IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
                self.name := name;
            END IF;
        RETURN;
    END;

    -- getters and setters
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
        BEGIN
        RETURN self.oname;
    END get_oname;

    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
        BEGIN
        RETURN self.name;
    END get_name;

    MEMBER PROCEDURE set_oname(oname VARCHAR2) IS
        BEGIN
            self.oname := oname;
    END set_oname;

    -- other
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
        BEGIN
        RETURN '['||self.oname||']';
    END to_string;
END;
/
-- end base_t body

-- check base_t creation
DESC base_t;
DECLARE 
    lv_instance BASE_T := base_t();
BEGIN
    dbms_output.put_line('default: '||lv_instance.get_oname());
    lv_instance.set_oname('SUBSTITUTE');
    dbms_output.put_line('Override: '||lv_instance.get_oname());
END;
/

/* Create subtype item_t */
-- subtype item_t declaration
CREATE OR REPLACE TYPE item_t UNDER base_t (
    -- properties unique to subtype
    item_id             NUMBER,
    item_barcode        VARCHAR2(20),
    item_type           NUMBER,
    item_title          VARCHAR2(60),
    item_subtitle       VARCHAR2(60),
    item_rating         VARCHAR2(8),
    item_rating_agency  VARCHAR2(4),
    item_release_date   DATE,
    created_by          NUMBER,
    creation_date       DATE,
    last_updated_by     NUMBER,
    last_updated_date   DATE,

    -- subtype constructor
    CONSTRUCTOR FUNCTION item_t(
        oname               VARCHAR2,
        name                VARCHAR2,
        item_id             NUMBER,
        item_barcode        VARCHAR2,
        item_type           NUMBER,
        item_title          VARCHAR2,
        item_subtitle       VARCHAR2,
        item_rating         VARCHAR2,
        item_rating_agency  VARCHAR2,
        item_release_date   DATE,
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
CREATE OR REPLACE TYPE BODY item_t IS

    -- constructor
    CONSTRUCTOR FUNCTION item_t(
        oname               VARCHAR2,
        name                VARCHAR2,
        item_id             NUMBER,
        item_barcode        VARCHAR2,
        item_type           NUMBER,
        item_title          VARCHAR2,
        item_subtitle       VARCHAR2,
        item_rating         VARCHAR2,
        item_rating_agency  VARCHAR2,
        item_release_date   DATE,
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
            self.item_id := item_id;
            self.item_barcode := item_barcode;       
            self.item_type := item_type;
            self.item_title := item_title;
            self.item_subtitle := item_subtitle;
            self.item_rating := item_rating;
            self.item_rating_agency := item_rating_agency;
            self.item_release_date := item_release_date;
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
-- end subtype item_t body

-- verify item_t
DESC item_t

/* Create subtype item_t */
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

    -- constructors
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
-- end subtype contact_t body

--verify contact_t
DESC contact_t

/* create logger table and sequence */
CREATE TABLE logger(
    logger_id NUMBER,
    log_text BASE_T
);
CREATE SEQUENCE logger_s;

-- check table creation
DESC logger;

/* Fill in Logger table */

-- new base_t row default constuctor
INSERT INTO logger VALUES(
    logger_s.NEXTVAL,
    base_t() 
);

-- new base_t row parameter constructor

-- test logger table insertions
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('BASE_T','CONTACT_T','ITEM_T');
-- list
-- SHOW ERRORS

-- Close log file.
SPOOL OFF
