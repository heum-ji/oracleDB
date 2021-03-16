/*
    03.16(화) 연산자 함수 실습
*/

-- 1. 직원명과 이메일, 이메일 길이를 출력하시오.
SELECT EMP_NAME 직원명, EMAIL 이메일, LENGTH(EMAIL) 이메일길이 FROM EMPLOYEE;
-- 2. 직원의 이름과 이메일 주소 중 아이디 부분만 출력하시오.
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1, 1) - 1) 이메일아이디 FROM EMPLOYEE;
-- 3. 60년대생 직원의 직원명과 년생 보너스값을 출력하시오.
-- 이때 보너스 값이 NULL인 경우 0이라고 출력
SELECT EMP_NAME 직원명, SUBSTR(EMP_NO,1,2) 년생, NVL(BONUS,0) 보너스 FROM EMPLOYEE WHERE SUBSTR(EMP_NO,1,1) = 6;
-- 4. 010 핸드폰번호를 쓰지 않는 사람의 수를 출력하시오(뒤에 단위는 명을 붙일것)
SELECT COUNT(*) || '명' 인원 FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';
-- 5. 직원명과 입사년월을 출력하시오.
SELECT EMP_NAME 직원명, EXTRACT(YEAR FROM HIRE_DATE)|| '년' || EXTRACT(MONTH FROM HIRE_DATE) || '월' 입사년월 FROM EMPLOYEE;
-- 6. 직원명과 주민등록번호를 조회하시오.
-- 단, 주민등록번호 중 성별번호 뒤부터는 * 문자로 채워서 출력
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******' 주민등록번호 FROM EMPLOYEE;
-- 7. 직원명, 직급코드, 연봉(원) 조회
-- 단, 연봉은 \57,000,000 의 형식으로 출력
-- 연봉은 보너스 포인트가 적용된 1년치 급여
SELECT EMP_NAME, JOB_CODE, TO_CHAR(((SALARY + SALARY * NVL(BONUS,0)) * 12), 'L999,999,999') 연봉 FROM EMPLOYEE;
-- 8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의
-- 사번, 사원명, 부서코드, 입사일을 조회하시오.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D9') AND SUBSTR(HIRE_DATE,1,2) = '04';
-- 9. 직원명, 입사일, 오늘까지의 근무일수를 조회하시오. (주말포함, 소수점아래 버림)
SELECT EMP_NAME 직원명, HIRE_DATE 입사일, FLOOR(SYSDATE - HIRE_DATE) 근무일수 FROM EMPLOYEE;
-- 10. 모든 직원의 나이중 가장 많은 나이와 가장 적은 나이를 출력하시오(나이만 출력)
SELECT
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(MIN(SUBSTR(EMP_NO,1,2)) ,'RR')) + 1 "최대 나이",
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(MAX(SUBSTR(EMP_NO,1,2)) ,'RR')) + 1 "최소 나이"
FROM EMPLOYEE;
-- 11. 회사에서 야근을 해야 하는 부서를 발표해야 한다.
-- 부서코드가 D5, D6, D9인 경우 야근, 그외는 야근 없음으로 출력되도록 하여라.
-- 출력값은 이름, 부서코드, 야근유무(부서코드 기준 오름차순 정렬)
-- 부서코드가 NULL인 사람도 야근없음
SELECT
    EMP_NAME,
    DEPT_CODE,
        CASE
            WHEN DEPT_CODE IN('D5','D6','D9') THEN '야근'
            ELSE '야근없음'
        END
    "야근유무"
FROM
    EMPLOYEE
ORDER BY 2;
-- 12. 부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
-- 단, 부서코드가 D5, D6, D9인 직원의 정보만 조회
-- 부서코드 기준 오름차순 정렬
SELECT
    EMP_NAME,
    DEPT_CODE,
        CASE
            WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            ELSE '영업부'
        END
    부서명
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY 2;
-- 13. 직원명, 부서코드, 생년월일, 나이(만) 조회
-- 단, 생년월일은 주민번호에서 추출해서,
-- ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
-- 나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
-- * 주민번호가 이상한 사람들은 제외시키고 진행 하도록(200,201,214번 제외)
-- HINT : NOT IN 사용
SELECT
    EMP_NAME,
    DEPT_CODE,
    /*TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'), 'YY"년"MM"월"DD"일"')*/
    SUBSTR(EMP_NO,1,2) || '년 '
     || SUBSTR(EMP_NO,3,2) || '월 '
     || SUBSTR(EMP_NO,5,2) || '일 '
     생년월일,
     EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) + 1
     나이
FROM
    EMPLOYEE
WHERE EMP_ID NOT IN ('200','201','214');
-- 14. 아래 년도에 입사한 인원수를 조회하시오. 마지막으로 전체 직원수도 구하시오.
-- 1998년, 1999년, 2000년, 2001년, 2002년, 2003년, 2004년, 전체직원수
-- HINT : TO_CHAR, DECODE, SUM 이용
-- 내풀이
SELECT
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'1998',1,0)) "1998년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'1999',1,0)) "1999년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2000',1,0)) "2000년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2001',1,0)) "2001년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2002',1,0)) "2002년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2003',1,0)) "2003년",
    SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2004',1,0)) "2004년",
    COUNT(*) 전체직원수
FROM
    EMPLOYEE;
-- 강사님 풀이
-- 1) SUM : 해당 컬럼의 총 합 
SELECT 
    SUM(DECODE(EXTRACT(YEAR FROM HIRE_DATE),1998,1,0)) "1998년"
FROM EMPLOYEE;
-- 2) COUNT : NULL은 더하지 않음
SELECT 
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),1999,1)) "1999년"  
FROM EMPLOYEE;