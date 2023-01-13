/*
   Name:   apply_plsql_lab2-2.sql
   Author: Alice Smith
   Date:   09-JAN-2023
*/

-- Open log file 
-- ------------------------------------------------------------
-- Remove any spool filename and spool off command when you call
-- the script from a shell script.
-- ------------------------------------------------------------
-- SPOOL apply_plsql_lab2-2.txt

-- Add an environment command to allow PL/SQL to print to console.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- Put your code here, like this "Hello Whom!" program.

-- MAIN
DECLARE
  lv_raw_input VARCHAR2(255);
  lv_input VARCHAR2(255);

BEGIN
  
  lv_raw_input := '&1';

  IF LENGTH(lv_raw_input) > 10 THEN
    lv_input := SUBSTR(lv_raw_input, 1, 10);
  ELSIF LENGTH(lv_raw_input) <=10 THEN
    lv_input := lv_raw_input;
  ELSE 
    lv_input := 'World!'; 
  END IF;
   dbms_output.put_line('Hello '||lv_input);
END;
/

-- Close log file.
-- SPOOL OFF

QUIT;
