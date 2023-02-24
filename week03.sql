
TYPE my_varray IS VARRAY(3) of VARCHAR2(2); -- always include the maximum array space when declaring​


lv_varray MY_VARRAY := my_varray('1', '2', '2'); -- initialize varray with constructor function