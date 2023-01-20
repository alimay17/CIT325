/*
||  Name:          apply_plsql_lab3.sql
||  Date:          01 Jan 2023
||  Author:	   Alice Smith
||  Purpose:       Complete 325 Chapter 4 lab.
*/

<<<<<<< HEAD
-- Open log file.
-- SPOOL apply_plsql_lab3.txt
=======
-- Open log file & verify setting
SPOOL apply_plsql_lab3.txt
>>>>>>> ef4e9772b2ff54928dcd89057c58b76d6883094f
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

  lv_input LIST;
  lv_three_type THREE_TYPE;

BEGIN
  -- get input
  lv_input := list('&1','&2', '&3');
  
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

  dbms_output.put_line('Record ['||lv_three_type.xnum||']'||'['||lv_three_type.xstring||']'||'['||lv_three_type.xdate||']');

END;
/

-- Close log file.
--SPOOL OFF

-- enable when running through bash script
QUIT
