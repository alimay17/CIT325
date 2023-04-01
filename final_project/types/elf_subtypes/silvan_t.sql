/*
||  Name:         silvan_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create silvan elf subtype
||  Author:       Alice Smith  
*/

SPOOL 'logs/silvan_t.txt'

-- silvan_t declaration
CREATE OR REPLACE TYPE silvan_t UNDER elf_t (
    -- properties unique to subtype
    elfkind VARCHAR2(30),

    -- subtype constructor
    CONSTRUCTOR FUNCTION silvan_t(
      elfkind VARCHAR2
    ) RETURN SELF AS RESULT,

    -- getters and setters
    MEMBER FUNCTION get_elfkind RETURN VARCHAR2,
    MEMBER PROCEDURE set_elfkind (elfkind VARCHAR2),

    -- other
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
/

-- silvan_t object body
CREATE OR REPLACE TYPE BODY silvan_t IS

    -- constructor
    CONSTRUCTOR FUNCTION silvan_t(
      elfkind VARCHAR2
    ) RETURN SELF AS RESULT IS
      BEGIN
        self.elfkind := elfkind;
      RETURN;
    END;

    -- getters and setters
    MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
        BEGIN
        RETURN self.elfkind;
    END get_elfkind;

    MEMBER PROCEDURE set_elfkind(elfkind VARCHAR2) IS
      BEGIN
        self.elfkind := elfkind;
    END set_elfkind;

    -- other
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
      BEGIN
      RETURN (self AS elf_t).to_string()||'['||self.elfkind||']';
    END to_string;
END;
/

SPOOL OFF 
QUIT

