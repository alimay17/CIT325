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
  /* pv_first_name         VARCHAR2,
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
  
  pv_country_code       VARCHAR2,
  pv_area_code          VARCHAR2,
  pv_telephone_number   VARCHAR2,
  pv_telephone_type     VARCHAR2,
  pv_user_name          VARCHAR2 */
  pv_address_type       VARCHAR2
) IS

  -- common_lookup local variables
  lv_address_id        VARCHAR2(30);
  /* lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30); */

  -- get lookup_id
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
  lv_address_id := get_lookup_id(
    'ADDRESS',
    'ADDRESS_TYPE',
    pv_address_type
  );

  dbms_output.put_line(lv_address_id || ' this is the address id');

END;
/

BEGIN
  insert_contact('HOME');
END;
/

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
