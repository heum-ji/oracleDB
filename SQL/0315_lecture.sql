/* 
    �ǽ�
    1. EMPLOYEE ���̺��� �̸� ���� ������ ������ ��� �̸� ���
    2. EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ ���
    3. EMPLOYEE ���̺��� �����ּҿ� 's'�� ���鼭, DEPT_CODE�� D9 �Ǵ� D6�̸�,
        ������� 90/01/01 ~ 00/12/01 �̸鼭, ������ 270���� �̻��� ����� ��ü���� ���
*/

-- 1. EMPLOYEE ���̺��� �̸� ���� ������ ������ ��� �̸� ���
SELECT EMP_NAME "�̸�" FROM EMPLOYEE WHERE EMP_NAME LIKE '%��';
-- 2. EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ ���
SELECT EMP_NAME "�̸�", PHONE "��ȭ��ȣ" FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';
/*
    3. 
    EMPLOYEE ���̺��� �����ּҿ� 's'�� ���鼭, DEPT_CODE�� D9 �Ǵ� D6�̸�,
    ������� 90/01/01 ~ 00/12/01 �̸鼭, ������ 270���� �̻��� ����� ��ü���� ���
*/
SELECT * FROM EMPLOYEE
WHERE
    EMAIL LIKE '%s%' AND
    (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') AND
    (HIRE_DATE BETWEEN '90/01/01' AND '00/12/01') AND
    SALARY >= 2700000;
    
-- IS NULL / IS NOT NULL
-- �����ڵ� ����, �μ���ġ�� ���� ���� ���� (�μ��ڵ�(DEPT_CODE)�� NULL�� ����) �̸� ��ȸ
SELECT * FROM EMPLOYEE WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NOT NULL;

-- IN / NOT IN
-- �μ��ڵ尡 D6 �̰ų� D9�� ���� ��ü���� ��ȸ + �μ��ڵ� D2�� ���� ���� ����
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D9' OR DEPT_CODE = 'D2';
-- IN () �ȿ� ��ҵ� �߰��ϸ� �� - OR / NOT IN �ݴ�
SELECT * FROM EMPLOYEE WHERE DEPT_CODE NOT IN ('D6', 'D9', 'D2');

-- �μ��� �� �����ڵ�(JOB_CODE)�� J7 �Ǵ� J2 �̰�, �޿��� 200���� �ʰ��� ����� �̸�, �޿�, �����ڵ�
-- ������ �켱���� �ǽ�
SELECT
    EMP_NAME,
    SALARY,
    JOB_CODE
FROM
    EMPLOYEE
WHERE
    (JOB_CODE = 'J7'
OR
    JOB_CODE = 'J2')
AND
    SALARY > 2000000;
    
-- ORDER BY (DEFAULT : ASC)
-- ��������(ASC)
-- ���� : ���� �� -> ū ��
-- ��¥ : ������ -> ���� ��
-- ���� : ������

-- ��������(DESC)
-- ū �� -> ���� ��
-- ��¥ : ���� �� -> ���� ��
-- ���� : ���� ����

SELECT * FROM EMPLOYEE ORDER BY EMP_NAME DESC;
SELECT EMP_ID, EMP_NAME, EMAIL, SALARY FROM EMPLOYEE ORDER BY SALARY;
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY 3; -- SELECT�� COLUMN ���� 1���� ����
/*
    03.15(��) �ǽ�
*/
-- ���� 1. �Ի����� 5�� �̻�, 10�� ������ ������ �̸�, �ֹι�ȣ, �޿�, �Ի����� �˻��Ͽ���.
SELECT
    EMP_NAME �̸�,
    EMP_NO �ֹι�ȣ,
    SALARY �޿�,
    HIRE_DATE �Ի���
FROM
    EMPLOYEE
WHERE
    ( SYSDATE - HIRE_DATE ) / 365 BETWEEN 5 AND 10;
-- ���� 2. �������� �ƴ� ������ �̸�, �μ��ڵ带 �˻��Ͽ��� (��� ���� : ENT_YN)
SELECT
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE,
    FLOOR(ENT_DATE - HIRE_DATE)
     || '��' "�ٹ� �Ⱓ",
    ENT_DATE
FROM
    EMPLOYEE
WHERE
    ENT_YN = 'Y';
-- ���� 3.
-- �ټӳ���� 10�� �̻��� �������� �˻��Ͽ�
-- ��� ����� �̸�, �޿�, �ټӳ���� ������������ �����Ͽ� ����Ͽ���
-- ��, �޿��� 50%�λ�� �޿��� ��� �ǵ��� �Ͽ���.
SELECT
    EMP_NAME,
    SALARY * 1.5 "�λ� �޿�",
    (SYSDATE - HIRE_DATE) / 365 "�ټӳ��"
FROM
    EMPLOYEE
WHERE
    ( ( SYSDATE - HIRE_DATE ) / 365 ) >= 10
ORDER BY 3;
-- ���� 4.
-- �Ի����� 99/01/01 ~ 10/01/01 �� ��� �߿��� �޿��� 2000000 �� ������ �����
-- �̸�, �ֹι�ȣ, �̸���, ����ȣ, �޿��� �˻� �Ͻÿ�
SELECT
    EMP_NAME,
    EMP_NO,
    EMAIL,
    PHONE,
    SALARY
FROM EMPLOYEE
WHERE
    (HIRE_DATE BETWEEN '99/01/01' AND '10/01/01') AND
    SALARY <= 2000000;
-- ���� 5.
-- �޿��� 200000�� ~ 3000000�� �� ������ �߿��� 4�� �����ڸ� �˻��Ͽ�
-- �̸�, �ֹι�ȣ, �޿�, �μ��ڵ带 �ֹι�ȣ ������(��������) ����Ͽ���
SELECT
    EMP_NAME,
    EMP_NO,
    SALARY,
    DEPT_CODE
FROM EMPLOYEE
WHERE
    (SALARY BETWEEN 2000000 AND 3000000) AND
    EMP_NO LIKE '__04__-2%'
ORDER BY 2 DESC;
-- ���� 6.
-- ���� ��� �� ���ʽ��� ���� ����� ���ñ��� �ٹ����� �����Ͽ�
-- 1000�� ����(�Ҽ��� ����)
-- �޿��� 10% ���ʽ��� ����Ͽ� �̸�, Ư�� ���ʽ� (��� �ݾ�) ����� ����Ͽ���.
-- ��, �̸� ������ �������� �����Ͽ� ����Ͽ���.
SELECT
    EMP_NAME,
    ( SALARY * 0.1 ) * FLOOR( (SYSDATE - HIRE_DATE) / 1000 )  "Ư�� ���ʽ�"
FROM
    EMPLOYEE
WHERE
    EMP_NO LIKE '%-1%' AND BONUS IS NULL
ORDER BY 1;

/* 
    [ �Լ� ]
    1. ����ó���ϴ� �Լ�
*/
-- 1) LENGTH : �־��� �� �Ǵ� �÷��� ���ڿ� ����(���� ����) �� ��ȯ�ϴ� �Լ�
SELECT EMP_NAME, LENGTH(EMP_NAME), EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;
-- 2) LENGTHB : �־��� �� �Ǵ� �÷��� ���ڿ� ����(BYTE)�� ��ȯ �ϴ� �Լ�
SELECT EMP_NAME, LENGTHB(EMP_NAME), EMAIL, LENGTHB(EMAIL) FROM EMPLOYEE;
-- 3) INSTR : ã�� ����(��)�� ������ ��ġ���� ������ Ƚ����ŭ ��Ÿ�� ��ġ�� ��ȯ -- �׻� ���ۺ����� ��ġ�� ��ȯ / -1�� �ڿ�������
SELECT INSTR('Hello World Hi High', 'H', -1, 1) FROM DUAL;

-- EMPLOYEE ���̺��� EMAIL�÷����� @�� ��ġ�� ���
SELECT EMAIL, INSTR(EMAIL, '@', 1, 1) "@ ��ġ" FROM EMPLOYEE;

-- 4) LPAD / RPAD : �־��� �÷� ���ڿ��� ������ ���ڿ��� ����/�����ʿ� ���ٿ� ���� N�� ���ڿ��� ��ȯ
SELECT EMAIL, LENGTH(EMAIL), LPAD(EMAIL, 20, '#'), RPAD(EMAIL, 20, '#') FROM EMPLOYEE;
SELECT EMAIL, LPAD(EMAIL, INSTR(EMAIL, '@', 1, 1) - 1, '#') FROM EMPLOYEE; -- @�ձ��� �ڸ��� // LPAD���� �ѱ� 2BYTE / BYTE ����

-- 5) LTRIM / RTRIM : �־��� �÷��̳� ���ڿ��� ���� �Ǵ� �����ʿ��� ������ STR�� ���Ե� ��� ���ڸ� ������ ������ ��ȯ
SELECT 'aaaKH' FROM DUAL;
SELECT LTRIM('aaaKH', 'a') FROM DUAL;
SELECT LTRIM('aaaKaH', 'a') FROM DUAL; -- �ٸ� ���ڰ� ������ ���� / KaH ��µ�
SELECT RTRIM('aaaKHaaa', 'a') FROM DUAL;
SELECT LTRIM('ABACAAABCKH', 'AB') FROM DUAL; -- �ش� ���� �� ����� EX) A OR B �� ���� - CAAABCKH ���

-- 6) TRIM : �־��� �÷��̳� ���ڿ� ��/��/���ʿ� �ִ� ������ ���ڸ� ������ �������� ��ȯ
-- ���ڸ� �Ÿ��� ���� / ���� �Ұ�
SELECT TRIM(LEADING 'a' FROM 'aaaKHaaa') FROM DUAL; -- LEADING : �ո� �����
SELECT TRIM(TRAILING 'a' FROM 'aaaKHaaa') FROM DUAL; -- LEADING : �ո� �����
SELECT TRIM(BOTH 'a' FROM 'aaaKHaaa') FROM DUAL;  -- BOTH : ���� // DEFAULT BOTH ���� ����

SELECT TRIM(LEADING 'B' FROM TRIM(LEADING 'A' FROM 'ABACAAABCKH')) FROM DUAL; -- A�ڸ��� B �߶� 'AB' �ڸ��� ����

SELECT RTRIM(DEPT_TITLE, '��') FROM DEPARTMENT;
SELECT TRIM(TRAILING '��' FROM DEPT_TITLE) FROM DEPARTMENT;

-- DUAL ���̺� ���
-- '982341678934509hello89798739273402' ���ڿ� �� �� ��� ���� ����
SELECT RTRIM( LTRIM('982341678934509hello89798739273402', '0123456789'), '0123456789' ) FROM DUAL;

-- 7) SUBSTR : �÷��̳� ���ڿ����� ������ ��ġ���� ������ ������ ���ڿ��� �߶󳻾� ����
SELECT SUBSTR( 'SHOWMETHEMONEY',1,4 ) FROM DUAL;
SELECT SUBSTR( 'SHOWMETHEMONEY',5,2 ) FROM DUAL;
SELECT SUBSTR( 'SHOWMETHEMONEY',-8,2 ) FROM DUAL; -- '-'�� ��� �ڿ��� ���� ���� �տ��� ���� �߶�
-- EMPLOYEE ���̺��� ����� �� ���� ���
SELECT DISTINCT( SUBSTR(EMP_NAME, 1, 1) ) "��" FROM EMPLOYEE; -- DISTINCT() �ߺ�����

-- EMPLOYEE ���̺��� ���ڸ� �����ȣ, �����, �ֹι�ȣ, ����
-- �ֹι�ȣ �� 6�ڸ��� *ó�� EX) 990101-1******

SELECT
    EMP_ID,
    EMP_NAME,
    SUBSTR(EMP_NO, 1, 8) || '******' "EMP_NO",
    SALARY
FROM
    EMPLOYEE
WHERE EMP_NO LIKE '%-1%';

-- 8) LOWER / UPPER / INITCAP
SELECT LOWER('Welcome To My World') FROM DUAL;
SELECT UPPER('Welcome To My World') FROM DUAL;
SELECT INITCAP('welcome to my world') FROM DUAL;

-- 9) CONCAT : �÷��� ���� Ȥ�� ���ڿ� �� ���� ���޹޾� �ϳ��� ��ģ �� ����
SELECT CONCAT('�����ٶ�', 'ABCD') FROM DUAL;
SELECT '�����ٶ�' || 'ABCD' || '�ȳ��ϼ���' FROM DUAL;

-- 10) REPLACE : ���ڿ��� ��ȯ
SELECT REPLACE('NEXT007@nate.com', 'nate.com', 'iei.or.kr') FROM DUAL;

/* 
    [ �Լ� ]
    2. ���� ó�� �Լ�
*/

-- 1) ABS : ���밪
SELECT ABS(10) FROM DUAL;
SELECT ABS(-10) FROM DUAL;

-- 2) MOD : ���ڷ� ���� ���ڸ� ������ �������� ���ϴ� �Լ�
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(10,2) FROM DUAL;
SELECT MOD(10,4) FROM DUAL;

-- 3) ROUND / FLOOR / CEIL : �ݿø�/����/�ø�
SELECT FLOOR(126.465) FROM DUAL;
SELECT CEIL(126.465) FROM DUAL;
SELECT ROUND(126.465, 2) FROM DUAL;
SELECT ROUND(126.465, -2) FROM DUAL;

/* 
    [ �Լ� ]
    3. ��¥ ó�� �Լ�
*/
-- 1) SYSDATE : �ý��ۿ� ����� ���� ��¥�� ��ȯ
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP, CURRENT_TIMESTAMP FROM DUAL;
-- 2) MONTHS_BETWEEN : ��¥ �� ���� ���� �޾�, ���� �� ���̸� ���������� ����
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE,HIRE_DATE) FROM EMPLOYEE;
-- 3) ADD_MONTHS : ���ڷ� ���޹��� ��¥�� ���ڷ� ���޹��� ���ڸ�ƴ ���� ���� ���ؼ� ��¥�� ����
SELECT SYSDATE FROM DUAL;
SELECT ADD_MONTHS(SYSDATE,4) FROM DUAL;  -- 4���� ��
SELECT SYSDATE + 10 FROM DUAL; -- 10�� ��
SELECT ADD_MONTHS(SYSDATE + 16,1) FROM DUAL; -- ADD_MONTHS �ڵ����� ������ �� ��� ��� ����
-- 4) NEXT_DAY : ���ڷ� ���� ���� ��¥�� ���ڷ� ���� ���� ���� �� ���� ����� ���� ����
-- 1 = �Ͽ���....7 = �����
SELECT NEXT_DAY(SYSDATE, '��') FROM DUAL;

-- 5) LAST_DAY : ���ڷ� ���޹��� ��¥�� ���� ���� ������ ��¥�� ���Ͽ� ����
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 6) EXTRACT : ��¥ �����Ϳ��� �⵵, ��, �� ������ ����
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL; --YEAR
SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL; --MONTH
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL; --DAY

-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, ������ ���
-- ��, �Ի��� YYYY��M��D�Ϸ� ���
-- ���� ��� �� �Ҽ����̸� �ø����� ���(29.124 -> 30)
-- ��� �� ������ �Ի��� ���� ��������
SELECT
    EMP_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) || '��' ||
    EXTRACT(MONTH FROM HIRE_DATE) || '��' ||
    EXTRACT(DAY FROM HIRE_DATE) || '��' �Ի���,
    CEIL( (SYSDATE - HIRE_DATE) / 365 ) ����
FROM EMPLOYEE
ORDER BY 2;

/* 
    [ �Լ� ]
    4. ����ȯ �Լ�
*/

-- 1) TO_CHAR : ��¥�������� ���� �����͸� ������ �����ͷ� ��ȯ�Ͽ� ����
-- TO_CHAR([����/��¥������],����)
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL; -- MM/DD ��/�ϳ�¥
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD/DAY') FROM DUAL; -- DY : ���ϻ��� ���ڸ���
SELECT TO_CHAR(SYSDATE,'YYYY-MONTH/DD') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-MONTH/DD/PM HH12"��"MI"��"SS"��"') FROM DUAL; -- MI ��
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD/PM HH24"��"MI"��"SS"��"') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'FMYYYY/MM/DD/PM HH24"��"MI"��"SS"��"') FROM DUAL; -- FM ���ڸ� 0��

SELECT TO_CHAR(1000000,'999,999,999') FROM DUAL; -- �ڸ��� ���ڶ� ���'#####' ���� ����
SELECT TO_CHAR(1000000,'000,000,000') FROM DUAL; -- �� �ڸ� 0���� ä�� ��
SELECT TO_CHAR(1000000, 'L999,999,999') FROM DUAL; -- ��ġ�� �� ���� ȭ�� ���� ���
SELECT TO_CHAR(1000000, '$999,999,999') FROM DUAL; -- $ ��ο� ���

-- 2) TO_DATE : ���� Ȫ�� ������ �����͸� ��¥�� �����ͷ� ��ȯ�Ͽ� ����
-- TO_DATE([����/����], ����)
SELECT TO_DATE(20210201,'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('20210709','YYYYMMDD') FROM DUAL;
-- �ð� ���� ���ϴ� ��� 0���� �ʱ�ȭ
SELECT TO_CHAR(TO_DATE(20210201,'YYYYMMDD'),'YYYY/MM/DD/HH24"��"MI"��"SS"��"') FROM DUAL;

-- 3) TO_NUMBER : ���� �����͸� ���� Ÿ������ ��ȯ�Ͽ� ����
SELECT TO_NUMBER('1,000,000','9,999,999') FROM DUAL;
SELECT TO_NUMBER('100') FROM DUAL; -- ���ڰ� �ƴ� ���ڿ��� ��ȯ �Ұ���

SELECT '1000' + '100' FROM DUAL; -- Oracle���� + �����ڴ� �׻� NUMBER ���� / ���������� number �ƴ� ��� ����

-- 5. ��Ÿ�Լ�
-- 1) NVL : NULL�� �Ǿ��ִ� �÷��� ���� ������ ���� Ȥ�� ���ڷ� �����Ͽ� ����
SELECT SALARY, BONUS, ((SALARY + SALARY * BONUS) * 12) FROM EMPLOYEE;
SELECT SALARY, NVL(BONUS,0), ( ( SALARY + SALARY * NVL(BONUS,0) ) * 12 ) FROM EMPLOYEE;
SELECT EMP_NAME, NVL(DEPT_CODE, '�μ�����') FROM EMPLOYEE;

-- 2) DECODE : �������� ��쿡 ������ �� �� �ִ� ����� ����
-- DECODE(ǥ����, ����1, ���1, ����2, ���2, ����3, ���3,....)

/*
    SWITCH(ǥ����) {
    CASE ����1 : ���1; break;
    ��İ� ����
*/

SELECT
    EMP_NAME,
    EMP_NO,
    DECODE(SUBSTR(EMP_NO,8,1), '1', '����', '����') ���� -- ������ ���ڷ� ������ �� �ָ� DEFAULT ���
FROM EMPLOYEE;

-- 3) CASE : �������� ��쿡 ������ �� �� �ִ� ����� ����(�������� ����)
SELECT
    EMP_NAME,
    EMP_NO,
        CASE
            WHEN SUBSTR(EMP_NO,8,1) = 1 THEN '����'
            ELSE '��������'
        END
    ����
FROM
    EMPLOYEE;
/*
    �ǽ�
*/
-- EMPLOYEE ���̺��� 60��� �� �� 65�� �̸��� "60��� �ʹ�", 65��� �̻��� "60��� �Ĺ�" ���� ���
-- ��, �̸��� ���� ����Ұ�
SELECT
    EMP_NAME �̸�,
    EMP_NO,
        CASE
            WHEN SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 64 THEN '60���� �ʹ�'
            ELSE '60���� �Ĺ�'
        END
    "1960"
FROM
    EMPLOYEE
WHERE
    SUBSTR(EMP_NO,1,1) = 6
ORDER BY 2;