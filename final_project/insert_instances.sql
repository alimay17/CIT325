/*
||  Name:         insert_instances.sql
||  Date:         28 Mar 2023
||  Purpose:      Insert objects into tolkien table
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
    oname => 'Dwarf',
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
    oname => 'Elf',
    name  => 'Feanor',
    genus => 'Elves',
    elfkind => 'Noldor')
);


-- Close the log file.
SPOOL OFF

QUIT