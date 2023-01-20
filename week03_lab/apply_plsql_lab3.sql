/*
||  Name:          apply_plsql_lab3.sql
||  Date:          01 Jan 2023
||  Author:	   Alice Smith
||  Purpose:       Complete 325 Chapter 4 lab.
*/

<<<<<<< HEAD
-- Open log file.
-- SPOOL apply_plsql_lab3.txt
<<<<<<< Updated upstream
=======
-- Open log file & verify setting
SPOOL apply_plsql_lab3.txt
>>>>>>> ef4e9772b2ff54928dcd89057c58b76d6883094f
=======

-- display settings
>>>>>>> Stashed changes
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- Enter your solution here.
DECLARE
  TYPE list IS TABLE OF VARCHAR2(100);
  TYPE three_type IS RECORD(
    xnum NUMBER,
    xdate DATE,
    xstring VARCHAR2(30)
 );

  lv_input LIST := list();
  lv_three_type THREE_TYPE;

  lv_input1 VARCHAR(100);
  lv_input2 VARCHAR(100);
  lv_input3 VARCHAR(100);

BEGIN
  -- get input
  lv_input1 := '&1';
  lv_input.EXTEND;
  lv_input(lv_input.COUNT) := lv_input1;
  lv_input.EXTEND;
  lv_input(lv_input.COUNT) := '&2';
  lv_input.EXTEND;
  lv_input(lv_input.COUNT) := '&3';
  

  -- sort and assign input
  FOR i IN 1..lv_input.COUNT LOOP
    -- number
    IF REGEXP_LIKE(lv_input(i), '^[[:digit:]]*$') THEN
      lv_three_type.xnum := lv_input(i);

    -- string
    ELSIF REGEXP_LIKE(lv_input(i),'^[[:alnum:]]*$') THEN
      lv_three_type.xstring := lv_input(i);

    -- date
    ELSIF  verify_date(lv_input(i)) IS NOT NULL THEN
      lv_three_type.xdate := lv_input(i);
    END IF;
  END LOOP;

 -- display final result
  dbms_output.put_line('Record ['||lv_three_type.xnum||']'||'['||lv_three_type.xstring||']'||'['||lv_three_type.xdate||']');

END;
/

-- Close log file.
-- SPOOL OFF

-- enable when running through bash script
 QUIT
