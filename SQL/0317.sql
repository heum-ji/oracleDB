/*
    03.17(��) ����
*/
--------------------------------------------------------------------------------
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARMENT; -- DEPT_ID

SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM EMPLOYEE; -- JOB_CODE
SELECT * FROM JOB; -- JOB_CODE

SELECT EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID);
--------------------------------------------------------------------------------
/*
     03.17(��) ����
*/
--------------------------------------------------------------------------------
/* [ SET OPERATOR ] */

-- �μ��ڵ尡 D5�� ���� ���, �̸�, �μ��ڵ�, �޿� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
-- �޿��� 300���� �̻��� ������ ���, �̸�, �μ��ڵ�, �޿� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;
-- ���ȥ / �ɺ��� �ߺ�

-- 1.  UNION : (������) : �� ��ȸ����� �ߺ��� �����͸� �����ϰ� ��ħ + ù���� �÷����� ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. UNION ALL(������) : �ߺ������� ����, ���� X
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 3. INTERSECT(������) : �������� SELECT ��� �� ����κи� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 4. MINUS(������) : ���� SELECT���� ���� SELECT�� ��ġġ �ʴ� �κи� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;
--------------------------------------------------------------------------------
/*
    [ SUB QUERY ]
*/

-- �������� ��� �޿�
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- �����߿� ������ ��ձ޿����� �޿��� ���� ����� �̸� ��ȸ
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY > 3047662;
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);

-- 1. ������ ��������
-- �������� ��ȸ����� (1�� 1��) -> 1���� ���ϰ�

-- ������ ������ ������ �̸��� ���
-- 1) ������ ������ �Ŵ������̵� ��ȸ
SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '������';
-- 2) ��ȸ�� ���̵� Ȱ���ؼ� �Ŵ��� �̸� ��ȸ
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 214;

-- SUBQUERY Ǯ��
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '������');
-- JOIN Ǯ��
SELECT E2.EMP_NAME
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID)
WHERE E1.EMP_NAME = '������';

-- 2. ������ �������� : �������� ��ȸ����� ���� �������ΰ��
-- ������ OR �ڳ��� ���� �μ��� �ִ� ������� ��ü ����
-- ���߱Ⱑ ���� �μ��ڵ�
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '������';
-- �ڳ��� ���� �μ��ڵ�
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '�ڳ���';
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������','�ڳ���');

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������','�ڳ���'));

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������','�ڳ���'));
--------------------------------------------------------------------------------