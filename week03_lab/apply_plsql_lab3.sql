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

SET SERVEROUTPUT ON SIZE UNLIMITED
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
  lv_strings := list('&1','&2', '&3');
  
  -- sort and assign input
  FOR i IN 1..lv_strings.COUNT LOOP
    IF lv_strings(i)  
  
  -- display
  END LOOP;

END;
/

-- Close log file.
SPOOL OFF

-- QUIT
