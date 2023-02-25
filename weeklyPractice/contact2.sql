SPOOL contact2.txt

SET SERVEROUTPUT ON SIZE UNLIMITED

/* 
|| Part 2 contact_package with 2 overloaded functions 
*/
DROP PACKAGE contact_package;
-- contact_package specification
CREATE OR REPLACE PACKAGE contact_package IS
  -- insert_contact version 1 (user_name)
  FUNCTION insert_contact(
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
  ) RETURN NUMBER;

  -- insert_contact version 2 (user_id)
  FUNCTION insert_contact(
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
  ) RETURN NUMBER;

END contact_package;
/
-- end contact_package specification

-- contact_package body
CREATE OR REPLACE PACKAGE BODY contact_package IS
  -- insert_contact version 1 (user_name)
  FUNCTION insert_contact(
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
  ) RETURN NUMBER IS

    -- local variables
    lv_address_id_type     VARCHAR2(30);
    lv_contact_id_type     VARCHAR2(30);
    lv_credit_card_id_type VARCHAR2(30);
    lv_member_id_type      VARCHAR2(30);
    lv_telephone_id_type   VARCHAR2(30);
    lv_created_by          VARCHAR2(30);
    lv_member_id           NUMBER;
    lv_time_stamp          DATE :=  SYSDATE;
    lv_return_val          NUMBER;

    -- get_member cursor
    CURSOR get_member(cv_account_number VARCHAR2) IS
      SELECT member_id FROM member
      WHERE account_number = cv_account_number;

    -- get_lookup_id cursor
    CURSOR get_lookup_id(
      cv_table_name  VARCHAR2,
      cv_column_name VARCHAR2,
      cv_lookup_type VARCHAR2
    ) IS
      SELECT common_lookup_id
      FROM common_lookup WHERE
        common_lookup_table = cv_table_name   AND
        common_lookup_column = cv_column_name AND
        common_lookup_type = cv_lookup_type;

    -- begin insert_contact
    BEGIN
      -- get lookup id types
      OPEN get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
        FETCH get_lookup_id INTO lv_member_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
        FETCH get_lookup_id INTO lv_credit_card_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
        FETCH get_lookup_id INTO lv_contact_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
        FETCH get_lookup_id INTO lv_address_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);
        FETCH get_lookup_id INTO lv_telephone_id_type;
      CLOSE get_lookup_id;

      -- get system user
      SELECT system_user_id INTO lv_created_by
        FROM system_user
        WHERE system_user_name = pv_user_name;

      -- rollback point
      SAVEPOINT starting_point;
      lv_return_val := 0;

      -- insert into tables
      -- check if member already exists
      OPEN get_member(pv_account_number);
        FETCH get_member INTO lv_member_id;
          IF (get_member%NOTFOUND) THEN
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
          lv_member_id := member_s1.CURRVAL;
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
        lv_member_id,
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

      -- commit changes and return success result
      COMMIT;
      lv_return_val := 1;
      RETURN lv_return_val;

      -- handle exceptions and return fail result
      EXCEPTION 
        WHEN OTHERS THEN
          ROLLBACK TO starting_point;
        RETURN lv_return_val;

  END;
  -- end insert_contact version 1(user_name)

  -- insert_contact version 2 (user_id)
  FUNCTION insert_contact(
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
  ) RETURN NUMBER IS

    -- local variables
    lv_address_id_type     VARCHAR2(30);
    lv_contact_id_type     VARCHAR2(30);
    lv_credit_card_id_type VARCHAR2(30);
    lv_member_id_type      VARCHAR2(30);
    lv_telephone_id_type   VARCHAR2(30);
    lv_created_by          NUMBER := NVL(pv_user_id, -1);
    lv_member_id           NUMBER;
    lv_time_stamp          DATE :=  SYSDATE;
    lv_return_val          NUMBER;

    -- get_member cursor
    CURSOR get_member(cv_account_number VARCHAR2) IS
      SELECT member_id FROM member
      WHERE account_number = cv_account_number;

    -- get_lookup_id cursor
    CURSOR get_lookup_id(
      cv_table_name  VARCHAR2,
      cv_column_name VARCHAR2,
      cv_lookup_type VARCHAR2
    ) IS
      SELECT common_lookup_id
      FROM common_lookup WHERE
        common_lookup_table = cv_table_name   AND
        common_lookup_column = cv_column_name AND
        common_lookup_type = cv_lookup_type;

    -- begin insert_contact
    BEGIN
      -- get lookup id types
      OPEN get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
        FETCH get_lookup_id INTO lv_member_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
        FETCH get_lookup_id INTO lv_credit_card_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
        FETCH get_lookup_id INTO lv_contact_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
        FETCH get_lookup_id INTO lv_address_id_type;
      CLOSE get_lookup_id;
      OPEN get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);
        FETCH get_lookup_id INTO lv_telephone_id_type;
      CLOSE get_lookup_id;

      -- rollback point
      SAVEPOINT starting_point;
      lv_return_val := 0;

      -- insert into tables

      -- check if member already exists
      OPEN get_member(pv_account_number);
        FETCH get_member INTO lv_member_id;
          IF (get_member%NOTFOUND) THEN
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
          lv_member_id := member_s1.CURRVAL;
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
        lv_member_id,
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

      -- commit changes and return success result
      COMMIT;
      lv_return_val := 1;
      RETURN lv_return_val;

      -- handle exceptions and return fail result
      EXCEPTION 
        WHEN OTHERS THEN
          ROLLBACK TO starting_point;
        RETURN lv_return_val;

  END;
  -- end insert_contact version 2 (user_id)

END;
/
--end contact_package body

/* 
|| Part 2 test - insert three group contacts
*/
BEGIN

  -- insert new contact 1 (user_name)
  IF contact_package.insert_contact(
    pv_first_name         => 'Shirley',
    pv_middle_name        => NULL,
    pv_last_name          => 'Partridge',
    pv_contact_type       => 'CUSTOMER',
    pv_account_number     => 'SLC-000012',
    pv_member_type        => 'GROUP',
    pv_credit_card_number => '8888-6666-8888-4444',
    pv_credit_card_type   => 'VISA_CARD',
    pv_city               => 'Lehi',
    pv_state_province     => 'Utah',
    pv_postal_code        => '84043',
    pv_address_type       => 'HOME',
    pv_country_code       => '001',
    pv_area_code          => '207',
    pv_telephone_number   => '887-4321',
    pv_telephone_type     => 'HOME',
    pv_user_name          => 'DBA 3'
  ) = 1 THEN
    dbms_output.put_line('Inserted contact 1 successfully');
  END IF;

  -- insert new contact 2 (user_id)
  IF contact_package.insert_contact(
    pv_first_name         => 'Keith',
    pv_middle_name        => NULL,
    pv_last_name          => 'Partridge',
    pv_contact_type       => 'CUSTOMER',
    pv_account_number     => 'SLC-000012',
    pv_member_type        => 'GROUP',
    pv_credit_card_number => '8888-6666-8888-4444',
    pv_credit_card_type   => 'VISA_CARD',
    pv_city               => 'Lehi',
    pv_state_province     => 'Utah',
    pv_postal_code        => '84043',
    pv_address_type       => 'HOME',
    pv_country_code       => '001',
    pv_area_code          => '207',
    pv_telephone_number   => '887-4321',
    pv_telephone_type     => 'HOME',
    pv_user_id            => 6
  ) = 1 THEN
    dbms_output.put_line('Inserted contact 2 successfully');
  END IF;

  -- insert new contact 1 (user_id)
  IF contact_package.insert_contact(
    pv_first_name         => 'Laurie',
    pv_middle_name        => NULL,
    pv_last_name          => 'Partridge',
    pv_contact_type       => 'CUSTOMER',
    pv_account_number     => 'SLC-000012',
    pv_member_type        => 'GROUP',
    pv_credit_card_number => '8888-6666-8888-4444',
    pv_credit_card_type   => 'VISA_CARD',
    pv_city               => 'Lehi',
    pv_state_province     => 'Utah',
    pv_postal_code        => '84043',
    pv_address_type       => 'HOME',
    pv_country_code       => '001',
    pv_area_code          => '207',
    pv_telephone_number   => '887-4321',
    pv_telephone_type     => 'HOME',
    pv_user_id            => -1
  ) = 1 THEN
    dbms_output.put_line('Inserted contact 3 successfully');
  END IF;
END;
/

-- test query
COL full_name      FORMAT A24  HEADING "Full Name"
COL created_by     FORMAT 9999 HEADING "System|User ID"
COL account_number FORMAT A10  HEADING "Account|Number"
COL address        FORMAT A22  HEADING "Address"
COL telephone      FORMAT A14  HEADING "Telephone"

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

/*|||||||||||||| END PART 2 |||||||||||||||||||||||*/

-- Close log file.
SPOOL OFF