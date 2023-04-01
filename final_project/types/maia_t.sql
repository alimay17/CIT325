/*
||  Name:         maia_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create maia subtype
||  Author:       Alice Smith  
*/

SPOOL 'logs/maia_t.txt'

DROP TYPE maia_t FORCE;

-- maia_t declaration
CREATE OR REPLACE TYPE maia_t UNDER base_t (
    -- properties unique to subtype
    name    VARCHAR2(30),
    genus   VARCHAR2(30),

    -- subtype constructor
    CONSTRUCTOR FUNCTION maia_t(
      name  VARCHAR2,
      genus VARCHAR2
    ) RETURN SELF AS RESULT,

    -- getters and setters
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,
    MEMBER FUNCTION get_genus RETURN VARCHAR2,
    MEMBER PROCEDURE set_name (name VARCHAR2),
    MEMBER PROCEDURE set_genus (genus VARCHAR2),

    -- other
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
/

-- maia_t object body
CREATE OR REPLACE TYPE BODY maia_t IS

    -- constructor
    CONSTRUCTOR FUNCTION maia_t(
      name  VARCHAR2,
      genus VARCHAR2
    ) RETURN SELF AS RESULT IS
      BEGIN
        self.name  := name;
        self.genus := genus;
      RETURN;
    END;

    -- getters and setters
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
      BEGIN
      RETURN self.name;
    END get_name;

    MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
        BEGIN
        RETURN self.genus;
    END get_genus;

    MEMBER PROCEDURE set_name(name VARCHAR2) IS
      BEGIN
        self.name := name;
    END set_name;

    MEMBER PROCEDURE set_genus(genus VARCHAR2) IS
      BEGIN
          self.genus := genus;
    END set_genus;

    -- other
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
      BEGIN
      RETURN (self AS base_t).to_string()||'['||self.name||']'||'['||self.genus||']';
    END to_string;
END;
/

SPOOL OFF 
QUIT

