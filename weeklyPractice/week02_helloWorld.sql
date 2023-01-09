/**
SET SERVEROUTPUT ON SIZE UNLIMITED
VARIABLE bind_variable VARCHAR2 (20)
DECLARE
	lv_input VARCHAR2(30);
BEGIN
	:lv_input := bind_variable;
	dbms_output.put_line('['||lv_input||']');
END;
/
BEGIN
dbms_output.put_line('Hello World.');
dbms_output.put_line('['||'&input'||']');
:bind_variable := 'Hello World';
dbms_output.put_line('['||:bind_variable||']');
END;
/
**/

DECLARE
	lv_sample NUMBER DEFAULT 7;
BEGIN
	lv_sample := &input;
	dbms_output.put_line('Value is: ['||lv_sample||']');
EXCEPTION
	WHEN OTHERS THEN
	  dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/
