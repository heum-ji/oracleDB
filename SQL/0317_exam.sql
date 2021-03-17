/*
    03.17(수) 실습
*/

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
--------------------------------------------------------------------------------
/*
    JOIN 실습
*/
--------------------------------------------------------------------------------
-- 1.
SELECT
    EMP_NAME 사원명,
    EMP_NO 주민번호,
    DEPT_TITLE 부서명,
    JOB_NAME 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EMP_NO LIKE '7_____-2%' AND EMP_NAME LIKE '전%'; 
    
-- 2. 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE '%형%';

-- 3.
SELECT
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_CODE 부서코드,
    DEPT_TITLE 부서명
FROM
    EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE LIKE '해외영업%';

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
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE DEPT_CODE = 'D2';

-- 6.
SELECT
    EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 지역명,
    NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국','일본');

-- 7.
SELECT
    E1.EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    E2.EMP_NAME 동료이름
FROM EMPLOYEE E1
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN EMPLOYEE E2 USING (DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY 1;

-- 8.
SELECT
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    SALARY 급여
FROM EMPLOYEE
LEFT JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NULL AND JOB_NAME IN ('차장','사원');
--------------------------------------------------------------------------------
/* 
    단일행 서브쿼리 실습
*/
--------------------------------------------------------------------------------
-- 1. 윤은해와 급여가 같은 사원들을 검색해서, 사원번호, 사원이름, 급여를 출력
-- 단, 윤은해는 출력 X
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME != '윤은해' AND SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '윤은해');

-- 2. EMPLOYEE 테이블에서 급여가 가장 많은 사람과 가장 적은 사람의 정보를 출력
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE
WHERE SALARY IN( (SELECT MIN(SALARY) FROM EMPLOYEE),(SELECT MAX(SALARY) FROM EMPLOYEE) );

-- 3. D1, D2 부서에 근무하는 사원들 중 급여가 D5부서의 평균급여보다 많은 사람들만
-- 부서번호, 사원번호, 사원명, 급여 출력
SELECT DEPT_CODE 부서번호, EMP_ID 사원번호, EMP_NAME 사원명, SALARY 급여
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D1','D2') AND (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = 'D5') < SALARY;

--------------------------------------------------------------------------------
/* 
    다중행 서브쿼리 실습
*/
--------------------------------------------------------------------------------
-- 1. 차태연, 전지연 사원의 급여등급(SAL_LEVEL)과 같은 사원의 사원명, 급여 출력
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연','전지연')) AND
      EMP_NAME NOT IN ('차태연','전지연');
--------------------------------------------------------------------------------