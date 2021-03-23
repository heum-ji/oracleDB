--------------------------------------------------------------------------------
/*
    03.22(��) 
*/
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
/*
	PL/SQL �ݺ���
*/
--------------------------------------------------------------------------------
SET SERVEROUTPUT ON; -- SCRIPT OUTPUT ���̰� ����

-- IF
DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM + 1;
        IF NUM > 5 THEN EXIT; -- EXIT = BREAK �� ���� ���
        END IF;
    END LOOP;
END;
/
-- FOR
DECLARE
BEGIN
    FOR NUM IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/

DECLARE
BEGIN
    FOR NUM IN REVERSE 1..5 LOOP -- REVERSE ��������
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/
-- WHILE
DECLARE
    NUM NUMBER := 1;
BEGIN
    WHILE NUM <= 5 LOOP
        DBMS_OUTPUT.PUTLINE(NUM);
        NUM := NUM+1;
    END LOOP;
END;
/

CREATE TABLE TEST_TBL(
    TEST_NUM    NUMBER,
    TEST_CHAR   VARCHAR2(20)
);

DECLARE
BEGIN
    FOR I IN 1..10 LOOP
        INSERT INTO TEST_TBL VALUES(I,'�׽�Ʈ' || I);
    END LOOP;
END;
/
SELECT * FROM TEST_TBL;

-- �޿� 1~5���� ��ȸ�ϴ� ���� �ۼ�
SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS RANKING,EMP_NAME,SALARY FROM EMPLOYEE)
WHERE RANKING < 6;
-- ���ʽ� 1~5���� ��ȸ�ϴ� ���� �ۼ�
SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY NVL(BONUS,0) DESC) AS RANKING,EMP_NAME,BONUS FROM EMPLOYEE)
WHERE RANKING < 6;
-- �Ի��� ������ ������ 1~5�� ��ȸ�ϴ� ���� �ۼ�
SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY HIRE_DATE ASC) AS RANKING,EMP_NAME,HIRE_DATE FROM EMPLOYEE)
WHERE RANKING < 6;
-- '�޿�','���ʽ�','�Ի���'
-- �Է°� �� 1~5�� ���
DECLARE
    KEYWORD VARCHAR2(20);
    RANKING NUMBER;
    NAME    EMPLOYEE.EMP_NAME%TYPE;
    SAL     EMPLOYEE.SALARY%TYPE;
    BO      EMPLOYEE.BONUS%TYPE;
    H_DATE  EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    KEYWORD := '&Ű�����Է�';
    IF KEYWORD = '�޿�' THEN
        DBMS_OUTPUT.PUT_LINE('----- �޿� TOP 5 -----');
        FOR I IN 1..5 LOOP
            SELECT *
            INTO RANKING, NAME, SAL
            FROM (SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS RANKING,EMP_NAME,SALARY FROM EMPLOYEE)
            WHERE RANKING = I;
            DBMS_OUTPUT.PUT_LINE('��ŷ : ' || RANKING || ' / �̸� : ' || NAME || ' / �޿� : ' || SAL);
        END LOOP;
    ELSIF KEYWORD = '���ʽ�' THEN
        DBMS_OUTPUT.PUT_LINE('----- ���ʽ� TOP 5 -----');
        FOR I IN 1..5 LOOP
            SELECT *
            INTO RANKING, NAME, BO
            FROM (SELECT ROW_NUMBER() OVER(ORDER BY NVL(BONUS,0) DESC) AS RANKING,EMP_NAME,BONUS FROM EMPLOYEE)
            WHERE RANKING = I;
            DBMS_OUTPUT.PUT_LINE('��ŷ : ' || RANKING || ' / �̸� : ' || NAME || ' / ���ʽ� : ' || BO);
        END LOOP;
    ELSIF KEYWORD = '�Ի���' THEN
        DBMS_OUTPUT.PUT_LINE('----- �Ի��� TOP 5 -----');
        FOR I IN 1..5 LOOP
            SELECT *
            INTO RANKING, NAME, H_DATE
            FROM (SELECT ROW_NUMBER() OVER(ORDER BY HIRE_DATE ASC) AS RANKING,EMP_NAME,HIRE_DATE FROM EMPLOYEE)
            WHERE RANKING = I;
            DBMS_OUTPUT.PUT_LINE('��ŷ : ' || RANKING || ' / �̸� : ' || NAME || ' / �Ի��� : ' || H_DATE);
        END LOOP;
    ELSE DBMS_OUTPUT.PUT_LINE('�߸��Է��ϼ̽��ϴ�.');
    END IF;
END;
/

--------------------------------------------------------------------------------
/*
    TRIGGER
*/
--------------------------------------------------------------------------------
CREATE TABLE M_TBL(
    USERID      VARCHAR2(20) PRIMARY KEY,
    USERPW      VARCHAR2(20) NOT NULL,
    USERNAME    VARCHAR2(20) NOT NULL,
    ENROLL_DATE DATE
);
INSERT INTO M_TBL VALUES('user01','1234','����1',SYSDATE - 2);
INSERT INTO M_TBL VALUES('user02','1111','����2',SYSDATE - 1);
INSERT INTO M_TBL VALUES('user03','2222','����3',SYSDATE);
SELECT * FROM M_TBL;

CREATE TABLE DEL_M_TBL(
    USERID      VARCHAR2(20) PRIMARY KEY,
    USERNAME    VARCHAR2(20) NOT NULL,
    ENROLL_DATE DATE,
    OUT_DATE    DATE
);

-- PL/SQL ��� : user02 Ż��
DECLARE
    ID      M_TBL.USERID%TYPE;
    NAME    M_TBL.USERNAME%TYPE;
    EN_DATE M_TBL.ENROLL_DATE%TYPE;
BEGIN
    SELECT USERID,USERNAME,ENROLL_DATE
    INTO ID,NAME,EN_DATE
    FROM M_TBL WHERE USERID = 'user02';
    
    INSERT INTO DEL_M_TBL VALUES(ID,NAME,EN_DATE,SYSDATE); -- ���� ���̺� ����
    DELETE FROM M_TBL WHERE USERID = 'user02'; -- ���� ȸ�� ���̺��� ����
END;
/
SELECT * FROM M_TBL;
SELECT * FROM DEL_M_TBL;

-- M_TBL���� DELETE ���� �� �ڵ� ����
CREATE OR REPLACE TRIGGER M_TBL_TRG
AFTER DELETE ON M_TBL -- INSERT / DELETE/ UPDATE ���� // DATA�� ������ ���� ���
FOR EACH ROW -- ROW���� Ʈ���� �ߵ� / ���������� �߻��ϸ� �Ǹ� �ش� ���� X
BEGIN
    -- BIND ����
    INSERT INTO DEL_M_TBL VALUES(:OLD.USERID,:OLD.USERNAME,:OLD.ENROLL_DATE,SYSDATE);
END;
/

CREATE OR REPLACE TRIGGER M_TBL_INSERT_TRG
AFTER INSERT ON M_TBL
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:NEW.USERNAME || '�� ȯ���մϴ�');
END;
/

INSERT INTO M_TBL VALUES('user04','4444','����4',SYSDATE);
COMMIT; -- Ŀ���ؾ� ���������� ����ǹǷ�, put_line ������

-- BIND ���� / OLD/NEW
-- BIND ������ ����ϸ� �� �ʿ��� HARD PARSING�� ����

CREATE TABLE LOG_TBL(
    DUSERID     VARCHAR2(20),
    CONTENTS    VARCHAR2(100),
    MODIFY_DATE DATE
);

CREATE OR REPLACE TRIGGER M_TBL_MODIFY_TRG
AFTER UPDATE ON M_TBL
FOR EACH ROW
BEGIN
    INSERT INTO LOG_TBL VALUES(:OLD.USERID,:OLD.USERNAME || ' --> ' || :NEW.USERNAME,SYSDATE);
END;
/

-- old : update �� value / new : update �� value
UPDATE M_TBL SET USERNAME = '�����̸�!!' WHERE USERID = 'user04';

SELECT * FROM M_TBL;
SELECT * FROM DEL_M_TBL;
SELECT * FROM LOG_TBL;
DELETE FROM M_TBL WHERE USERID = 'user03';

CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,   -- ��ǰ��ȣ
    PNAME VARCHAR2(30),         -- ��ǰ��
    BRAND VARCHAR2(30),         -- �귣��
    PRICE NUMBER,               -- ����
    STOCK NUMBER DEFAULT 0      -- ����
);
CREATE TABLE PRO_DETAIL(        
    DCODE   NUMBER PRIMARY KEY,                     -- ����� ������ȣ
    PCODE   NUMBER REFERENCES PRODUCT(PCODE),       -- ��ǰ��ȣ
    P_DATE  DATE,                                   -- ����� ��¥
    AMOUNT  NUMBER,                                 -- ����� ����
    STATUS  CHAR(6) CHECK(STATUS IN ('�԰�','���')) -- �԰�/��� ����
);
CREATE SEQUENCE PRO_SEQ;
CREATE SEQUENCE DCODE_SEQ;
DCODE_SEQ.NEXTVAL;
DROP SEQUENCE DCODE_SEQ;
/* ��ǰ ���� */
INSERT INTO PRODUCT VALUES(PRO_SEQ.NEXTVAL, '����ũ','�Ｚ',100000,DEFAULT);
INSERT INTO PRODUCT VALUES(PRO_SEQ.NEXTVAL, '������12','����',1000000,DEFAULT);
INSERT INTO PRODUCT VALUES(PRO_SEQ.NEXTVAL, '�������͸�','������',1000,DEFAULT);
/* ����� ���� */
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,2,SYSDATE,10,'�԰�');
UPDATE PRODUCT SET STOCK = STOCK + 10 WHERE PCODE = 2;
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,2,SYSDATE,2,'���');
UPDATE PRODUCT SET STOCK = STOCK - 2 WHERE PCODE = 2;

-- ����ũ �԰� 20��
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,1,SYSDATE,20,'�԰�');
UPDATE PRODUCT SET STOCK = STOCK + 20 WHERE PCODE = 1;
-- ���� ���͸� �԰� 30��
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,3,SYSDATE,30,'�԰�');
UPDATE PRODUCT SET STOCK = STOCK + 30 WHERE PCODE = 3;
-- ����ũ ��� 5��
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,1,SYSDATE,5,'���');
UPDATE PRODUCT SET STOCK = STOCK - 5 WHERE PCODE = 1;
-- ������ �԰� 7��
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,2,SYSDATE,7,'�԰�');
UPDATE PRODUCT SET STOCK = STOCK + 7 WHERE PCODE = 2;

-- ��/��� TRIGGER ��ȯ
CREATE OR REPLACE TRIGGER TEST_TRG
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = '�԰�' THEN
        UPDATE PRODUCT SET STOCK = STOCK + :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
    ELSIF :NEW.STATUS = '���' THEN
        UPDATE PRODUCT SET STOCK = STOCK - :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,3,SYSDATE,10,'���');
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,2,SYSDATE,5,'�԰�');
INSERT INTO PRO_DETAIL VALUES(DCODE_SEQ.NEXTVAL,3,SYSDATE,5,'�԰�');

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;
COMMIT;
--------------------------------------------------------
