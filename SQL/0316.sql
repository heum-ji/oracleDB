/* 
    03.16(화) - 그룹 함수
    - 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등을 하나의 컬럼으로 리턴
*/

-- 1) SUM : 해당 컬럼의 총 합을 구함
-- NULL은 자동으로 더하지 않음
SELECT EMP_NAME, SALARY FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE; -- ROW 숫자가 다르기 때문에 일반 COLUMN과 쓸 수 없음
SELECT EMP_NAME FROM EMPLOYEE;
-- 남성직원들의 급여 총합
SELECT SUM(SALARY) FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 1; 
-- 부서코드가 D2인 직원들의 급여 총합
SELECT SUM(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D2';
-- 전체 직원의 보너스를 포함한 연봉 총합
SELECT SUM(( SALARY + (SALARY * NVL(BONUS,0)) ) * 12) FROM EMPLOYEE;

-- 2) AVG : 평균
-- 전직원의 급여 평균
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- 여직원들의 급여 평균
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2;
-- 전 직원의 보너스 평균
SELECT AVG(NVL(BONUS,0)) FROM EMPLOYEE;
-- 보너스를 받는 직원들의 보너스 평균
SELECT AVG(BONUS) FROM EMPLOYEE; -- DATA NULL 제외한 평균

-- 3) COUNT : 테이블에서 조건을 만족하는 행의 갯수 반환
SELECT COUNT(*) FROM EMPLOYEE;
-- 남자 직원 수
SELECT COUNT(*) FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 1;

-- 4) MIN/MAX : 최소값/최대값
SELECT MIN(SALARY), MAX(SALARY) FROM EMPLOYEE;
-- DATE 타입도 가능
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEE;

-- 그룹함수끼리는 사용 가능 / ROW 값이 같기 때문
SELECT
    SUM(SALARY) 급여합계,
    FLOOR(AVG(SALARY)) 급여평균,
    COUNT(*) 직원수,
    MAX(SALARY) 최고급여,
    MIN(SALARY) 최소급여
FROM
    EMPLOYEE;
    
/*
    GROUP BY
*/
SELECT DEPT_CODE FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE;

SELECT DEPT_CODE "테스트", SUM(SALARY)"호잇" FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY 테스트;
SELECT DEPT_CODE, COUNT(*) FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY 1;

SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별, COUNT(*) FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여');
-- 부서별 평균 급여
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE;
-- 평균 급여가 300만원이 넘는 부서의 코드와, 평균급여 // HAVING : GROUP함수 동작 후 동작 // WHERE : GROUP함수 동작 전 동작
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE HAVING FLOOR(AVG(SALARY)) > 3000000;
-- ROLLUP, CUBE

/*
    JOIN
    
*/

SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

-- 조건에서 연결하는 컬럼의 이름이 다른 경우
-- 1. 오라클 전용문법
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 2. 표준 문법
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 조건에서 연결하는 컬럼의 이름이 같은 경우
-- 1. 오라클 문법
SELECT EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- 2. 표준 문법
SELECT EMP_NAME, JOB_CODE, JOB_NAME FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

-- INNER JOIN : 조건식에 일치하는 데이터만 출력
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- OUTER JOIN : 조건식에 일치하지 않는 데이터도 출력 (LEFT, RIGHT, FULL)
-- 1) LEFT JOIN - 불일치 LEFT TABLE 출력
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) RIGHT JOIN - 불일치 RIGHT TABLE 출력
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 3) FULL JOIN - 
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- CROSS JOIN : 카테이션 프로덕트, JOIN 되는 테이블의 각 행들이 모두 매핑된 데이터
-- 조건절이 필요없음
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT ORDER BY 1;

-- SELF JOIN : 자기자신과 JOIN
SELECT E1.EMP_NAME 사원이름, E1.MANAGER_ID, E2.EMP_NAME 관리자이름 FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

-------------------------------------------
CREATE TABLE MANAGER_TBL
AS
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

SELECT * FROM MANAGER_TBL;
SELECT * FROM EMPLOYEE;
-- JOIN
SELECT E1.EMP_NAME 사원이름, E1.MANAGER_ID 매니저ID, M1.EMP_NAME 매니저이름, M1.EMP_ID 비교용매니저ID
FROM EMPLOYEE E1
JOIN MANAGER_TBL M1 ON (E1.MANAGER_ID = M1.EMP_ID);
-- SELF JOIN
SELECT E1.EMP_NAME 사원이름, E1.MANAGER_ID 매니저ID, E2.EMP_NAME 매니저이름, E2.EMP_ID 비교용매니저ID
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

-------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;

-- EMPLOYEE + DEPARYMENT JOIN 후 LOCATION이랑 JOIN됨
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE);

-- 
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

SELECT DISTINCT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);