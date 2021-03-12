SELECT * FROM EMPLOYEE;
SELECT EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J5';
-- EMPLOYEE 테이블에서 사원명, 전화번호, 월급 조회
SELECT EMP_NAME,PHONE,SALARY FROM EMPLOYEE;
-- EMPLOYEE 테이블에서 사원명, 전화번호, 월급 조회/ 월급이 300만원 이상인 사람만 조회
SELECT EMP_NAME,PHONE,SALARY FROM EMPLOYEE WHERE SALARY >= 3000000;
-- EMPLOYEE 테이블에서 사원명, 전화번호, 월급 조회/ 월급이 300만원 이상이면서 직급코드가 J3인 사람만 조회 -> &
SELECT EMP_NAME,PHONE,SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY >= 3000000 AND JOB_CODE = 'J3';
-- EMPLOYEE 테이블에서 사원명, 월급, 연봉 조회
SELECT EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;
-- EMPLOYEE 테이블에서 사원명, 월급, 연봉 조회 - 컬럼명 이름/월급/연봉으로 수정
SELECT EMP_NAME 이름, SALARY "월급(원)", SALARY * 12 연봉 FROM EMPLOYEE; --컬럼명에 특수문자가 들어가는 경우 ""무조건 사용해야 함
--가상의 COLUMN도 만들 수 있음
SELECT EMP_NAME, SALARY,'원' FROM EMPLOYEE;
/* 
실습 
-- EMPLOYEE 테이블에서 이름, 연봉, 총수령액(보너스가 포함된 금액), 실수령액(총 수령액 - 월급*세금 3%)) 출력
-- 보너스와 세금은 매달 적용됨
*/
SELECT
    EMP_NAME 이름,
    SALARY * 12 연봉,
    ( SALARY + ( SALARY * BONUS / 10 ) ) * 12 "총수령액(보너스 포함)",
    ( SALARY + ( SALARY * BONUS / 10 ) ) * 12 - ( SALARY * 0.03 * 12 ) "실수령액(세금 포함)"
FROM
    EMPLOYEE;

--날짜 +1 -> 다음날 날짜, 날짜 -1 -> 어제 날짜, 다음날 날짜 - 어제 날짜 // FLOOR 소수점버림
SELECT EMP_NAME 이름, FLOOR(SYSDATE-HIRE_DATE) 근무일수 FROM EMPLOYEE;

/*
실습
EMPLOYEE 테이블에서 20년 이상 근속한 직원의 이름, 월급, 보너스율을 출력
*/
SELECT
    EMP_NAME 이름,
    SALARY 월급,
    BONUS 보너스율
FROM
    EMPLOYEE
WHERE
    FLOOR(SYSDATE-HIRE_DATE) / 365 >= 20;

-- DISTINCT / 중복값 제거
SELECT DISTINCT
    JOB_CODE
FROM
    EMPLOYEE;
-- 연결 연산자
SELECT EMP_NAME 이름, SALARY || '원' 월급 FROM EMPLOYEE;
-- 논리연산자 여러개 조건을 하나의 논리 결과로 만들어주는 연산자
-- 부서코드가 D6이고 급여를 200만원보다 많이 받는 직원의 이름, 부서코드
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY
FROM
    EMPLOYEE
WHERE
    DEPT_CODE = 'D6' AND SALARY > 2000000;

-- 급여를 350만원보다 많이 받고 600만원보다 적게 받는 직원의 이름과 급여 조회
SELECT 
    EMP_NAME,
    SALARY
FROM   
    EMPLOYEE
WHERE
    SALARY >= 3500000 AND SALARY <= 6000000;
    
-- BETWWEN A AND B // A이상 B이하
SELECT 
    EMP_NAME,
    SALARY
FROM   
    EMPLOYEE
WHERE
    SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE 테이블에서 고용일 90/01/01 ~ 01/01/01인 사원의 전체내용 출력
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- LIKE 연산자 '%', '_' -> 와일드카드
-- 와일드카드 : 아무거나 대체해서 사용할 수 있는 것
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '전%'; -- %는 글자수와 상관없이 모든 값
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '전__'; -- _는 한글자를 대체
SELECT * FROM EMPLOYEE;

/*
실습
이름에 '유'가 포함되어있는 직원의 모든 정보 출력
*/
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '%유%';
-- EMAIL 중 ID 중 _ 앞자리가 3자리인 직원 모든 정보 출력 + ESCAPE옵션 
SELECT * FROM EMPLOYEE WHERE EMAIL LIKE '___#_%' ESCAPE '#';
-- NOT LIKE
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE EMP_NAME NOT LIKE '전%'; -- 전씨가 아닌 사람들

--03.12(금) GITHUB COMMIT TEST