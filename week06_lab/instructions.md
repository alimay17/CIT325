# Week 06 - Error Handling

- Create Error table in DB
```sql
 DROP TABLE NC_ERROR; 
 CREATE TABLE nc_error();
```
- only need to run week05 lab if you are running test scripts

- PRAGMA AUTONOMOUS_TRANSACTION 
  - Compiler directive to commit something independently
  - Allows something to persist past roll back - useful for error logging

## General Requirements
**note lab 06 is independent*
- Add error handling in an exception block to the insert_item procedure that writes errors to the nc_error table.
- Add error handling in an exception block to the insert_items procedure that writes errors to the nc_error table.
### steps
1. Run prep script save as apply_plsql_lab6_prep.sql
    - creates insert_item, insert_items procedures
    - important items:
      - PROCEDURE insert_item - copy and save as insert_item.sql 
      - PROCEDURE insert_items - copy and save as insert_items.sql
2. Run modified insert_item's procedures
3. Copy all test case scrips to apply_plsql_lab6.sql
4. Submit apply_plsql_lab6.txt, insert_item.sql procedure, insert_items.sql procedure 

