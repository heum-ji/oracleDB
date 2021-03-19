--------------------------------------------------------------------------------
/*
    03.19(��) 
*/
--------------------------------------------------------------------------------

/*
    KH_MEMBER ���̺�
    MEMBER_NO ����
    MEMBER_NAME ����
    MEMBER_AGE ����
    MEMBER_JOIN_COM ����
    
    MEMBER_NO, MEMBER_JOIN_COM �������� ó��
    MEMBER_NO : 500���� �����ؼ� 10�� ����
    JOIN_COM : 1���� �����ؼ� 1������
    �� ������ ��� �ִ밪�� 10000/CYCLE X, CACHE X
    �׽�Ʈ ������ 5�� ����
*/

CREATE TABLE KH_MEMBER(
    MEMBER_NO NUMBER,
    MEMBER_NAME VARCHAR2(20),
    MEMBER_AGE NUMBER,
    MEMBER_JOIN_COM NUMBER 
);
CREATE SEQUENCE KH_MEMBER_NO
START WITH 500
INCREMENT BY 10
MAXVALUE 10000
NOCYCLE
NOCACHE;
CREATE SEQUENCE KH_JOIN_COM
START WITH 1
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

SELECT * FROM KH_MEMBER;
INSERT INTO KH_MEMBER VALUES(KH_MEMBER_NO.NEXTVAL,'���01',1,KH_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(KH_MEMBER_NO.NEXTVAL,'���02',22,KH_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(KH_MEMBER_NO.NEXTVAL,'���03',3,KH_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(KH_MEMBER_NO.NEXTVAL,'���04',44,KH_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(KH_MEMBER_NO.NEXTVAL,'���05',5,KH_JOIN_COM.NEXTVAL);

SELECT EMP_NAME, EMP_NO, HIRE_DATE FROM EMPLOYEE;

/* INDEX */
CREATE INDEX EMP_IDX ON EMPLOYEE(EMP_NAME,EMP_NO,HIRE_DATE);
DROP INDEX EMP_IDX;
SELECT * FROM USER_IND_COLUMNS; -- WHERE INDEX_NAME = 'EMP_IDX';

/* 
    SYNONYM
    GRANT CREATE SYNONYM TO ������; -- ���� ����
    -- ����� ���Ǿ�
  
    CREATE SYNONYM EMP FOR EMPLOYEE; -- ���Ǿ� ����
    GRANT SELECT ON KH.DEPARTMENT TO test01; --�ٸ� ���� ��ȸ ���� �ο�
    REVOKE SELECT ON KH.DEPARTMENT FROM test01; -- �ٸ� ���� ��ȸ ���� ����
    -- ���� ���Ǿ�
    CREATE PUBLIC SYNONYM DEPT FOR KH.DEPARTMENT; -- ���Ǿ� ����
    DROP PUBLIC SYNONYM DEPT; -- ����
*/

SELECT * FROM EMPLOYEE;
SELECT * FROM EMP;

CREATE SYNONYM EMP FOR EMPLOYEE;
SELECT * FROM DEPT;

/*
    PL/SQL�� ����
    1. �͸� ���(Anonymous Block)
    - �̸��� ���� ���, ������ ��� ����� ���
    
    2. ���ν���(Procedure)
    - ������ Ư�� ó���� �����ϴ� ���� ���α׷��� ������
    - return �� ����
    
    3. �Լ� (Function)
    - ���ν����� ���� ����� ���������� ��ȯ�� ������ ���̰� ����
    - return �� ����
*/
-- PL/SQL�� ����� ��³����� ȭ�鿡 �����ִ� ����
-- �����Ҷ����� ON�ؾ� ��� ����
SET SERVEROUTPUT ON; 

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE'); -- prinln ���
END;
/

SELECT * FROM EMPLOYEE;

SELECT EMP_ID FROM EMPLOYEE WHERE EMP_NAME = '������';

DECLARE
    ID NUMBER;
BEGIN
    SELECT EMP_ID 
    INTO ID -- ID�� SELECT ���� / SELECT / FROM ����
    FROM EMPLOYEE WHERE EMP_NAME = '&�̸�'; -- ��ü���� �Է� �� ����
    DBMS_OUTPUT.PUT_LINE(ID);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('������ ����');
END;
/
-- ����� �Է¹޾Ƽ� �̸�, �����ڵ�, �μ��ڵ� ���
DECLARE
    NAME VARCHAR2(20);
    J_CODE VARCHAR2(20);
    D_CODE VARCHAR2(20);
BEGIN
    SELECT EMP_NAME, JOB_CODE, DEPT_CODE 
    INTO NAME, J_CODE, D_CODE
    FROM EMPLOYEE WHERE EMP_ID = '&���';
    
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�����ڵ� : ' || J_CODE);
    DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : ' || D_CODE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('������ ����');
END;
/
-- ��� ��ȣ�� �Է� �޾Ƽ�, �̸�, �μ���, ���޸� ���
-- JOIN
DECLARE
    NAME VARCHAR2(20);
    D_NAME VARCHAR2(20);
    J_NAME VARCHAR2(20);
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO NAME, D_NAME, J_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&���';
    
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : ' || D_NAME);
    DBMS_OUTPUT.PUT_LINE('���޸� : ' || J_NAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('������ ����');
END;
/
-- �������� 
DECLARE
    NAME VARCHAR2(20);
    D_NAME VARCHAR2(20);
    J_NAME VARCHAR2(20);
BEGIN
    SELECT EMP_NAME,
    (SELECT DEPT_TITLE FROM DEPARTMENT D WHERE E.DEPT_CODE = D.DEPT_ID),
    (SELECT JOB_NAME FROM JOB J WHERE E.JOB_CODE = J.JOB_CODE)
    INTO NAME, D_NAME, J_NAME
    FROM EMPLOYEE E
    WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : ' || D_NAME);
    DBMS_OUTPUT.PUT_LINE('���޸� : ' || J_NAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('������ ����');
END;
/

/*
    ��������
    ������ [CONSTANT] �ڷ���(ũ��) [NOT NULL] [:=�ʱⰪ];
    �÷� Ÿ�� �ҷ����� - ���̺��.�÷���%TYPE
    ��� �÷� Ÿ�� �ҷ����� - ���̺��%ROWTYPE
*/
DECLARE
    NO1 NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE(NO1);
    NO1 := 100;
    DBMS_OUTPUT.PUT_LINE(NO1);
END;
/

DECLARE
    NAME EMPLOYEE.EMP_NAME%TYPE;
    D_CODE EMPLOYEE.DEPT_CODE%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_CODE
    INTO NAME, D_CODE
    FROM EMPLOYEE WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE(NAME);
    DBMS_OUTPUT.PUT_LINE(D_CODE);
END;
/

DECLARE
    MYROW EMPLOYEE%ROWTYPE;
BEGIN
    SELECT EMP_NAME,EMAIL,PHONE,SALARY,HIRE_DATE
    INTO MYROW.EMP_NAME, MYROW.EMAIL,MYROW.PHONE,MYROW.SALARY,MYROW.HIRE_DATE
    FROM EMPLOYEE WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE(MYROW.EMP_NAME);
END;
/

DECLARE
    -- MYRECORD ��� ������ Ÿ�� �ۼ�
    TYPE MYRECORD IS RECORD(
        NAME EMPLOYEE.EMP_NAME%TYPE,
        EMAIL EMPLOYEE.EMAIL%TYPE,
        PHONE EMPLOYEE.PHONE%TYPE,
        SAL EMPLOYEE.SALARY%TYPE,
        H_DATE EMPLOYEE.HIRE_DATE%TYPE
    );
    -- MYRECORD Ÿ�� ���� ����
    MY MYRECORD;
BEGIN
    SELECT EMP_NAME,EMAIL,PHONE,SALARY,HIRE_DATE
    INTO MY
    FROM EMPLOYEE WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE(MY.NAME);
    DBMS_OUTPUT.PUT_LINE(MY.EMAIL);
    DBMS_OUTPUT.PUT_LINE(MY.PHONE);
    DBMS_OUTPUT.PUT_LINE(MY.SAL);
    DBMS_OUTPUT.PUT_LINE(MY.H_DATE);
END;
/
----------------------------------------------------------
/*
    ���ù�
    IF, IF ~ ELSE, IF ~ ELSE IF
    
    IF(���ǽ�) {
        ���ǽ��� TRUE�� ����
    }
    
    IF ���� THEN ������ TRUE�� ������ ����
    
    END IF
*/
----------------------------------------------------------
-- �����ȣ�� �Է¹޾Ƽ� ���,�̸�,�޿�,���ʽ��� ���
-- ���࿡ ���ʽ��� ������ '���ʽ��� ���޹��� �ʴ� ����Դϴ�.' ���
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE;
    NAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BO EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID,EMP_NAME,SALARY,NVL(BONUS,0)
    INTO ID,NAME,SAL,BO
    FROM EMPLOYEE WHERE EMP_ID = '&�����ȣ';
    DBMS_OUTPUT.PUT_LINE('��� : ' || ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || BO * 100 || '%');
    IF (BO = 0) 
    THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���� ���� �ʴ� ����Դϴ�.');
    END IF;
END;
/
-- �����ȣ�� �Է¹ް� ���,�̸�,�μ��ڵ�,�μ����� ���
-- �̶� �����ڵ尡 J1,J2�� '�ӿ����Դϴ�.' , �׿� '�Ϲ� �����Դϴ�.'
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE;
    NAME EMPLOYEE.EMP_NAME%TYPE;
    D_CODE EMPLOYEE.DEPT_CODE%TYPE;
    D_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    J_CODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,JOB_CODE
    INTO ID,NAME,D_CODE,D_TITLE,J_CODE
    FROM EMPLOYEE 
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE('��� : ' || ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : ' || D_CODE);
    DBMS_OUTPUT.PUT_LINE('�μ��� : ' || D_TITLE);
    IF J_CODE IN('J1','J2')
    THEN DBMS_OUTPUT.PUT_LINE('�ӿ����Դϴ�.');
    ELSE DBMS_OUTPUT.PUT_LINE('�Ϲ� �����Դϴ�.');
    END IF;
END;
/

-- ����� �Է� ���� �� �޿��� ���� ����� ������ ���
-- ����� ���, �̸�, �޿�, �޿����
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE;
    NAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    SALGRADE CHAR(1);
BEGIN
    SELECT EMP_ID,EMP_NAME,SALARY
    INTO ID,NAME,SAL
    FROM EMPLOYEE WHERE EMP_ID = '&���';
    DBMS_OUTPUT.PUT_LINE('��� : ' || ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);
    
    IF SAL >= 5000000 THEN SALGRADE := 'A';
    ELSIF SAL >= 3000000 THEN SALGRADE := 'B';
    ELSE SALGRADE := 'C';
    END IF;
    DBMS_OUTPUT.PUT_LINE('�޿���� : ' || SALGRADE);
END;
/