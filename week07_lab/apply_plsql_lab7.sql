/*
||  Name:          apply_plsql_lab7.sql
||  Date:          15 Feb 2023
||  Author:        Alice Smith
||  Purpose:       Complete 325 Chapter 8 lab.
*/

-- Call seeding libraries
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

/* open log file */
SPOOL apply_plsql_lab7.txt

/* environment settings */
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET FEEDBACK OFF

/* Database setup */
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

  -- remove anything with insert_contact name
  FOR i IN (
    SELECT 
     uo.object_type,
     uo.object_name
    FROM   user_objects uo
    WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

/*
|| Part 1 - initial insert_contact procedure
*/
CREATE OR REPLACE PROCEDURE insert_contact(
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

-- END function declaration

-- begin main function insert_contact
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

END INSERT_CONTACT;
/
-- END insert_contact

/*
|| Part 1 TEST BLOCK

BEGIN
  insert_contact(
    'Charles',
    'Francis',
    'Xavier',
    'CUSTOMER',
    'SLC-000008',
    'INDIVIDUAL',
    '7777-6666-5555-4444',
    'DISCOVER_CARD',
    'Milbridge',
    'Maine',
    '04658',
    'HOME',
    '001',
    '207',
    '111-1234',
    'HOME',
    'DBA 2'
  );
END; -- test block
/

-- test query
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

|||||||||||||| END PART 1 |||||||||||||||||||||||*/


/*
|| Part 2 - Convert insert_contact procedure from definer to invoker rights.
|| use autonomous transaction


CREATE OR REPLACE PROCEDURE insert_contact(
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
) AUTHID CURRENT_USER IS

  -- local variables
  lv_address_id_type     VARCHAR2(30);
  lv_contact_id_type     VARCHAR2(30);
  lv_credit_card_id_type VARCHAR2(30);
  lv_member_id_type      VARCHAR2(30);
  lv_telephone_id_type   VARCHAR2(30);
  lv_created_by          VARCHAR2(30);
  lv_time_stamp DATE := SYSDATE;

  -- get_lookup_id function
  FUNCTION get_lookup_id(
    pv_table_name  VARCHAR2,
    pv_column_name VARCHAR2,
    pv_lookup_type VARCHAR2
  ) RETURN NUMBER IS
    lv_return NUMBER := 0;

  -- dynamic CURSOR
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

-- set to autonomous transaction
PRAGMA AUTONOMOUS_TRANSACTION;

-- begin main function insert_contact
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
  COMMIT;  

  EXCEPTION 
    WHEN OTHERS THEN
      ROLLBACK TO starting_point;
END INSERT_CONTACT;
/

SHOW ERRORS

/*
|| Part 2 TEST BLOCK

BEGIN
  insert_contact(
    'Maura',
    'Jane',
    'Haggerty',
    'CUSTOMER',
    'SLC-000009',
    'INDIVIDUAL',
    '8888-7777-6666-5555',
    'MASTER_CARD',
    'Bangor',
    'Maine',
    '04401',
    'HOME',
    '001',
    '207',
    '111-1234',
    'HOME',
    'DBA 2'
  );
END; -- end test block
/

-- test query
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';

|||||||||||||| END PART 2 |||||||||||||||||||||||*/

/*
|| Part 3 - Convert insert_contact procedure from invoker to function
|| returns 1 if success, 0 if fail

-- Drop procedure to run function
-- DROP PROCEDURE insert_contact;

-- create function
CREATE OR REPLACE FUNCTION insert_contact(
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
  lv_time_stamp DATE := SYSDATE;

  -- main return variable
  lv_return_val NUMBER := 0;

  -- get_lookup_id function
  FUNCTION get_lookup_id(
    pv_table_name  VARCHAR2,
    pv_column_name VARCHAR2,
    pv_lookup_type VARCHAR2
  ) RETURN NUMBER IS

    -- get_lookup_id default return value
    lv_return NUMBER := 0;

  -- dynamic CURSOR
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

-- begin main function insert_contact
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
  lv_return_val := 0;

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
  COMMIT;
  lv_return_val := 1;
  RETURN lv_return_val;


  EXCEPTION 
    WHEN OTHERS THEN
      ROLLBACK TO starting_point;
    RETURN lv_return_val;
    
END; -- end insert_contact
/

SHOW ERRORS

/*
|| Part 3 TEST BLOCK
*/

BEGIN
 IF insert_contact(
    'Harriet',
    'Mary',
    'McDonnell',
    'CUSTOMER',
    'SLC-000010',
    'INDIVIDUAL',
    '9999-8888-7777-6666',
    'VISA_CARD',
    'Orono',
    'Maine',
    '04469',
    'HOME',
    '001',
    '207',
    '111-1234',
    'HOME',
    'DBA 2'
  ) = 1 THEN
    dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
  END IF;
END;
/

-- test query
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';

/*|||||||||||||| END PART 3 |||||||||||||||||||||||*/

/*
|| Part 4 - get_contact object table function using a contact_obj, contact_tab setup 
|| returns complete list of persons format: 'first, middle, last'
*/

/* create contact object */
DROP TYPE contact_obj FORCE;
CREATE OR REPLACE 
  TYPE contact_obj IS OBJECT(
  first_name VARCHAR2(20),
  middle_name VARCHAR2(20),
  last_name VARCHAR2(20)
);
/

/* create table of contact_obj */
CREATE OR REPLACE
  TYPE contact_tab IS TABLE OF contact_obj;
/

/* contact_obj function */
CREATE OR REPLACE FUNCTION get_contact 
  RETURN CONTACT_TAB IS
  
  -- cursor
  CURSOR contact_cur IS
    SELECT first_name, middle_name, last_name
    FROM contact;

  -- variables
  lv_count NUMBER;
  lv_contact_tab CONTACT_TAB := contact_tab();  

  BEGIN
    -- read cursor into local table
    lv_count := 1;
    FOR i IN contact_cur LOOP
      lv_contact_tab.EXTEND;
      lv_contact_tab(lv_count) := contact_obj(
      i.first_name,
      i.middle_name,
      i.last_name
    );
    lv_count := lv_count + 1;
    END LOOP;

  RETURN lv_contact_tab;
END;
/

/*
|| Part 4 test query
*/
SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
  WHEN middle_name IS NOT NULL
    THEN ' ' || middle_name || ' '
  ELSE ' '
  END || last_name AS full_name
FROM   TABLE(get_contact);

/*|||||||||||||| END PART 3 |||||||||||||||||||||||*/

-- Close log file.
SPOOL OFF
