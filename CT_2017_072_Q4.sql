--CT_2017_072
--Q4

CREATE TABLE EMP_COPY AS SELECT * FROM EMPLOYEES; 

CREATE OR REPLACE TRIGGER TRIG_EMP_SECURE 
BEFORE DELETE OR INSERT OR UPDATE ON EMP_COPY 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF TO_CHAR(SYSDATE, 'D') = '1' THEN 
        RAISE_APPLICATION_ERROR(-20500, 'DML operations are restricted on sundays.'); 
    END IF;
END; 
/ 

CREATE TABLE JOB_COPY AS SELECT * FROM JOBS; 

CREATE TABLE JOB_LOG
( Action VARCHAR2(10) NOT NULL,
  Performed_on DATE NOT NULL,
  Performed_by VARCHAR2(10) NOT NULL
);

CREATE OR REPLACE TRIGGER TRIG_JOB_LOG
AFTER INSERT
ON JOB_LOG
FOR EACH ROW
DECLARE
    v_username VARCHAR(20);
    v_action VARCHAR(6):='INSERT';
    v_date DATE;
BEGIN
    SELECT User INTO v_username FROM dual;
	SELECT SYSDATE INTO v_date FROM dual;
    INSERT INTO JOB_LOG (Action, Performed_on, Performed_by) VALUES (v_action, v_date, v_username);
END;
/