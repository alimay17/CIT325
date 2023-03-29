/*
||  Name:         base_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create dwarf subtype
||  Author:       Alice Smith  
*/

CREATE OR REPLACE TYPE dwarf_t UNDER base_t (
    -- properties unique to subtype
    name  VARCHAR2(30),
    genus VARCHAR2(30),

    -- subtype constructor
    CONSTRUCTOR FUNCTION dwarf_t(
        name  VARCHAR2,
        genus VARCHAR2
    ) RETURN SELF AS RESULT,

    -- overriding members
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,

    -- custom members
    MEMBER FUNCTION get_genus RETURN VARCHAR2,
    MEMBER PROCEDURE set_genus (genus VARCHAR2),
    MEMBER PROCEDURE set_name (name VARCHAR2)
) INSTANTIABLE NOT FINAL;
/

list;
SHOW ERRORS;

