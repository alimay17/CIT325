/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab5.txt

/* new rating_agency_s sequence */
DROP sequence rating_agency_s;
CREATE sequence rating_agency_s
  START WITH 1001
  MINVALUE 1001
  INCREMENT BY 1
ORDER;

/* new rating_agency table */
DROP TABLE rating_agency;
CREATE TABLE rating_agency AS
SELECT 
  rating_agency_s.NEXTVAL AS rating_agency_id,
  il.item_rating AS rating,
  il.item_rating_agency AS rating_agency
FROM (
  SELECT DISTINCT
    i.item_rating,
    i.item_rating_agency
  FROM   item i
) il;

/* alter item table to add rating_agency_id */
ALTER TABLE item
  ADD rating_agency_id NUMBER;

/* validate item table */
SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   
  table_name,
  column_id,
  column_name,
  CASE
    WHEN nullable = 'N' 
      THEN 'NOT NULL' 
    ELSE ''
  END AS nullable,
  CASE
    WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') 
      THEN data_type||'('||data_length||')'
    ELSE data_type
  END AS data_type
FROM  user_tab_columns
WHERE table_name = 'ITEM'
ORDER BY 2;

/* clean database */
DROP TYPE rating_agency_obj FORCE;

/* rating_agency object */
CREATE OR REPLACE 
  TYPE rating_agency_obj IS OBJECT(
    rating_agency_id NUMBER,
    rating VARCHAR2(8),
    rating_agency VARCHAR2(4)
  );
/

/* rating_agency object collection */
CREATE OR REPLACE
  TYPE rating_agency_tab IS TABLE OF rating_agency_obj;
/

/**************************************************
  Read data from one table into local collection 
  to update another table
**************************************************/
DECLARE
  /* rating_agency cursor */
  CURSOR rating_agency_cur IS
    SELECT * FROM rating_agency;

  /* local rating agency collection */
  lv_rating_agency_tab RATING_AGENCY_TAB := rating_agency_tab();

BEGIN
  /* assign cursor to local collection */
  FOR i IN rating_agency_cur LOOP
    lv_rating_agency_tab.EXTEND;
    lv_rating_agency_tab(lv_rating_agency_tab.COUNT) :=
      rating_agency_obj(
        i.rating_agency_id,
        i.rating,
        i.rating_agency
      );
    
  END LOOP;

  /* update item table from local collection */
  FOR i in 1..lv_rating_agency_tab.COUNT LOOP
    UPDATE item 
      SET rating_agency_id = lv_rating_agency_tab(i).rating_agency_id
      WHERE item_rating = lv_rating_agency_tab(i).rating 
        AND item_rating_agency = lv_rating_agency_tab(i).rating_agency;
  END LOOP;
  COMMIT; 
END;
/

-- Close log file.
SPOOL OFF