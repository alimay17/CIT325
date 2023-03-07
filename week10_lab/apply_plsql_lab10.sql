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

DROP TYPE base_t FORCE;


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
    ) RETURNS SELF AS RESULT,

    -- getters
    MEMBER FUNCTION get_oname RETURN VARCHAR2,
    MEMBER FUNCTION get_name  RETURN VARCHAR2,

    --setters
    MEMBER FUNCTION set_oname(oname VARCHAR2),

    -- other
    MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
/

SHOW ERRORS
DESC base_t

-- Close log file.
SPOOL OFF
