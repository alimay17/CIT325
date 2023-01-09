/*
   Name:   apply_plsql_lab2-2.sql
   Author: Alice Smith
   Date:   09-JAN-2023
*/

-- Put code that you call from other scripts here because they may create
-- their own log files. For example, you call other program scripts by
-- putting an "@" symbol before the name of a relative file name or a
-- fully qualified file name.


-- Open your log file and make sure the extension is ".txt".
-- ------------------------------------------------------------
-- Remove any spool filename and spool off command when you call
-- the script from a shell script.
-- ------------------------------------------------------------
SPOOL apply_plsql_lab2-2.txt

-- Add an environment command to allow PL/SQL to print to console.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- Put your code here, like this "Hello Whom!" program.

DECLARE
  lv_raw_input VARCHAR2(255);
  lv_input VARCHAR2(10);

BEGIN
  

  dbms_output.put_line('Hello '||'&Name');


EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/

-- Close your log file.
-- ------------------------------------------------------------
-- Remove any spool filename and spool off command when you call
-- the script from a shell script.
-- ------------------------------------------------------------
SPOOL OFF

-- Instruct the program to exit SQL*Plus, which you need when you call a
-- a program from the command line. Please make sure you comment the
-- following command when you want to remain inside the interactive
-- SQL*Plus connection.
-- QUIT;