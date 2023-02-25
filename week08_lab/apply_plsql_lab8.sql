/*
||  Name:          apply_plsql_lab8.sql
||  Date:          24 Feb 2023
||  Author:        Alice Smith
||  Purpose:       Complete 325 Chapter 9 lab.
*/

-- Call seeding libraries
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab8.txt

/* Database setup 
DECLARE
  -- variables
  lv_counter  NUMBER := 2;
  TYPE numbers IS TABLE OF NUMBER;
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  --  Update system_user names to unique values
  FOR i IN 1..lv_numbers.COUNT LOOP
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;
    lv_counter := lv_counter + 1;
  END LOOP;

  -- insert new users into system_user
  --user 1 BONDSB
  INSERT INTO system_user(
    system_user_id,
    system_user_name,
    system_user_group_id,
    system_user_type,
    first_name,
    middle_initial,
    last_name,
    created_by,
    creation_date,
    last_updated_by,
    last_update_date
  ) VALUES (
    6,
    'BONDSB',
    1,
    1,
    'Barry',
    'L',
    'Bonds',
    1,
    SYSDATE,
    1,
    SYSDATE
  );

  -- user 2 CURRYW
  INSERT INTO system_user(
    system_user_id,
    system_user_name,
    system_user_group_id,
    system_user_type,
    first_name,
    middle_initial,
    last_name,
    created_by,
    creation_date,
    last_updated_by,
    last_update_date
  ) VALUES (
    7,
    'CURRYW',
    1,
    1,
    'Wardell',
    'S',
    'Curry',
    1,
    SYSDATE,
    1,
    SYSDATE
  );

  -- user 3 ANONYMOUS
  INSERT INTO system_user(
    system_user_id,
    system_user_name,
    system_user_group_id,
    system_user_type,
    created_by,
    creation_date,
    last_updated_by,
    last_update_date
  ) VALUES (
    -1,
    'ANONYMOUS',
    1,
    1,
    1,
    SYSDATE,
    1,
    SYSDATE
  );
END;
/


/* Contact Package Specification 
DROP PACKAGE contact_package;
CREATE OR REPLACE PACKAGE contact_package IS
  -- insert_contact procedure with user_name param
  PROCEDURE insert_contact(
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_name          VARCHAR2
  );

  -- insert_contact procedure with user_id param
  PROCEDURE insert_contact(
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_id            NUMBER := null
  );
END contact_package;
/

/* Contact Package Body */
CREATE OR REPLACE PACKAGE BODY contact_package IS
  -- insert_contact version 1 (user_name)
  PROCEDURE insert_contact(
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_name          VARCHAR2
  ) IS
    -- local variables
    lv_address_id_type     VARCHAR2(30);
    lv_contact_id_type     VARCHAR2(30);
    lv_credit_card_id_type VARCHAR2(30);
    lv_member_id_type      VARCHAR2(30);
    lv_telephone_id_type   VARCHAR2(30);
    lv_created_by          VARCHAR2(30);
    lv_time_stamp DATE := SYSDATE;

    -- get_lookup_id helper function
    FUNCTION get_lookup_id(
      pv_table_name  VARCHAR2,
      pv_column_name VARCHAR2,
      pv_lookup_type VARCHAR2
    ) RETURN NUMBER IS

      -- return variable
      lv_return NUMBER := 0;

      -- dynamic CURSOR for lookup table values
      CURSOR find_common_lookup_id(
        cv_table_name  VARCHAR2,
        cv_column_name VARCHAR2,
        cv_lookup_type VARCHAR2
      ) IS
        SELECT common_lookup_id
        FROM common_lookup WHERE
          common_lookup_table = cv_table_name   AND
          common_lookup_column = cv_column_name AND
          common_lookup_type = cv_lookup_type;
    
      -- begin get_lookup id
      BEGIN
        for i in find_common_lookup_id(
          pv_table_name, 
          pv_column_name,
          pv_lookup_type
        ) LOOP
          lv_return := i.common_lookup_id;
        END LOOP;
      RETURN lv_return;
    END get_lookup_id; -- end get_lookup_id    

    -- begin insert_contact
    BEGIN
      -- get lookup id types
      lv_member_id_type := get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
      lv_credit_card_id_type := get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
      lv_contact_id_type := get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
      lv_address_id_type := get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
      lv_telephone_id_type := get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);

      -- get system user
      SELECT system_user_id INTO lv_created_by
        FROM system_user
        WHERE system_user_name = pv_user_name;

      -- rollback point
      SAVEPOINT starting_point;
    
      -- insert into tables
      -- member
      INSERT INTO member (
        member_id,
        member_type,
        account_number,
        credit_card_number,
        credit_card_type,
        created_by,
        creation_date,
        last_updated_by,
        last_update_date
      ) VALUES (
        member_s1.NEXTVAL,
        lv_member_id_type,
        pv_account_number,
        pv_credit_card_number,
        lv_credit_card_id_type,
        lv_created_by,
        lv_time_stamp,
        lv_created_by,
        lv_time_stamp
      );

      -- contact
      INSERT INTO contact(
        contact_id,
        member_id,
        contact_type,
        last_name,
        first_name,
        middle_name,
        created_by,
        creation_date,
        last_updated_by,
        last_update_date
      ) VALUES (
        contact_s1.NEXTVAL,
        member_s1.CURRVAL,
        lv_contact_id_type,
        pv_last_name,
        pv_first_name,
        pv_middle_name,
        lv_created_by,
        lv_time_stamp,
        lv_created_by,
        lv_time_stamp
      );

      -- address
      INSERT INTO address VALUES (
        address_s1.NEXTVAL,
        contact_s1.CURRVAL,
        lv_address_id_type,
        pv_city,
        pv_state_province,
        pv_postal_code,
        lv_created_by,
        lv_time_stamp,
        lv_created_by,
        lv_time_stamp
      );

      -- telephone
      INSERT INTO telephone VALUES (
        telephone_s1.NEXTVAL,
        contact_s1.CURRVAL,
        address_s1.CURRVAL,
        lv_telephone_id_type,
        pv_country_code,
        pv_area_code,
        pv_telephone_number,
        lv_created_by,
        lv_time_stamp,
        lv_created_by,
        lv_time_stamp
      );

      -- commit changes
      COMMIT;

      -- handle exceptions
      EXCEPTION 
        WHEN OTHERS THEN
          ROLLBACK TO starting_point;
  END;
  -- end insert_contact version 1 (user_name)

  -- insert_contact version 2 (user_id)
  PROCEDURE insert_contact(
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_id            NUMBER := NULL
  ) IS

    -- local variables
    lv_address_id_type     VARCHAR2(30);
    lv_contact_id_type     VARCHAR2(30);
    lv_credit_card_id_type VARCHAR2(30);
    lv_member_id_type      VARCHAR2(30);
    lv_telephone_id_type   VARCHAR2(30);
    lv_created_by          NUMBER;
    lv_member_id           NUMBER := NULL;
    lv_time_stamp DATE := SYSDATE;

    -- get_lookup_id function
    FUNCTION get_lookup_id(
      pv_table_name  VARCHAR2,
      pv_column_name VARCHAR2,
      pv_lookup_type VARCHAR2
    ) RETURN NUMBER IS

      -- variables
      lv_return NUMBER := 0;

      -- dynamic CURSOR for lookup table values
      CURSOR find_common_lookup_id(
        cv_table_name  VARCHAR2,
        cv_column_name VARCHAR2,
        cv_lookup_type VARCHAR2
      ) IS
        SELECT common_lookup_id
        FROM common_lookup WHERE
          common_lookup_table = cv_table_name   AND
          common_lookup_column = cv_column_name AND
          common_lookup_type = cv_lookup_type;
    
      -- begin get_lookup id
      BEGIN
        for i in find_common_lookup_id(
          pv_table_name, 
          pv_column_name,
          pv_lookup_type
        ) LOOP
          lv_return := i.common_lookup_id;
        END LOOP;
      RETURN lv_return;
    END get_lookup_id;
  
    -- get_member cursor
    CURSOR get_member(cv_account_number VARCHAR2) IS
      SELECT member_id FROM member
      WHERE account_number = cv_account_number;

  -- begin insert_contact
  BEGIN
    -- get lookup id types
    lv_member_id_type := get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
    lv_credit_card_id_type := get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
    lv_contact_id_type := get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
    lv_address_id_type := get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
    lv_telephone_id_type := get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);

    -- system user_id
    IF (pv_user_id = NULL) THEN
      lv_created_by := -1;
    ELSE
      lv_created_by := pv_user_id;

    -- rollback point
    SAVEPOINT starting_point;
 
    -- insert into tables

    -- check if member already exists
    OPEN get_member;
    FETCH get_member INTO lv_member_id;

    IF (lv_member_id = NULL) THEN
      -- insert new member
      INSERT INTO member (
        member_id,
        member_type,
        account_number,
        credit_card_number,
        credit_card_type,
        created_by,
        creation_date,
        last_updated_by,
        last_update_date
      ) VALUES (
        member_s1.NEXTVAL,
        lv_member_id_type,
        pv_account_number,
        pv_credit_card_number,
        lv_credit_card_id_type,
        lv_created_by,
        lv_time_stamp,
        lv_created_by,
        lv_time_stamp
      );
    END IF;
    CLOSE get_member;
    
    -- contact
    INSERT INTO contact(
      contact_id,
      member_id,
      contact_type,
      last_name,
      first_name,
      middle_name,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date
    ) VALUES (
      contact_s1.NEXTVAL,
      member_s1.CURRVAL,
      lv_contact_id_type,
      pv_last_name,
      pv_first_name,
      pv_middle_name,
      lv_created_by,
      lv_time_stamp,
      lv_created_by,
      lv_time_stamp
    );

    -- address
    INSERT INTO address VALUES (
      address_s1.NEXTVAL,
      contact_s1.CURRVAL,
      lv_address_id_type,
      pv_city,
      pv_state_province,
      pv_postal_code,
      lv_created_by,
      lv_time_stamp,
      lv_created_by,
      lv_time_stamp
    );

    -- telephone
    INSERT INTO telephone VALUES (
      telephone_s1.NEXTVAL,
      contact_s1.CURRVAL,
      address_s1.CURRVAL,
      lv_telephone_id_type,
      pv_country_code,
      pv_area_code,
      pv_telephone_number,
      lv_created_by,
      lv_time_stamp,
      lv_created_by,
      lv_time_stamp
    );

    -- commit changes
    COMMIT;

    -- handle exceptions
    EXCEPTION 
      WHEN OTHERS THEN
        ROLLBACK TO starting_point;

  END;
  -- end insert_contact version 2 (user_id)

END contact_package;
/


LIST
SHOW ERRORS

-- Close log file.
SPOOL OFF
