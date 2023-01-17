/*
||  Name:          week03.sql
||  Date:          11 Nov 2016
||  Author:	   Alice Smith
||  Purpose:       Practice week 3 concepts.
*/


SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
  -- TYPE list IS TABLE of VARCHAR2(10);
  -- lv_strings LIST := list('10','Ten','Twelve12');
  
  TYPE list IS TABLE of VARCHAR2(12);
  lv_strings LIST := list('10','Ten','Twelve12','17-MAY-1988');

-- BEGIN
 -- FOR i IN 1..lv_strings.COUNT LOOP
   -- IF REGEXP_LIKE(lv_strings(i), '^[[:digit:]]*$') THEN
     -- dbms_output.put_line('Print Number ['||lv_strings(i)||']');
   -- END IF;
   -- END LOOP;
-- END;

BEGIN
  FOR i IN 1..lv_strings.COUNT LOOP
    IF REGEXP_LIKE(lv_strings(i), '^[[:digit:]]*$') OR
       VERIFY_DATE(lv_strings(i)) OR
     --  REGEXP_LIKE(lv_strings(i),'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') OR
       REGEXP_LIKE(lv_strings(i),'^[[:alnum:]]*$') THEN
    	
      dbms_output.put_line('Print Number ['||lv_strings(i)||']');
    END IF;
  END LOOP;
END;
/
