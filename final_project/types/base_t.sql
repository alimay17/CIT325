/*
||  Name:         base_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create base type for final project
||  Author:       Alice Smith  
*/

DROP type base_t;

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

LIST;
SHOW ERRORS;

-- base_t object body
-- CREATE OR REPLACE TYPE BODY base_t IS

--     -- constructors
--     CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
--         BEGIN
--             self.oname := 'BASE_T';
--         RETURN;
--     END;

--     CONSTRUCTOR FUNCTION base_t(
--         oname VARCHAR2,
--         name VARCHAR2
--     ) RETURN SELF AS RESULT IS
--         BEGIN
--             IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
--                 self.name := name;
--             END IF;
--         RETURN;
--     END;

--     -- getters and setters
--     MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
--         BEGIN
--         RETURN self.oname;
--     END get_oname;

--     MEMBER FUNCTION get_name RETURN VARCHAR2 IS
--         BEGIN
--         RETURN self.name;
--     END get_name;

--     MEMBER PROCEDURE set_oname(oname VARCHAR2) IS
--         BEGIN
--             self.oname := oname;
--     END set_oname;

--     -- other
--     MEMBER FUNCTION to_string RETURN VARCHAR2 IS
--         BEGIN
--         RETURN '['||self.oname||']';
--     END to_string;
-- END;
-- /
-- end base_t body
