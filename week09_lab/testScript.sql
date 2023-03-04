/*
||  Name:          testScript.sql
||  Date:          28 Feb 2023
||  Purpose:       Test components seperatly before adding to full
*/

-- logfile
SPOOL 'logs/testScript.txt'

-- environment settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DROP PROCEDURE update_item_description;

CREATE OR REPLACE PROCEDURE update_item_description(pv_item_title VARCHAR2) IS

  CURSOR get_item(cv_lookup_string VARCHAR2) IS
    SELECT i.item_id, i.item_title, i.text_file_name
    FROM item i
    INNER JOIN file_list f ON f.file_name = i.text_file_name
    WHERE i.item_title LIKE '%' || cv_lookup_string || '%';

  BEGIN

  FOR i IN get_item(pv_item_title) LOOP
    load_clob_from_file(
      src_file_name     => i.text_file_name,
      table_name        => 'ITEM',
      column_name       => 'ITEM_DESC',
      primary_key_name  => 'ITEM_ID',
      primary_key_value => TO_CHAR(i.item_id)
    );
  END LOOP;

  -- handle exceptions
  EXCEPTION 
    WHEN OTHERS THEN
      dbms_output.put_line('Unable to update descriptions');

END;
/

-- test 
EXECUTE update_item_description('Harry Potter');

COL item_id     FORMAT 9999
COL item_title  FORMAT A44
COL text_size   FORMAT 999,999
SET PAGESIZE 99
SELECT   item_id
,        item_title
,        LENGTH(item_desc) AS text_size
FROM     item
WHERE    REGEXP_LIKE(item_title,'^Harry Potter.*$')
AND      item_type IN
        (SELECT common_lookup_id
        FROM   common_lookup
        WHERE  common_lookup_table = 'ITEM'
        AND    common_lookup_column = 'ITEM_TYPE'
        AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'))
ORDER BY item_id;

-- LIST
SPOOL OFF