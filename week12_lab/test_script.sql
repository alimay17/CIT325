-- Open log file.
SPOOL 'logs/test_script_lab12.txt'
SET SERVEROUTPUT ON SIZE UNLIMITED

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


LIST
SHOW ERRORS;


SPOOL OFF