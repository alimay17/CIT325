/*
||  Name:          testScript.sql
||  Date:          28 Feb 2023
||  Purpose:       Test components seperatly before adding to full
*/

-- logfile
SPOOL 'logs/testScript.txt'

-- environment settings
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

CREATE OR REPLACE PROCEDURE load_clob_from_file( 
    src_file_name     IN VARCHAR2,
    table_name        IN VARCHAR2, 
    column_name       IN VARCHAR2,
    primary_key_name  IN VARCHAR2,
    primary_key_value IN VARCHAR2 
) IS

    -- Define local variables for DBMS_LOB.LOADCLOBFROMFILE procedure.
    des_clob   CLOB;
    src_clob   BFILE := BFILENAME('UPLOADTEXT',src_file_name);
    des_offset NUMBER := 1;
    src_offset NUMBER := 1;
    ctx_lang   NUMBER := dbms_lob.default_lang_ctx;
    warning    NUMBER;

    -- Define a pre-reading size.
    src_clob_size NUMBER;

    -- Define local variable for Native Dynamic SQL.
    stmt VARCHAR2(2000);

    BEGIN

    -- Opening source file is a mandatory operation.
    IF dbms_lob.fileexists(src_clob) = 1 AND NOT dbms_lob.isopen(src_clob) = 1 THEN
        src_clob_size := dbms_lob.getlength(src_clob);
        dbms_lob.OPEN(src_clob,DBMS_LOB.LOB_READONLY);
    END IF;

    -- Assign dynamic string to statement.
    stmt := 'UPDATE '||table_name||' '
        || 'SET    '||column_name||' = empty_clob() '
        || 'WHERE  '||primary_key_name||' = '||''''||primary_key_value||''' '
        || 'RETURNING '||column_name||' INTO :locator';

    -- Run dynamic statement.
    EXECUTE IMMEDIATE stmt USING OUT des_clob;

    -- Read and write file to CLOB, close source file and commit.
    dbms_lob.loadclobfromfile( 
        dest_lob     => des_clob,
        src_bfile    => src_clob,
        amount       => dbms_lob.getlength(src_clob),
        dest_offset  => des_offset,
        src_offset   => src_offset,
        bfile_csid   => dbms_lob.default_csid,
        lang_context => ctx_lang, 
        warning      => warning 
    );

    -- Close open source file.
    dbms_lob.CLOSE(src_clob);

    -- Commit write and conditionally acknowledge it.
    IF src_clob_size = dbms_lob.getlength(des_clob) THEN
        $IF $$DEBUG = 1 $THEN
        dbms_output.put_line('Success!');
        $END
        COMMIT;
    ELSE
        $IF $$DEBUG = 1 $THEN
        dbms_output.put_line('Failure.');
        $END
        RAISE dbms_lob.operation_failed;
    END IF;

END load_clob_from_file;
/

SPOOL OFF