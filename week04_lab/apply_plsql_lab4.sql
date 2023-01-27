/*
||  Name:          apply_plsql_lab4.sql
||  Date:          26 Jan 2023
||  Author:	   Alice Smith
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Open log file.
SPOOL 'apply_plsql_lab4.txt'

-- display settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET FEEDBACK OFF

-- Enter your solution here.

-- create gift object
CREATE OR REPLACE TYPE gift IS OBJECT(
  day_name VARCHAR2(8),
  gift_name VARCHAR2(24)
);
/

DECLARE

  -- declare custom types
  TYPE list IS TABLE of VARCHAR2(8);
  TYPE gifts is TABLE of GIFT;

  -- initialize variables
  lv_ordinal_days LIST := list('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth');
  lv_gifts GIFTS := gifts(
    gift('and a', 'Partridge in a pear tree'),
    gift('Two','Turtle Doves'),
    gift('Three', 'French hens'),
    gift('Four', 'Calling birds'),
    gift('Five', 'Golden rings'),
    gift('Six', 'Geese a laying'),
    gift('Seven', 'Swans a swimming'),
    gift('Eight','Maids a milking'),
    gift('Nine','Ladies dancing'),
    gift('Ten','Lords a leaping'),
    gift('Eleven','Pipers piping'),
    gift('Twelve','Drummers drumming')
  ); 

BEGIN
  -- initial loop
  FOR i IN 1..lv_ordinal_days.COUNT LOOP
    dbms_output.put_line('On the ' || lv_ordinal_days(i) || ' day of Christmas');
    dbms_output.put_line('my true love sent to me:');

    -- second loop
    FOR x in REVERSE 1..i LOOP
      -- check for first time loop
      IF i != 1 THEN
        dbms_output.put_line('-'||lv_gifts(x).day_name||' '|| lv_gifts(x).gift_name);
      ELSE
        dbms_output.put_line('-A ' || lv_gifts(x).gift_name); 
      END IF;  
    END LOOP;

    dbms_output.put_line(CHR(13));
  END LOOP;

END;
/

-- Close log file.
SPOOL OFF
