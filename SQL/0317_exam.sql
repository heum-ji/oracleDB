/*
    03.17(��) �ǽ�
*/

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
--------------------------------------------------------------------------------
/*
    JOIN �ǽ�
*/
--------------------------------------------------------------------------------
-- 1.
SELECT
    EMP_NAME �����,
    EMP_NO �ֹι�ȣ,
    DEPT_TITLE �μ���,
    JOB_NAME ���޸�
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EMP_NO LIKE '7_____-2%' AND EMP_NAME LIKE '��%'; 
    
-- 2. 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE '%��%';

-- 3.
SELECT
    EMP_NAME �����,
    JOB_NAME ���޸�,
    DEPT_CODE �μ��ڵ�,
    DEPT_TITLE �μ���
FROM
    EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE LIKE '�ؿܿ���%';

-- 4. 
SELECT 
    EMP_NAME,
    BONUS,
    DEPT_TITLE,
    LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 5.
SELECT
    EMP_NAME �����,
    JOB_NAME ���޸�,
    DEPT_TITLE �μ���,
    LOCAL_NAME �ٹ�������
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE DEPT_CODE = 'D2';

-- 6.
SELECT
    EMP_NAME �����,
    DEPT_TITLE �μ���,
    LOCAL_NAME ������,
    NATIONAL_NAME ������
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('�ѱ�','�Ϻ�');

-- 7.
SELECT
    E1.EMP_NAME �����,
    DEPT_TITLE �μ���,
    E2.EMP_NAME �����̸�
FROM EMPLOYEE E1
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN EMPLOYEE E2 USING (DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY 1;

-- 8.
SELECT
    EMP_NAME �����,
    JOB_NAME ���޸�,
    SALARY �޿�
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NULL AND JOB_NAME IN ('����','���');
--------------------------------------------------------------------------------
/* 
    ������ �������� �ǽ�
*/
--------------------------------------------------------------------------------
-- 1. �����ؿ� �޿��� ���� ������� �˻��ؼ�, �����ȣ, ����̸�, �޿��� ���
-- ��, �����ش� ��� X
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME != '������' AND SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '������');

-- 2. EMPLOYEE ���̺��� �޿��� ���� ���� ����� ���� ���� ����� ������ ���
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE
WHERE SALARY IN( (SELECT MIN(SALARY) FROM EMPLOYEE),(SELECT MAX(SALARY) FROM EMPLOYEE) );

-- 3. D1, D2 �μ��� �ٹ��ϴ� ����� �� �޿��� D5�μ��� ��ձ޿����� ���� ����鸸
-- �μ���ȣ, �����ȣ, �����, �޿� ���
SELECT DEPT_CODE �μ���ȣ, EMP_ID �����ȣ, EMP_NAME �����, SALARY �޿�
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D1','D2') AND (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = 'D5') < SALARY;

--------------------------------------------------------------------------------
/* 
    ������ �������� �ǽ�
*/
--------------------------------------------------------------------------------
-- 1. ���¿�, ������ ����� �޿����(SAL_LEVEL)�� ���� ����� �����, �޿� ���
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('���¿�','������')) AND
      EMP_NAME NOT IN ('���¿�','������');
--------------------------------------------------------------------------------