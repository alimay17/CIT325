/*
||  Name:       create_tolkien.sql
||  Date:       28 Mar 2023
||  Purpose:    Build tolkien table and sequence
||  Author:     Michael McLaughlin
*/

SET PAGESIZE 999
SPOOL 'logs/create_tolkien.txt'

-- drop table and sequence if it exists
BEGIN
  FOR i IN (
    SELECT 
      o.object_name,
      o.object_type
	    FROM   user_objects o
	    WHERE  o.object_name IN ('TOLKIEN','TOLKIEN_S')) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    ELSIF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    END IF;
  END LOOP;
END;
/

-- create tolkien table & sequence
CREATE TABLE tolkien(
  tolkien_id NUMBER,
  tolkien_character base_t
);

CREATE SEQUENCE tolkien_s START WITH 1001;

-- close spool and exit
SPOOL OFF
QUIT