/*
||  Name:         base_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create base type for final project
||  Author:       Alice Smith  
*/
SPOOL 'logs/base_t.txt'

/* Create new base object */
-- base_t declaration
CREATE OR REPLACE TYPE base_t IS OBJECT(
    -- properties
    oid   NUMBER,
    oname VARCHAR2(30),

    -- constructor
    CONSTRUCTOR FUNCTION base_t(
        oid   NUMBER, 
        oname VARCHAR2
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

    -- constructor
    CONSTRUCTOR FUNCTION base_t(
        oid   NUMBER,
        oname VARCHAR2
    ) RETURN SELF AS RESULT IS
        BEGIN
            self.oid    := oid;
            self.oname  := oname;
        RETURN;
    END;

    -- getters and setters
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
        BEGIN
        RETURN self.oname;
    END get_oname;

    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
        BEGIN
        RETURN NULL;
    END get_name;

    MEMBER PROCEDURE set_oname(oname VARCHAR2) IS
        BEGIN
            self.oname := oname;
    END set_oname;

    -- other
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
        BEGIN
        RETURN '['||self.oid||']';
    END to_string;
END;
/
-- end base_t body;
SPOOL OFF
QUIT
