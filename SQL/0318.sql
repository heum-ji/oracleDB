--------------------------------------------------------------------------------
/*
    03.18(��) 
*/
--------------------------------------------------------------------------------
/*
    ���߿� ��������
    - ���߿� / ������
*/
--------------------------------------------------------------------------------
-- 1. ����� �������� 1�� �� �����̶� �����μ�, ���� ���޿� �ش��ϴ� ����� �̸�, ����, �μ��ڵ�
-- ������ ���
SELECT EMP_NAME, JOB_CODE, DEPT_CODE FROM EMPLOYEE
WHERE
    DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y') AND
    JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y');
-- ���߿� ���
SELECT EMP_NAME, JOB_CODE, DEPT_CODE FROM EMPLOYEE
WHERE
    (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y');
    
-- 2. ����������̸鼭, �޿��� 200������ ������ �̸�, �μ��ڵ�, �޿�, �μ� ������(LOCATION)
-- JOIN ���
SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE DEPT_TITLE LIKE '�������%' AND SALARY = 2000000;
-- �������� ���
SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN LOCATION ON (DEPT_CODE,LOCAL_CODE) IN (SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT WHERE DEPT_TITLE = '���������')
WHERE SALARY = 2000000;

SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN LOCATION ON (DEPT_CODE,LOCAL_CODE) IN (SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT);

SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT;
--------------------------------------------------------------------------------
/*
    ������ ���߿� �������� : ��ȸ ����� �÷� �� ���� ������ �������� ���
*/
--------------------------------------------------------------------------------
-- 1. ���޺� �ּұ޿��� �޴� ������ �̸�, ����, ����
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE (JOB_CODE,SALARY) IN (SELECT JOB_CODE, MIN(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE) ORDER BY 2;

--------------------------------------------------------------------------------
/*
    �������(��ȣ������������)
    - ���������� ���� ���������� �ְ� ���������� �����ϰ�, �� ����� �ٽ� ���������� ��ȯ�ؼ� �����ϴ� ����
    - ������ ���� ����
    - ���������� WHERE�� �����ϱ� ���� ���������� ���� ����Ǵ� ����
    - ���������� �� ���� ������ ������ �޶����� �ϴ� ��� ���
*/
--------------------------------------------------------------------------------
-- 1. �μ��� '�λ������', 'ȸ�������','�����ú�' �� ������ �̸�, �μ��ڵ�, �޿�
-- JOIN
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('�λ������','ȸ�������','�����ú�');
-- ��������
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE IN ('�λ������','ȸ�������','�����ú�'));
-- �������
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE E
WHERE EXISTS (
    SELECT DEPT_ID FROM DEPARTMENT D
    WHERE DEPT_TITLE IN ('�λ������','ȸ�������','�����ú�')
    AND E.DEPT_CODE = D.DEPT_ID
);
--------------------------------------------------------------------------------
/*
	��Į�� �������� : ��������̸鼭 ������� 1���� ��������
*/
--------------------------------------------------------------------------------
-- 1) WHERE���� ���
-- �ڽ��� ���� ������ ��� �޿����� �޿��� ���� �޴� ������ �̸�, �����ڵ�, �޿�
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E1
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE E2 WHERE E2.JOB_CODE = E1.JOB_CODE); -- �ڽ��� ���� ������ ��� �޿�

-- 2) SELECT���� ���
-- �����, �μ��ڵ�, �μ��� ����ӱ��� ���
SELECT
    EMP_NAME,
    NVL(DEPT_CODE,'�������') "�μ�",
    FLOOR((SELECT AVG(SALARY) FROM EMPLOYEE E2 WHERE NVL(E1.DEPT_CODE,'����') = NVL(E2.DEPT_CODE,'����') GROUP BY DEPT_CODE))
    "�μ��� ��� �ӱ�"
FROM EMPLOYEE E1;
-- �����, ������ ���, ������ �̸�
SELECT EMP_NAME, NVL(MANAGER_ID,'����') "������ ID",
    NVL((SELECT E2.EMP_NAME FROM EMPLOYEE E2 WHERE E1.MANAGER_ID = E2.EMP_ID),'����') "������ �̸�"
FROM EMPLOYEE E1;

-- 3) ORDER BY���� ���
-- �̸�, �μ��ڵ�, �޿� ����ϴµ� ������ �μ��̸� ����
SELECT EMP_NAME,DEPT_CODE,SALARY,(SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_CODE = DEPT_ID) "�μ��̸�"
FROM EMPLOYEE
ORDER BY (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_CODE = DEPT_ID);

--------------------------------------------------------------------------------
/*
	�ζ��κ� : FROM������ ���Ǵ� ��������
*/
--------------------------------------------------------------------------------
SELECT * FROM (SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY FROM EMPLOYEE);

--------------------------------------------------------------------------------
/*
	TOP-N �м�
    1) ROWNUM : ��µǴ� �ึ�� �ڵ����� �������� ��ȣ�� �ٿ��ִ� ��
*/
--------------------------------------------------------------------------------
-- ���� �����߿� �޿��� ���� ���� �޴� 5�� �̸�, �޿� ���
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 3700000 ORDER BY 2 DESC;
-- ROWNUM ���� �� ORDER BY �����
SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC;
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC;
-- �޿� ���ĵ� TABLE �� �ζ��κ�� �ְ�, ROWNUM ���� 5�� ���
SELECT ROWNUM, EMP_NAME, SALARY FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC) WHERE ROWNUM < 6;

-- RANK() OVER - �ߺ� ���� ������ �ߺ� ������ŭ �ǳʶٰ� ��ȯ
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����" FROM EMPLOYEE;
-- DENSE_RANK() OVER - �ߺ� ������ ������� ���������� ��ȯ
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "����" FROM EMPLOYEE;
-- ROWNUM �̶� ���� ��� / �ߺ� ��� X
SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) "����" FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
	���������� �̿��� ���̺� ����
*/
--------------------------------------------------------------------------------
/*
    ���̺� ���� ����
    CREATE TABLE ���̺��(�÷��� ������Ÿ�� ��������, ....);
*/
-- NOT NULL�� ���� - �ٸ� ���������� ���� �ȵ�
CREATE TABLE EMP_COPY
AS 
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '�μ� ����') DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB USING (JOB_CODE)
ORDER BY 1;

SELECT * FROM EMP_COPY;

-- TABLE COLUMN ������ �����ϴ� ��� - DATA X
CREATE TABLE EMP_COPY1
AS
SELECT * FROM EMPLOYEE WHERE 1=0;

SELECT * FROM EMP_COPY1;

DROP TABLE EMP_COPY;
DROP TABLE EMP_COPY2;
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_COPY;

-- ���������� �̿��� ����
-- UPDATE EMP_COPY SET �����÷� = ������, ... WHERE ����

-- 1. ���� ������ �޿��� �������� �޿��� ����
-- 1) �������� �޿� �˻�
SELECT SALARY FROM EMP_COPY WHERE EMP_NAME = '������';
-- 2) ���� �޿� ����
UPDATE EMP_COPY SET SALARY = (SELECT SALARY FROM EMP_COPY WHERE EMP_NAME = '������') WHERE EMP_NAME = '����';

-- ���������� �̿��� ����
-- ���� ������ ���� �μ��� ���� ��� ����
-- 1) ���� �μ��ڵ� �˻�
SELECT DEPT_CODE FROM EMP_COPY WHERE EMP_NAME = '����';
-- 2) ������ ���� �μ� ���� ����
DELETE FROM EMP_COPY WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMP_COPY WHERE EMP_NAME = '����');
SELECT * FROM EMP_COPY;

-- ���������� �̿��� INSERT
CREATE TABLE EMP1
AS
SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMP2
AS
SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMP3
AS
SELECT EMP_ID,EMP_NAME,JOB_CODE FROM EMPLOYEE WHERE 1=0;

INSERT INTO EMP1 VALUES(1, '�׽�Ʈ','D5');

INSERT INTO EMP1 (SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '������');
INSERT INTO EMP2 (SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE);

DELETE FROM EMP2;

SELECT * FROM EMP1;
SELECT * FROM EMP2;
SELECT * FROM EMP3;

-- INSERT ALL
INSERT ALL
INTO EMP2 VALUES(EMP_ID,EMP_NAME,DEPT_CODE)
INTO EMP3 VALUES(EMP_ID,EMP_NAME,JOB_CODE)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    TCL
*/
--------------------------------------------------------------------------------
COMMIT;

CREATE TABLE USERTBL(
    USER_NO NUMBER  PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PW VARCHAR2(20) NOT NULL
);
INSERT INTO USERTBL VALUES(1,'USER01','1111');
INSERT INTO USERTBL VALUES(2,'USER02','2222');
INSERT INTO USERTBL VALUES(3,'USER03','3333');
INSERT INTO USERTBL VALUES(4,'USER04','4444');
SAVEPOINT spl;
INSERT INTO USERTBL VALUES(5,'USER05','9999');
SELECT * FROM USERTBL;
COMMIT; -- savepoint ���� �� ���� ���� ����
ROLLBACK; -- ���� �ֱ� commit ���� �̵�
ROLLBACK TO spl; -- savepoint�� �̵�
DELETE FROM USERTBL;

UPDATE USERTBL SET USER_PW = '4544' WHERE USER_NO = 2;
--------------------------------------------------------------------------------
/*
    DATA DICTIONARY
    - �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ �����ϴ� �ý��� ���̺�
    - ����ڰ� ���̺��� ����� �����͸� ����� X
    - ����ڰ� DB �۾��� �ϸ� �ڵ����� ����
    - VIEW : �������̺��� Ŀ���͸���¡�ؼ� �����ִ� ���� ���̺�
    
    ��ǥ���� DICTIONARY VIEW
    1. DBA_XXXX : DB �����ڸ� ������ ������ ��ü �������� ��ȸ
    -> DBA�� ��� ������ �����ϹǷ� DB�� �ִ� ��� ��ü�� ���� ���� ��ȸ
    2. ALL_XXXX : �ڽ��� ������ �����ϰų� ������ �ο� ���� ��ü �������� ��ȸ
    3. USER_XXXX : �ڽ��� ������ ������ ��ü �������� ��ȸ
*/
--------------------------------------------------------------------------------
SELECT * FROM USER_TABLES;
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE';
SELECT * FROM USER_COL_COMMENTS;
--------------------------------------------------------------------------------
/*
	OBJECT
*/
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
/*
	1. VIEW : 
    -- ADMIN���� GRANT CREATE VIEW TO ������ // ���� ���� �ؾ� ��� ����
*/
--------------------------------------------------------------------------------

-- TABLE ���� -- �迭(���� ����)
CREATE TABLE EMP01
AS
SELECT EMP_NO,EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;

SELECT * FROM EMP01;
SELECT * FROM EMPLOYEE;

UPDATE EMP01 SET PHONE = '01099999999' WHERE EMP_NAME = '�ɺ���';

-- VIEW -- �迭(���� ����)
CREATE VIEW EMP_VIEW
AS
SELECT EMP_NO,EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;
SELECT * FROM EMP_VIEW;

UPDATE EMP_VIEW SET PHONE = '01088888888' WHERE EMP_NAME = '�ɺ���';
UPDATE EMPLOYEE SET PHONE = '01012341234' WHERE EMP_NAME = '�ɺ���';

CREATE VIEW EMP_VIEW2
AS
SELECT EMP_NO,EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM EMP_VIEW2;
SELECT * FROM EMPLOYEE;

UPDATE EMP_VIEW2 SET EMP_NO = '621235-1985699' WHERE EMP_NAME = '������';

-- ���� �Ұ� / �����ؼ� ���� ������ COLUMN�̱� ����
UPDATE EMP_VIEW2 SET DEPT_TITLE = '�ؿܿ���2��' WHERE EMP_NAME = '������';

--------------------------------------------------------------------------------
/*
	2. SEQUENCE
    - �ڵ����� ��ȣ ����
*/
--------------------------------------------------------------------------------
CREATE SEQUENCE TEST_SEQ
START WITH 10
INCREMENT BY 2
MAXVALUE 30
NOCYCLE
NOCACHE;
-- SEQUENCE ��ȸ
SELECT * FROM USER_SEQUENCES;

SELECT TEST_SEQ.CURRVAL FROM DUAL; -- ���� ó�� ��� �� �׻� NEXTVAL �� ���
SELECT TEST_SEQ.NEXTVAL FROM DUAL;

CREATE SEQUENCE TEST_SEQ2
START WITH 10
INCREMENT BY 2
MAXVALUE 30
CYCLE
NOCACHE;

SELECT TEST_SEQ2.CURRVAL FROM DUAL;
SELECT TEST_SEQ2.NEXTVAL FROM DUAL;

CREATE TABLE SEQ_TEST1(
    NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL
);

CREATE SEQUENCE SEQ_TEST1_NO
START WITH 10
INCREMENT BY 10
MAXVALUE 100
NOCYCLE
NOCACHE;

DROP SEQUENCE SEQ_TEST1_NO;
DROP TABLE SEQ_TEST1;
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST1',10);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST2',20);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST3',30);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST4',30);
SELECT * FROM SEQ_TEST1;

DROP TABLE SEQ_TEST2;

CREATE TABLE SEQ_TEST2(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL
);

CREATE SEQUENCE SEQ_TEST2_NO; -- 1 ~ ++
INSERT INTO SEQ_TEST2 VALUES('L-'||SEQ_TEST2_NO.NEXTVAL,'TEST1',11);
INSERT INTO SEQ_TEST2 VALUES('L-'||SEQ_TEST2_NO.NEXTVAL,'TEST2',22);
SELECT * FROM SEQ_TEST2;

SELECT * FROM USER_SEQUENCES;
-- ������ ����
-- ���۰� 100, �ִ밪 500, ������ 50, �ݺ�����, ĳ��X -> ���ｺ �̸� : TEST_SEQ2
CREATE SEQUENCE TEST_SEQ2
START WITH 100
INCREMENT BY 50
MAXVALUE 500
NOCYCLE
NOCACHE;

-- START ���� ���� X - �ʿ� �� DROP �� CREATE
ALTER SEQUENCE TEST_SEQ2
INCREMENT BY 10
MAXVALUE 500
NOCYCLE
NOCACHE;