/*
||  Name:         teleri_t.sql
||  Date:         28 Mar 2023
||  Purpose:      Create teleri elf subtype
||  Author:       Alice Smith  
*/

SPOOL 'logs/teleri_t.txt'

DROP TYPE teleri_t FORCE;

-- teleri_t declaration
CREATE OR REPLACE TYPE teleri_t UNDER elf_t (
    -- properties unique to subtype
    elfkind VARCHAR2(30),

    -- subtype constructor
    CONSTRUCTOR FUNCTION teleri_t(
      elfkind VARCHAR2
    ) RETURN SELF AS RESULT,

    -- getters and setters
    MEMBER FUNCTION get_elfkind RETURN VARCHAR2,
    MEMBER PROCEDURE set_elfkind (elfkind VARCHAR2),

    -- other
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
) INSTANTIABLE NOT FINAL;
/

-- teleri_t object body
CREATE OR REPLACE TYPE BODY teleri_t IS

    -- constructor
    CONSTRUCTOR FUNCTION teleri_t(
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

