/*
||  Name:          apply_plsql_lab7.sql
||  Date:          15 Feb 2023
||  Author:        Alice Smith
||  Purpose:       Complete 325 Chapter 8 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- environment settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET FEEDBACK OFF

-- remove insert_contact
BEGIN
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
|| Part 1 - All or nothing insert_contact procedure 
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
    lv_return NUMBER := 0;

  -- cursor
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

  -- get lookup id's
  lv_member_id_type := get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
  lv_credit_card_id_type := get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
  lv_contact_id_type := get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
  lv_address_id_type := get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
  lv_telephone_id_type := get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);

  -- get system user and timestamp
  SELECT system_user_id INTO lv_created_by
    FROM system_user
    WHERE system_user_name = pv_user_name;

  SAVEPOINT starting_point;
 
  -- insert values
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
 RETURN;

END insert_contact;
/

SHOW ERRORS
/*
|| Part 1
|| TEST BLOCk 
*/
BEGIN
  NULL;
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
WHERE  c.last_name = 'Xavier';

/*
|| Part 2 - Convert insert_contact procedure from definer to invoker rights 

CREATE OR REPLACE PROCEDURE insert_contact(
  pv_first_name VARCHAR2
) AUTHID CURRENT_USER IS

BEGIN
  dbms_output.put_line('procedure 2 auth id works' || pv_first_name);
END;
/

/*
|| Part 3 - Convert insert_contact procedure from invoker to autonomous definer rights function
|| returns NUMBER 1 if success, 0 if not

-- Drop procedure to run function
-- DROP PROCEDURE insert_contact;
CREATE OR REPLACE FUNCTION insert_contact(
  pv_first_name VARCHAR2
) RETURN NUMBER AUTHID DEFINER IS

 lv_return NUMBER := 1;
BEGIN
  dbms_output.put_line('this is function 1: '||pv_first_name || ' Return value: ' || lv_return);
  RETURN 1;
END insert_contact;
/

/*
|| Part 4 - get_contact object table function using a contact_obj, contact_tab setup 
|| returns complete list of persons format: 'first, middle, last'

CREATE OR REPLACE FUNCTION get_contact (
  pv_first_name VARCHAR2
) RETURN CONTACT_TAB IS
BEGIN
  NULL;
END;
/
*/
/*
|| testing

DECLARE
  lv_num NUMBER;
BEGIN
--  insert_contact('firstName');
  lv_num := insert_contact('firstName');
  dbms_output.put_line(lv_num);
END;
/
*/
-- Close log file.
SPOOL OFF
