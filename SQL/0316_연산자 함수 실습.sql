/*
    03.16(ȭ) ������ �Լ� �ǽ�
*/

-- 1. ������� �̸���, �̸��� ���̸� ����Ͻÿ�.
SELECT EMP_NAME ������, EMAIL �̸���, LENGTH(EMAIL) �̸��ϱ��� FROM EMPLOYEE;
-- 2. ������ �̸��� �̸��� �ּ� �� ���̵� �κи� ����Ͻÿ�.
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1, 1) - 1) �̸��Ͼ��̵� FROM EMPLOYEE;
-- 3. 60���� ������ ������� ��� ���ʽ����� ����Ͻÿ�.
-- �̶� ���ʽ� ���� NULL�� ��� 0�̶�� ���
SELECT EMP_NAME ������, SUBSTR(EMP_NO,1,2) ���, NVL(BONUS,0) ���ʽ� FROM EMPLOYEE WHERE SUBSTR(EMP_NO,1,1) = 6;
-- 4. 010 �ڵ�����ȣ�� ���� �ʴ� ����� ���� ����Ͻÿ�(�ڿ� ������ ���� ���ϰ�)
SELECT COUNT(*) || '��' �ο� FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';
-- 5. ������� �Ի����� ����Ͻÿ�.
SELECT EMP_NAME ������, EXTRACT(YEAR FROM HIRE_DATE)|| '��' || EXTRACT(MONTH FROM HIRE_DATE) || '��' �Ի��� FROM EMPLOYEE;
-- 6. ������� �ֹε�Ϲ�ȣ�� ��ȸ�Ͻÿ�.
-- ��, �ֹε�Ϲ�ȣ �� ������ȣ �ں��ʹ� * ���ڷ� ä���� ���
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******' �ֹε�Ϲ�ȣ FROM EMPLOYEE;
-- 7. ������, �����ڵ�, ����(��) ��ȸ
-- ��, ������ \57,000,000 �� �������� ���
-- ������ ���ʽ� ����Ʈ�� ����� 1��ġ �޿�
SELECT EMP_NAME, JOB_CODE, TO_CHAR(((SALARY + SALARY * NVL(BONUS,0)) * 12), 'L999,999,999') ���� FROM EMPLOYEE;
-- 8. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������
-- ���, �����, �μ��ڵ�, �Ի����� ��ȸ�Ͻÿ�.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D9') AND SUBSTR(HIRE_DATE,1,2) = '04';
-- 9. ������, �Ի���, ���ñ����� �ٹ��ϼ��� ��ȸ�Ͻÿ�. (�ָ�����, �Ҽ����Ʒ� ����)
SELECT EMP_NAME ������, HIRE_DATE �Ի���, FLOOR(SYSDATE - HIRE_DATE) �ٹ��ϼ� FROM EMPLOYEE;
-- 10. ��� ������ ������ ���� ���� ���̿� ���� ���� ���̸� ����Ͻÿ�(���̸� ���)
SELECT
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(MIN(SUBSTR(EMP_NO,1,2)) ,'RR')) + 1 "�ִ� ����",
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(MAX(SUBSTR(EMP_NO,1,2)) ,'RR')) + 1 "�ּ� ����"
FROM EMPLOYEE;
-- 11. ȸ�翡�� �߱��� �ؾ� �ϴ� �μ��� ��ǥ�ؾ� �Ѵ�.
-- �μ��ڵ尡 D5, D6, D9�� ��� �߱�, �׿ܴ� �߱� �������� ��µǵ��� �Ͽ���.
-- ��°��� �̸�, �μ��ڵ�, �߱�����(�μ��ڵ� ���� �������� ����)
-- �μ��ڵ尡 NULL�� ����� �߱پ���
SELECT
    EMP_NAME,
    DEPT_CODE,
        CASE
            WHEN DEPT_CODE IN('D5','D6','D9') THEN '�߱�'
            ELSE '�߱پ���'
        END
    "�߱�����"
FROM
    EMPLOYEE
ORDER BY 2;
-- 12. �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
-- ��, �μ��ڵ尡 D5, D6, D9�� ������ ������ ��ȸ
-- �μ��ڵ� ���� �������� ����
SELECT
    EMP_NAME,
    DEPT_CODE,
        CASE
            WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
            WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
            ELSE '������'
        END
    �μ���
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY 2;
-- 13. ������, �μ��ڵ�, �������, ����(��) ��ȸ
-- ��, ��������� �ֹι�ȣ���� �����ؼ�,
-- ������ ������ �����Ϸ� ��µǰ� ��.
-- ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
-- * �ֹι�ȣ�� �̻��� ������� ���ܽ�Ű�� ���� �ϵ���(200,201,214�� ����)
-- HINT : NOT IN ���
SELECT
    EMP_NAME,
    DEPT_CODE,
    /*TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'), 'YY"��"MM"��"DD"��"')*/
    SUBSTR(EMP_NO,1,2) || '�� '
     || SUBSTR(EMP_NO,3,2) || '�� '
     || SUBSTR(EMP_NO,5,2) || '�� '
     �������,
     EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) + 1
     ����
FROM
    EMPLOYEE
WHERE EMP_ID NOT IN ('200','201','214');
-- 14. �Ʒ� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�. ���������� ��ü �������� ���Ͻÿ�.
-- 1998��, 1999��, 2000��, 2001��, 2002��, 2003��, 2004��, ��ü������
-- HINT : TO_CHAR, DECODE, SUM �̿�
-- ��Ǯ��
SELECT
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'1998',1,0)) "1998��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'1999',1,0)) "1999��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2000',1,0)) "2000��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2001',1,0)) "2001��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2002',1,0)) "2002��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2003',1,0)) "2003��",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2004',1,0)) "2004��",
    COUNT(*) ��ü������
FROM
    EMPLOYEE;
-- ����� Ǯ��
-- 1) SUM : �ش� �÷��� �� �� 
SELECT 
    SUM(DECODE(EXTRACT(YEAR FROM HIRE_DATE),1998,1,0)) "1998��"
FROM EMPLOYEE;
-- 2) COUNT : NULL�� ������ ����
SELECT 
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),1999,1)) "1999��"  
FROM EMPLOYEE;