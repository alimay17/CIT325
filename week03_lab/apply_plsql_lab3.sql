/*
||  Name:          apply_plsql_lab3.sql
||  Date:          01 Jan 2023
||  Author:	       Alice Smith
||  Purpose:       Complete 325 Chapter 4 lab.
*/

-- Call seeding libraries.
/* @$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql */

-- Open log file.
SPOOL apply_plsql_lab3.txt

-- Enter your solution here.
DECLARE
  TYPE list IS TABLE OF VARCHAR2(100);
  TYPE three_type IS RECORD(
    xnum NUMBER,
    xdate DATE,
    xstring VARCHAR2(30)
  );

  lv_strings LIST;
  lv_three_type THREE_TYPE;

BEGIN
  -- get input
  lv_strings(1) := '&1';
  lv_strings(2) := '&2';
  lv_strings(3) := '&3';
  

  -- sort and assign input
  FOR i IN 1..lv_strings.COUNT LOOP
    dbms_output.put_line(lv_strings(i));
  -- display
  END LOOP;

END;
/

-- Close log file.
SPOOL OFF

QUIT
