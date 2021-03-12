SELECT * FROM EMPLOYEE;
SELECT EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J5';
-- EMPLOYEE ���̺��� �����, ��ȭ��ȣ, ���� ��ȸ
SELECT EMP_NAME,PHONE,SALARY FROM EMPLOYEE;
-- EMPLOYEE ���̺��� �����, ��ȭ��ȣ, ���� ��ȸ/ ������ 300���� �̻��� ����� ��ȸ
SELECT EMP_NAME,PHONE,SALARY FROM EMPLOYEE WHERE SALARY >= 3000000;
-- EMPLOYEE ���̺��� �����, ��ȭ��ȣ, ���� ��ȸ/ ������ 300���� �̻��̸鼭 �����ڵ尡 J3�� ����� ��ȸ -> &
SELECT EMP_NAME,PHONE,SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY >= 3000000 AND JOB_CODE = 'J3';
-- EMPLOYEE ���̺��� �����, ����, ���� ��ȸ
SELECT EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;
-- EMPLOYEE ���̺��� �����, ����, ���� ��ȸ - �÷��� �̸�/����/�������� ����
SELECT EMP_NAME �̸�, SALARY "����(��)", SALARY * 12 ���� FROM EMPLOYEE; --�÷��� Ư�����ڰ� ���� ��� ""������ ����ؾ� ��
--������ COLUMN�� ���� �� ����
SELECT EMP_NAME, SALARY,'��' FROM EMPLOYEE;
/* 
�ǽ� 
-- EMPLOYEE ���̺��� �̸�, ����, �Ѽ��ɾ�(���ʽ��� ���Ե� �ݾ�), �Ǽ��ɾ�(�� ���ɾ� - ����*���� 3%)) ���
-- ���ʽ��� ������ �Ŵ� �����
*/
SELECT
    EMP_NAME �̸�,
    SALARY * 12 ����,
    ( SALARY + ( SALARY * BONUS / 10 ) ) * 12 "�Ѽ��ɾ�(���ʽ� ����)",
    ( SALARY + ( SALARY * BONUS / 10 ) ) * 12 - ( SALARY * 0.03 * 12 ) "�Ǽ��ɾ�(���� ����)"
FROM
    EMPLOYEE;

--��¥ +1 -> ������ ��¥, ��¥ -1 -> ���� ��¥, ������ ��¥ - ���� ��¥ // FLOOR �Ҽ�������
SELECT EMP_NAME �̸�, FLOOR(SYSDATE-HIRE_DATE) �ٹ��ϼ� FROM EMPLOYEE;

/*
�ǽ�
EMPLOYEE ���̺��� 20�� �̻� �ټ��� ������ �̸�, ����, ���ʽ����� ���
*/
SELECT
    EMP_NAME �̸�,
    SALARY ����,
    BONUS ���ʽ���
FROM
    EMPLOYEE
WHERE
    FLOOR(SYSDATE-HIRE_DATE) / 365 >= 20;

-- DISTINCT / �ߺ��� ����
SELECT DISTINCT
    JOB_CODE
FROM
    EMPLOYEE;
-- ���� ������
SELECT EMP_NAME �̸�, SALARY || '��' ���� FROM EMPLOYEE;
-- �������� ������ ������ �ϳ��� �� ����� ������ִ� ������
-- �μ��ڵ尡 D6�̰� �޿��� 200�������� ���� �޴� ������ �̸�, �μ��ڵ�
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY
FROM
    EMPLOYEE
WHERE
    DEPT_CODE = 'D6' AND SALARY > 2000000;

-- �޿��� 350�������� ���� �ް� 600�������� ���� �޴� ������ �̸��� �޿� ��ȸ
SELECT 
    EMP_NAME,
    SALARY
FROM   
    EMPLOYEE
WHERE
    SALARY >= 3500000 AND SALARY <= 6000000;
    
-- BETWWEN A AND B // A�̻� B����
SELECT 
    EMP_NAME,
    SALARY
FROM   
    EMPLOYEE
WHERE
    SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE ���̺��� ����� 90/01/01 ~ 01/01/01�� ����� ��ü���� ���
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- LIKE ������ '%', '_' -> ���ϵ�ī��
-- ���ϵ�ī�� : �ƹ��ų� ��ü�ؼ� ����� �� �ִ� ��
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '��%'; -- %�� ���ڼ��� ������� ��� ��
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '��__'; -- _�� �ѱ��ڸ� ��ü
SELECT * FROM EMPLOYEE;

/*
�ǽ�
�̸��� '��'�� ���ԵǾ��ִ� ������ ��� ���� ���
*/
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '%��%';
-- EMAIL �� ID �� _ ���ڸ��� 3�ڸ��� ���� ��� ���� ��� + ESCAPE�ɼ� 
SELECT * FROM EMPLOYEE WHERE EMAIL LIKE '___#_%' ESCAPE '#';
-- NOT LIKE
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE EMP_NAME NOT LIKE '��%'; -- ������ �ƴ� �����

--03.12(��) GITHUB COMMIT TEST