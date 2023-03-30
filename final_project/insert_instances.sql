/*
||  Name:         insert_instances.sql
||  Date:         28 Mar 2023
||  Purpose:      Create dwarf subtype
||  Author:       Alice Smith  
*/
-- Open the log file.
SPOOL 'logs/insert_instances.txt'

-- insert dwarf
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  dwarf_t( 
    oid   => 8,
    oname => 'DWARF',
    name  => 'Gimli',
    genus => 'Dwarves')
);


-- insert noldor
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  noldor_t( 
    oid   => 9,
    oname => 'ELF',
    name  => 'Feanor',
    genus => 'Elves',
    elfkind => 'Noldor')
);

list
show errors

-- Close the log file.
SPOOL OFF

QUIT