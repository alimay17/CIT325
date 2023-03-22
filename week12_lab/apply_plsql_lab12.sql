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

/*
|| Part 1 - Create item_obj(custom object) & item_tab(table of custom objects)
*/

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
/* ||  END Part 1 || */

/*
|| Part 2 - Create item_list function
*/



/* ||  END Part 2 || */


/*
|| Part 3 - Test Queries
*/

/* ||  END Part 3 || */


-- Close log file.
SPOOL OFF
