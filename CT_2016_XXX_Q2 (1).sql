--CT2019_XXX

CREATE SYNONYM LOC_DETAILS
FOR hr.locations;

CREATE SYNONYM COUNTRY_DETAILS
FOR hr.countries;

CREATE SYNONYM DEPT_DETAILS
FOR hr.departments;

VARIABLE VAR_ROW_COUNT NUMBER;

CREATE TABLE DEPT_POSTAL_ADDRESS
( Dept_ID number(10) NOT NULL,
  Address varchar2(200) NOT NULL,
  CONSTRAINT DEPT_POSTAL_ADDRESS_pk PRIMARY KEY (Dept_ID)
);


--VARIABLE VAR_ROW_COUNT NUMBER;
CREATE OR REPLACE PROCEDURE PROC_POSTAL_ADDRESS(rownu OUT NUMBER) AS
   
   l_id DEPT_DETAILS.DEPARTMENT_ID%type; 
   d_id DEPT_DETAILS.LOCATION_ID%type;
   --address hr.DEPT_POSTAL_ADDRESS%type;
   s_address LOC_DETAILS.STREET_ADDRESS%type; 
   city LOC_DETAILS.CITY%type;
   st_province LOC_DETAILS.STATE_PROVINCE%type;
   c_id LOC_DETAILS.COUNTRY_ID%type;
   c_name COUNTRY_DETAILS.COUNTRY_NAME%type;
   CURSOR dept_detailsc is 
      SELECT DEPARTMENT_ID, LOCATION_ID FROM DEPT_DETAILS; 
	  
BEGIN 

   OPEN dept_detailsc; 
   LOOP 
   FETCH dept_detailsc into d_id, l_id; 
      EXIT WHEN dept_detailsc%notfound; 
	  SELECT STREET_ADDRESS, CITY, STATE_PROVINCE, COUNTRY_ID INTO s_address, city, st_province, c_id
	  FROM LOC_DETAILS
	  WHERE LOCATION_ID = l_id; 
	  
	  SELECT COUNTRY_NAME INTO c_name
	  FROM COUNTRY_DETAILS
	  WHERE COUNTRY_ID = c_id; 
	  
	  INSERT INTO DEPT_POSTAL_ADDRESS (Dept_ID,Address) 
	  VALUES (d_id, s_address || ', ' || city || ', ' || st_province || ', ' || c_name);  
	 --address == (d_id || ' ' || l_id || ' ' || s_address || ' ' || city || ' ' || st_province || ' ' || c_name);
      --dbms_output.put_line(s_address || ', ' || city || ', ' || st_province || ', ' || c_name); 
	  --dbms_output.put_line(dept_detailsc%rowcount); 
	  
   END LOOP; 
   COMMIT;
   dbms_output.put_line(dept_detailsc%rowcount); 
   	rownu:=dept_detailsc%rowcount;

   --ROW_COUNT:=dept_detailsc%rowcount;
   CLOSE dept_detailsc; 
   
   
END; 
/

	--:VAR_ROW_COUNT:=0;
	EXECUTE PROC_POSTAL_ADDRESS(:VAR_ROW_COUNT);
	print VAR_ROW_COUNT;



