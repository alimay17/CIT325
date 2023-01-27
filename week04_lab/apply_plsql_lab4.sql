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

CREATE OR REPLACE
  TYPE list IS TABLE of VARCHAR2(8);
CREATE OR REPLACE
  TYPE struct IS OBJECT(
    day_name VARCHAR2(8),
    gift_name VARCHAR2(24)
  );

  -- initialize variables
  lv_ordinal_days LIST := list('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth');
  lv_gifts STRUCT;

BEGIN
  FOR i IN 1..lv_ordinal_days.COUNT LOOP
    /* Print values right aligned. */
    dbms_output.put_line(i)
  END LOOP;

END;
/

-- Close log file.
SPOOL OFF

-- enable when running through bash script
-- QUIT