/*
||  Name:          apply_plsql_lab4.sql
||  Date:          26 Jan 2023
||  Author:	   Alice Smith
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab4.txt

-- display settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- Enter your solution here.
DECLARE

BEGIN
  dbms_output.put_line('hello World');
END;
/
-- Close log file.
SPOOL OFF

-- enable when running through bash script
-- QUIT
