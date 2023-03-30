/*
||  Name:         insert_instances.sql
||  Date:         28 Mar 2023
||  Purpose:      Create dwarf subtype
||  Author:       Alice Smith  
*/
-- Open the log file.
SPOOL 'logs/insert_instances.txt'


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

list
show errors

-- Close the log file.
SPOOL OFF

QUIT;