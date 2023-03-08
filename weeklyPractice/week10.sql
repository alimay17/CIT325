/*
   Name:   week10.sql
   Author: Alice Smith
   Date:   05 Mar 2023
*/

-- Code from other scripts here

-- Open log file
SPOOL 'weeklyPractice/logs/week10.txt'

-- environment command to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- hello_there object declaration
-- CREATE OR REPLACE TYPE hello_there
--   -- ACCESSIBLE BY (FUNCTION white_hat)
--   IS OBJECT(
--   who VARCHAR2(20),
--   CONSTRUCTOR FUNCTION hello_there RETURN SELF AS RESULT,
--   CONSTRUCTOR FUNCTION hello_there(who VARCHAR2) RETURN SELF AS RESULT,
--   -- MEMBER FUNCTION get_who RETURN VARCHAR2,
--   -- MEMBER PROCEDURE set_who(who VARCHAR2),
--   MEMBER FUNCTION to_string RETURN VARCHAR2
-- ) INSTANTIABLE NOT FINAL;
-- /

-- hello_there object body
CREATE OR REPLACE TYPE BODY hello_there IS

 -- default constructor
  CONSTRUCTOR FUNCTION hello_there RETURN SELF AS RESULT IS
    hello HELLO_THERE := hello_there('scum and vilany');
    BEGIN
      self := hello;
    RETURN;
  END hello_there;

  -- second constructor
  CONSTRUCTOR FUNCTION hello_there(who VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
      self.who := who;
    RETURN;
  END hello_there;

  -- member function to_string
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN 'Hello '||self.who;
  END to_string;

END;
/

-- DECLARE
--   hello HELLO_THERE := hello_there();

-- BEGIN
--   hello.to_string();

-- END;
-- /

show errors
-- Close log 
SPOOL OFF

-- comment out when using sqlplus CLI
-- QUIT;
