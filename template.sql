/*
   Name:   script.sql
   Author: Alice Smith
   Date:   DD-MON-YYYY
*/

-- Code from other scripts here

-- Open log file
-- ------------------------------------------------------------
-- Comment out spool filename and spool off command when you call
-- the script from a shell script.
-- ------------------------------------------------------------
-- SPOOL 'logs/script.txt'

-- environment command to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

BEGIN


END;
/


-- Close log 
-- SPOOL OFF

-- comment out when using sqlplus CLI
-- QUIT;
