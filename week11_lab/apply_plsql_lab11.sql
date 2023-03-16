/*
||  Name:          apply_plsql_lab11.sql
||  Date:          14 Mar 2023
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

/* Call seeding libraries */
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab11.txt
SET SERVEROUTPUT ON SIZE UNLIMITED

-- add text_file_name column to item table
ALTER TABLE item
  ADD (text_file_name VARCHAR2(40));

/* Clean up database */
DROP TABLE logger;
DROP SEQUENCE logger_s;

/*
|| Part 1 - Create and test logger table
*/
-- create logger table and sequence
CREATE TABLE logger(
    LOGGER_ID               NUMBER,
    OLD_ITEM_ID		          NUMBER,
    OLD_ITEM_BARCODE		    VARCHAR2(20),
    OLD_ITEM_TYPE			      NUMBER,
    OLD_ITEM_TITLE 			    VARCHAR2(60),
    OLD_ITEM_SUBTITLE		    VARCHAR2(60),
    OLD_ITEM_RATING				  VARCHAR2(8),
    OLD_ITEM_RATING_AGENCY 	VARCHAR2(4),
    OLD_ITEM_RELEASE_DATE		DATE,
    OLD_CREATED_BY 					NUMBER,
    OLD_CREATION_DATE				DATE,
    OLD_LAST_UPDATED_BY			NUMBER,
    OLD_LAST_UPDATE_DATE		DATE,
    OLD_TEXT_FILE_NAME			VARCHAR2(40),
    NEW_ITEM_ID							NUMBER,
    NEW_ITEM_BARCODE				VARCHAR2(20),
    NEW_ITEM_TYPE						NUMBER,
    NEW_ITEM_TITLE 				  VARCHAR2(60),
    NEW_ITEM_SUBTITLE				VARCHAR2(60),
    NEW_ITEM_RATING				  VARCHAR2(8),
    NEW_ITEM_RATING_AGENCY 	VARCHAR2(4),
    NEW_ITEM_RELEASE_DATE		DATE,
    NEW_CREATED_BY 				  NUMBER,
    NEW_CREATION_DATE				DATE,
    NEW_LAST_UPDATED_BY			NUMBER,
    NEW_LAST_UPDATE_DATE		DATE,
    NEW_TEXT_FILE_NAME	    VARCHAR2(40)
);
CREATE SEQUENCE logger_s;

-- check table creation
DESC logger;

-- test insert into logger table
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';

    lv_log_id NUMBER;
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
    lv_log_id := logger_s.NEXTVAL;
    
    INSERT INTO logger (
      logger_id,
      old_item_id,
      old_item_title,
      new_item_id,
      new_item_title
    )VALUES(
      lv_log_id,
      i.item_id,
      i.item_title,
      i.item_id,
      i.item_title
    );
  END LOOP;
END;
/

-- verify test insert
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/* ||  END Part 1 || */

/*
|| Part 2 - create manage_item package
|| includes 3 overloaded item_insert procedures
*/

-- package declaration
CREATE OR REPLACE PACKAGE manage_item IS

  -- item insert 1 (update item)
  PROCEDURE item_insert(
    pv_new_item_id            NUMBER,			
    pv_new_item_barcode       VARCHAR2,			
    pv_new_item_type          NUMBER,			
    pv_new_item_title         VARCHAR2,			
    pv_new_item_subtitle      VARCHAR2,			
    pv_new_item_rating        VARCHAR2,			
    pv_new_item_rating_agency VARCHAR2,			
    pv_new_item_release_date  DATE,			
    pv_new_created_by         NUMBER,				
    pv_new_creation_date      DATE,				
    pv_new_updated_by         NUMBER,				
    pv_new_update_date        DATE,				
    pv_new_text_file_name     VARCHAR2,
    pv_old_item_id            NUMBER,			
    pv_old_item_barcode       VARCHAR2,			
    pv_old_item_type          NUMBER,			
    pv_old_item_title         VARCHAR2,			
    pv_old_item_subtitle      VARCHAR2,			
    pv_old_item_rating        VARCHAR2,			
    pv_old_item_rating_agency VARCHAR2,			
    pv_old_item_release_date  DATE,			
    pv_old_created_by         NUMBER,				
    pv_old_creation_date      DATE,				
    pv_old_updated_by         NUMBER,				
    pv_old_update_date        DATE,				
    pv_old_text_file_name     VARCHAR2
  );

  -- item_insert 2 (add new item)
  PROCEDURE item_insert(
    pv_new_item_id            NUMBER,			
    pv_new_item_barcode       VARCHAR2,			
    pv_new_item_type          NUMBER,			
    pv_new_item_title         VARCHAR2,			
    pv_new_item_subtitle      VARCHAR2,			
    pv_new_item_rating        VARCHAR2,			
    pv_new_item_rating_agency VARCHAR2,			
    pv_new_item_release_date  DATE,			
    pv_new_created_by         NUMBER,				
    pv_new_creation_date      DATE,				
    pv_new_updated_by         NUMBER,				
    pv_new_update_date        DATE,				
    pv_new_text_file_name     VARCHAR2
  );

  --item_insert 3 (delete item)
  PROCEDURE item_insert(
    pv_old_item_id            NUMBER,			
    pv_old_item_barcode       VARCHAR2,			
    pv_old_item_type          NUMBER,			
    pv_old_item_title         VARCHAR2,			
    pv_old_item_subtitle      VARCHAR2,			
    pv_old_item_rating        VARCHAR2,			
    pv_old_item_rating_agency VARCHAR2,			
    pv_old_item_release_date  DATE,			
    pv_old_created_by         NUMBER,				
    pv_old_creation_date      DATE,				
    pv_old_updated_by         NUMBER,				
    pv_old_update_date        DATE,				
    pv_old_text_file_name     VARCHAR2
  );

END manage_item; -- end package declaration
/

-- package body
CREATE OR REPLACE PACKAGE BODY manage_item IS
    -- item insert 1 (update item)
  PROCEDURE item_insert(
    pv_new_item_id            NUMBER,			
    pv_new_item_barcode       VARCHAR2,			
    pv_new_item_type          NUMBER,			
    pv_new_item_title         VARCHAR2,			
    pv_new_item_subtitle      VARCHAR2,			
    pv_new_item_rating        VARCHAR2,			
    pv_new_item_rating_agency VARCHAR2,			
    pv_new_item_release_date  DATE,			
    pv_new_created_by         NUMBER,				
    pv_new_creation_date      DATE,				
    pv_new_updated_by         NUMBER,				
    pv_new_update_date        DATE,				
    pv_new_text_file_name     VARCHAR2,
    pv_old_item_id            NUMBER,			
    pv_old_item_barcode       VARCHAR2,			
    pv_old_item_type          NUMBER,			
    pv_old_item_title         VARCHAR2,			
    pv_old_item_subtitle      VARCHAR2,			
    pv_old_item_rating        VARCHAR2,			
    pv_old_item_rating_agency VARCHAR2,			
    pv_old_item_release_date  DATE,			
    pv_old_created_by         NUMBER,				
    pv_old_creation_date      DATE,				
    pv_old_updated_by         NUMBER,				
    pv_old_update_date        DATE,				
    pv_old_text_file_name     VARCHAR2
  ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
      INSERT INTO logger(
        logger_id,
        new_item_id,			
        new_item_barcode,			
        new_item_type,			
        new_item_title,			
        new_item_subtitle,			
        new_item_rating,			
        new_item_rating_agency,			
        new_item_release_date,			
        new_created_by,				
        new_creation_date,				
        new_last_updated_by,				
        new_last_update_date,				
        new_text_file_name,
        old_item_id,			
        old_item_barcode,			
        old_item_type,			
        old_item_title,			
        old_item_subtitle,			
        old_item_rating,			
        old_item_rating_agency,			
        old_item_release_date,			
        old_created_by,				
        old_creation_date,				
        old_last_updated_by,				
        old_last_update_date,				
        old_text_file_name
      )VALUES(
        logger_s.NEXTVAL,
        pv_new_item_id,			
        pv_new_item_barcode,			
        pv_new_item_type,			
        pv_new_item_title,			
        pv_new_item_subtitle,			
        pv_new_item_rating,			
        pv_new_item_rating_agency,			
        pv_new_item_release_date,			
        pv_new_created_by,				
        pv_new_creation_date,				
        pv_new_updated_by,				
        pv_new_update_date,				
        pv_new_text_file_name,
        pv_old_item_id,			
        pv_old_item_barcode,			
        pv_old_item_type,			
        pv_old_item_title,			
        pv_old_item_subtitle,			
        pv_old_item_rating,			
        pv_old_item_rating_agency,			
        pv_old_item_release_date,			
        pv_old_created_by,				
        pv_old_creation_date,				
        pv_old_updated_by,				
        pv_old_update_date,				
        pv_old_text_file_name
      );
      COMMIT;
  END;
  -- end item_insert 1 (update item)

  -- item_insert 2 (add new item)
  PROCEDURE item_insert(
    pv_new_item_id            NUMBER,			
    pv_new_item_barcode       VARCHAR2,			
    pv_new_item_type          NUMBER,			
    pv_new_item_title         VARCHAR2,			
    pv_new_item_subtitle      VARCHAR2,			
    pv_new_item_rating        VARCHAR2,			
    pv_new_item_rating_agency VARCHAR2,			
    pv_new_item_release_date  DATE,			
    pv_new_created_by         NUMBER,				
    pv_new_creation_date      DATE,				
    pv_new_updated_by         NUMBER,				
    pv_new_update_date        DATE,				
    pv_new_text_file_name     VARCHAR2
  )IS 
    BEGIN
      item_insert(
        pv_new_item_id            => pv_new_item_id,
        pv_new_item_barcode       => pv_new_item_barcode,
        pv_new_item_type          => pv_new_item_type,
        pv_new_item_title         => pv_new_item_title,
        pv_new_item_subtitle      => pv_new_item_subtitle,
        pv_new_item_rating        => pv_new_item_rating,
        pv_new_item_rating_agency => pv_new_item_rating_agency,
        pv_new_item_release_date  => pv_new_item_release_date,
        pv_new_created_by         => pv_new_created_by,
        pv_new_creation_date      => pv_new_creation_date,
        pv_new_updated_by         => pv_new_updated_by,
        pv_new_update_date        => pv_new_update_date,
        pv_new_text_file_name     => pv_new_text_file_name,
        pv_old_item_id            => NULL,
        pv_old_item_barcode       => NULL,
        pv_old_item_type          => NULL,
        pv_old_item_title         => NULL,
        pv_old_item_subtitle      => NULL,	
        pv_old_item_rating        => NULL,
        pv_old_item_rating_agency => NULL,
        pv_old_item_release_date  => NULL,
        pv_old_created_by         => NULL,
        pv_old_creation_date      => NULL,
        pv_old_updated_by         => NULL,
        pv_old_update_date        => NULL,
        pv_old_text_file_name     => NULL
      );
  END;
  -- end item_insert 2 (add new item)

  -- item_insert 3 (delete item)
  PROCEDURE item_insert(
    pv_old_item_id            NUMBER,			
    pv_old_item_barcode       VARCHAR2,			
    pv_old_item_type          NUMBER,			
    pv_old_item_title         VARCHAR2,			
    pv_old_item_subtitle      VARCHAR2,			
    pv_old_item_rating        VARCHAR2,			
    pv_old_item_rating_agency VARCHAR2,			
    pv_old_item_release_date  DATE,			
    pv_old_created_by         NUMBER,				
    pv_old_creation_date      DATE,				
    pv_old_updated_by         NUMBER,				
    pv_old_update_date        DATE,				
    pv_old_text_file_name     VARCHAR2
  ) IS
    BEGIN
      item_insert(
        pv_old_item_id            => pv_old_item_id,
        pv_old_item_barcode       => pv_old_item_barcode,
        pv_old_item_type          => pv_old_item_type,
        pv_old_item_title         => pv_old_item_title,
        pv_old_item_subtitle      => pv_old_item_subtitle,
        pv_old_item_rating        => pv_old_item_rating,
        pv_old_item_rating_agency => pv_old_item_rating_agency,
        pv_old_item_release_date  => pv_old_item_release_date,
        pv_old_created_by         => pv_old_created_by,
        pv_old_creation_date      => pv_old_creation_date,
        pv_old_updated_by         => pv_old_updated_by,
        pv_old_update_date        => pv_old_update_date,
        pv_old_text_file_name     => pv_old_text_file_name,
        pv_new_item_id            => NULL,
        pv_new_item_barcode       => NULL,
        pv_new_item_type          => NULL,
        pv_new_item_title         => NULL,
        pv_new_item_subtitle      => NULL,	
        pv_new_item_rating        => NULL,
        pv_new_item_rating_agency => NULL,
        pv_new_item_release_date  => NULL,
        pv_new_created_by         => NULL,
        pv_new_creation_date      => NULL,
        pv_new_updated_by         => NULL,
        pv_new_update_date        => NULL,
        pv_new_text_file_name     => NULL
      );
  END;
  -- end item_insert 3 (delete item)

END manage_item; -- end package body
/
/* ||  END Part 2 || */

/*
|| Part 3 - create triggers
*/

-- trigger 1 - item_trig (add or update item)
CREATE OR REPLACE TRIGGER item_trig
  BEFORE INSERT OR UPDATE OF item_title ON item
  FOR EACH ROW WHEN (REGEXP_LIKE(NEW.item_title, ':'))

  DECLARE
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
    lv_input_title VARCHAR2(60);
    
  BEGIN
    IF INSERTING THEN
      lv_input_title := substr(:NEW.item_title, 1, 60);

      -- has colon but no subtitle
      IF REGEXP_INSTR(lv_input_title,':') > 0 AND
         REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
        -- remove colon
        :NEW.item_title := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);

      -- has colon with subtitle
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
        -- split into title and subtitle
        :NEW.item_title := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        :NEW.item_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
      
      -- no colon and no subtitle assign as is
      ELSE
        :NEW.item_title := lv_input_title;
      END IF;

      manage_item.item_insert(
        pv_new_item_id             => :NEW.item_id,
        pv_new_item_barcode        => :NEW.item_barcode,
        pv_new_item_type           => :NEW.item_type,
        pv_new_item_title          => :NEW.item_title,
        pv_new_item_subtitle       => :NEW.item_subtitle,	
        pv_new_item_rating         => :NEW.item_rating,
        pv_new_item_rating_agency  => :NEW.item_rating_agency,
        pv_new_item_release_date   => :NEW.item_release_date,
        pv_new_created_by          => :NEW.created_by,
        pv_new_creation_date       => :NEW.creation_date,
        pv_new_updated_by     => :NEW.last_updated_by,
        pv_new_update_date    => :NEW.last_update_date,
        pv_new_text_file_name      => :NEW.text_file_name
      );

    ELSIF UPDATING THEN
      -- log attems
      manage_item.item_insert(
        pv_new_item_id             => :NEW.item_id,
        pv_new_item_barcode        => :NEW.item_barcode,
        pv_new_item_type           => :NEW.item_type,
        pv_new_item_title          => :NEW.item_title,
        pv_new_item_subtitle       => :NEW.item_subtitle,	
        pv_new_item_rating         => :NEW.item_rating,
        pv_new_item_rating_agency  => :NEW.item_rating_agency,
        pv_new_item_release_date   => :NEW.item_release_date,
        pv_new_created_by          => :NEW.created_by,
        pv_new_creation_date       => :NEW.creation_date,
        pv_new_updated_by     => :NEW.last_updated_by,
        pv_new_update_date    => :NEW.last_update_date,
        pv_new_text_file_name      => :NEW.text_file_name,
        pv_old_item_id             => :OLD.item_id,
        pv_old_item_barcode        => :OLD.item_barcode,
        pv_old_item_type           => :OLD.item_type,
        pv_old_item_title          => :OLD.item_title,
        pv_old_item_subtitle       => :OLD.item_subtitle,	
        pv_old_item_rating         => :OLD.item_rating,
        pv_old_item_rating_agency  => :OLD.item_rating_agency,
        pv_old_item_release_date   => :OLD.item_release_date,
        pv_old_created_by          => :OLD.created_by,
        pv_old_creation_date       => :OLD.creation_date,
        pv_old_updated_by     => :OLD.last_updated_by,
        pv_old_update_date    => :OLD.last_update_date,
        pv_old_text_file_name      => :OLD.text_file_name
      );

      -- raise error
      RAISE_APPLICATION_ERROR(-20001,'No colons allowed in item titles');
    END IF;
  END;
  /
-- end item_trig

-- trigger 2 - item_delete_trig (delete item)


/* ||  END Part 3 || */
-- Close log file.
SPOOL OFF
