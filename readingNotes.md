# CIT 325 - Reading Notes
*Winter 2023*  
*Prof. Hinkley*  
*Alice Smith*

## Term Definitions
- Subroutine = Functions
- Function = are something like classes but also regular functions. Very confusing.
- Blocks = programs or modules


## Block Structure
- Extends ADA
- Keywords define blocks not `{}`
### Types of Blocks
- Block basic Types:
  - Anonymous: Single use
  - Named: reusable, saved to db
- Three block catagories in both types:
  - Declaration
  - Execution
  - Exception
- Minimum of one statement in a block (can be blank)
### Syntax
- DECLARE / HEADER - declaration section
- BEGIN - execution section
- EXCEPTION - exception section
- END; / - Ends the block
All declarations, statements and blocks must end with `;`  
Never make dynamic assignments in a declaration block. Always in the Execution block so the exception can catch it.  
  
#### Anonymous Block
Variables are declared outside the block. No `;` after variable declarations.  

```
VARIABLE my_variable VARIABLE_TYPE
 BEGIN
  [STATEMENT HERE];
 END;
 /
```
*note: Forward slash `/` executes an anonymous block*

#### Named Blocks
Two types of named blocks
- Functions: always return value
- Procedures: fuctions that don't return value. 

When using a function or procedure in an anonymous block you must give a reference to it at the top of the block otherwise it doesn't know what you are talking about. 
```
DECLARE
  PROCEDURE a;
  FUNCTION stub_function RETURN DATATYPE;
  PROCEDURE a IS
  BEGIN
    stub_function;
  END a;
  FUNCTION stub_function IS
  BEGIN
    RETURN return_value'
  END stub_function;
  BEGIN
    a;
  END;
  /
```
Only use local named blocks if there is no chance that something else will need to use them.

## Collection and Array Types
- ATD Table = Abstract Data Type table of build in data types
- UDT Collection = User Defined Types (OBJECTS) Table of Objects
- varray = Variable array. Or array of variables. (not super helpful. Lots of issues. Avoid.)

 
## Variable Types
- Uses all Oracle data types
- BOOLEAN: TRUE, FALSE, NULL
- CHAR: fixed-length string. Default is sized in bytes
- VARCHAR2: variable-length string. Default is sized in bytes. Must have a max-length defined at declaration.
  - STRING and VARCHAR are subtype aliases of VARCHAR2 
- Subtypes
  - constrained - restricts base type in some way
  - unconstrained - alias for base type. Float is an example of an unconstrained subtype for type NUMBER.
- Implicit loss of precision conversion

# Chapter 6 - Data Collections
-  Scalar = single build in values
- Object = User defined data type. 
A list of object data types is a collection of object. An object is a user defined data type 

# Chapter 10 - Large Objects (LOB)
- CLOB = Character Large Objects
- NCLOB = National Character Large Objects
  - Must qualify the character set of the text 
- BLOB = Binary Large Objects
- Three states for LOBS
  - NULL: null value in column locator
  - Empty: column locator exists but isn’t populated; length = 0
  - Populated: contains locator and length > 0
## CLOB & NCLOB
- DB column contains a locator pointing to storage location
- Require construction (implicit or explicit) 
  - VARCHAR2, String literals etc.
  - Can’t use LONG data type
- `dbms_lob` package allows you to override size constraint
- Can load from file with `dbms_lob.loadfromfile || dbms_lob.loadclobfromfile`
- 
- 
- 
- 
- 
- 
- 