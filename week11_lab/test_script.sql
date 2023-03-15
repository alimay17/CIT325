-- Open log file.
SPOOL apply_plsql_lab11.txt
SET SERVEROUTPUT ON SIZE UNLIMITED

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

END manage_item;
/

LIST;
SHOW ERRORS;

SPOOL OFF