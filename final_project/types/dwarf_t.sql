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

-- base_t object body
CREATE OR REPLACE TYPE BODY dwarf_t IS

    -- constructor
    CONSTRUCTOR FUNCTION dwarf_t(
        name  VARCHAR2,
        genus VARCHAR2
    ) RETURN SELF AS RESULT IS
        BEGIN
            self.name  := name;
            self.genus := genus;
        RETURN;
    END;

    -- getters and setters
    MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
        BEGIN
        RETURN self.genus;
    END get_genus;

    MEMBER PROCEDURE set_genus(genus VARCHAR2) IS
        BEGIN
            self.genus := genus;
    END set_genus;

    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
        BEGIN
        RETURN self.name;
    END get_name;

    MEMBER PROCEDURE set_name(name VARCHAR2) IS
        BEGIN
            self.name := name;
    END set_name;

END;
/
list;
SHOW ERRORS;

