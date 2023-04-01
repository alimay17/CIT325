/*
||  Name:         insert_instances.sql
||  Date:         28 Mar 2023
||  Purpose:      Insert objects into tolkien table
||  Author:       Alice Smith  
*/
-- Open the log file.
SPOOL 'logs/insert_instances.txt'

-- insert man
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  man_t( 
    oid   => 1,
    oname => 'Man',
    name  => 'Boromir',
    genus => 'Men'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  man_t( 
    oid   => 2,
    oname => 'Man',
    name  => 'Faramir',
    genus => 'Men'
  )
);

-- insert hobbit
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  hobbit_t( 
    oid   => 3,
    oname => 'Hobbit',
    name  => 'Bilbo',
    genus => 'Hobbits'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  hobbit_t( 
    oid   => 4,
    oname => 'Hobbit',
    name  => 'Frodo',
    genus => 'Hobbits'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  hobbit_t( 
    oid   => 5,
    oname => 'Hobbit',
    name  => 'Merry',
    genus => 'Hobbits'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  hobbit_t( 
    oid   => 6,
    oname => 'Hobbit',
    name  => 'Pippin',
    genus => 'Hobbits'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  hobbit_t( 
    oid   => 7,
    oname => 'Hobbit',
    name  => 'Samwise',
    genus => 'Hobbits'
  )
);

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

-- insert orc
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  man_t( 
    oid   => 15,
    oname => 'Orc',
    name  => 'Azog the Defiler',
    genus => 'Orcs'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  man_t( 
    oid   => 16,
    oname => 'Orc',
    name  => 'Bolg',
    genus => 'Orcs'
  )
);

-- insert Maia
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  maia_t( 
    oid   => 17,
    oname => 'Maia',
    name  => 'Gandalf the Grey',
    genus => 'Maiar'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  maia_t( 
    oid   => 18,
    oname => 'Maia',
    name  => 'Radagast the Brown',
    genus => 'Maiar'
  )
);

INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  maia_t( 
    oid   => 19,
    oname => 'Maia',
    name  => 'Saruman the White',
    genus => 'Maiar'
  )
);

-- insert goblin
INSERT INTO tolkien( 
  tolkien_id,
  tolkien_character
) VALUES (
  tolkien_s.NEXTVAL,
  goblin_t( 
    oid   => 20,
    oname => 'Goblin',
    name  => 'The Great Goblin',
    genus => 'Goblins'
  )
);


-- Close the log file.
SPOOL OFF

QUIT