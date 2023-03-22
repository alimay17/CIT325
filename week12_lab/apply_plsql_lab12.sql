/*
||  Name:          apply_plsql_lab12.sql
||  Date:          22 Mar 2023
||  Author:        Alice Smith
||  Purpose:       Complete 325 Chapter 13 lab.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab12.txt

-- conditionally drop any existing item_obj, item_tab
BEGIN
  FOR i IN (
    SELECT   type_name
    FROM     user_types
    WHERE    REGEXP_LIKE(type_name,'^item.*$','i')
    ORDER BY 1 DESC) LOOP  
      EXECUTE IMMEDIATE 'DROP TYPE '||i.type_name;
  END LOOP;
END;
/
-- create item_obj
CREATE OR REPLACE TYPE item_obj IS OBJECT(
  title         VARCHAR2(60),
  subtitle      VARCHAR2(60),
  RATING        VARCHAR2(8),
  release_date  DATE
);
/

-- create item_tab
CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/

-- verify creation
desc item_obj;
desc item_tab;

-- create item_list function
CREATE OR REPLACE FUNCTION item_list(
  pv_start_date DATE,
  pv_end_date   DATE := TRUNC(SYSDATE + 1)
) RETURN ITEM_TAB IS
  
  -- record to mirror item_obj
  TYPE item_rec IS RECORD(
    title         VARCHAR2(60),
    subtitle      VARCHAR2(60),
    rating        VARCHAR2(8),
    release_date  DATE
  );

  -- item row and table
  item_row ITEM_REC;
  item_set ITEM_TAB := item_tab();

  -- cursor and dynamic statement
  item_cur SYS_REFCURSOR;
  stmt VARCHAR2(2000);

  -- local variables
  lv_mpaa VARCHAR2(8) := 'MPAA';

  -- begin item_list
  BEGIN
    -- create dynamic stmt
    stmt := 'SELECT item_title as title,'||
            ' item_subtitle as subtitle,'||
            ' item_rating as rating,'||
            ' item_release_date as release_date FROM ITEM WHERE'||
            ' item_rating_agency = ' || dbms_assert.enquote_literal(lv_mpaa)||
            ' AND item_release_date BETWEEN :pv_start_date AND :pv_end_date';

    -- read into cursor
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date; 
    LOOP
      -- read into row
      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;

      -- save row to table as item_obj
      item_set.EXTEND;
      item_set(item_set.COUNT) := item_obj(
        title         => item_row.title,
        subtitle      => item_row.subtitle,
        rating        => item_row.rating,
        release_date  => item_row.release_date
      );
    END LOOP;

  RETURN item_set;
END item_list;
/

-- verify creation
desc item_list;

-- test item_list with start_date as 1 Jan 20000
SELECT title, rating 
FROM TABLE(item_list('01-JAN-2000'))
ORDER by 1, 2 ASC;


-- Close log file.
SPOOL OFF
