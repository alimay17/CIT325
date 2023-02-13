/*
||  Name:          apply_plsql_lab7.sql
||  Date:          15 Feb 2023
||  Author:        Alice Smith
||  Purpose:       Complete 325 Chapter 8 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- environment settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
-- SET FEEDBACK OFF

/*
|| Part 1 - All or nothing insert_contact procedure 
*/

CREATE OR REPLACE PROCEDURE insert_contact(
  pv_first_name VARCHAR2
) IS

BEGIN
  NULL;
END;
/

/*
|| Part 2 - Convert insert_contact procedure from definer to invoker rights 
*/

/*
|| Part 3 - Convert insert_contact procedure from invoker to autonomous definer rights function
|| returns NUMBER 1 if success, 0 if not
*/

/*
|| Part 4 - get_contact object table function using a contact_obj, contact_tab setup 
|| returns complete list of persons format: 'first, middle, last'
*/

-- Close log file.

SPOOL OFF
