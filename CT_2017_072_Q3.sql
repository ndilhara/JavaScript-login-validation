--CT_2017_072
--Q3

CREATE OR REPLACE PACKAGE PKG_DEPT_MANAGER_INFO AS 

   CURSOR Dept_manager_avl IS 
      SELECT * FROM hr.DEPARTMENTS WHERE MANAGER_ID IS NOT NULL;
	  
   FUNCTION FUNC_DEPT_MNGR_SALARY_INC(emp_id IN NUMBER) RETURN number IS 
   
		s_inc number(4) :=0; 
		d_id number(4);
		l_id number(4);
		
   BEGIN 
   
		SELECT DEPARTMENT_ID into d_id 
		FROM EMPLOYEES WHERE EMPLOYEE_ID=emp_id; 
		
		SELECT LOCATION_ID into l_id
		FROM DEPARTMENTS WHERE DEPARTMENTS_ID=d_id; 
		
		IF l_id > 1700 THEN 
			sla_inc:= 500; 
		ELSIF l_id < 1700 THEN
			sla_inc:= 800; 
		ELSE
			sla_inc:= 1500; 
		END IF;  
    
		RETURN sla_inc; 
		
   END FUNC_DEPT_MNGR_SALARY_INC; 
   
  
   PUBLIC PROCEDURE PROC_LOAD_DEPT_MANAGER_INFO(emp_id IN number) AS
   
   sla_inc number;
   
   BEGIN 
   
		sla_inc:=FUNC_DEPT_MNGR_SALARY_INC(emp_id);
		dbms_output.put_line(sla_inc); 
   END PROC_LOAD_DEPT_MANAGER_INFO;
   
  
  
END PKG_DEPT_MANAGER_INFO; 
/

PKG_DEPT_MANAGER_INFO.PROC_LOAD_DEPT_MANAGER_INFO(100);