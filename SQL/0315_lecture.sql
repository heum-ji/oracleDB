/* 
    실습
    1. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원 이름 출력
    2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호 출력
    3. EMPLOYEE 테이블에서 메일주소에 's'가 들어가면서, DEPT_CODE가 D9 또는 D6이며,
        고용일이 90/01/01 ~ 00/12/01 이면서, 월급이 270만원 이상인 사원의 전체정보 출력
*/

-- 1. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원 이름 출력
SELECT EMP_NAME "이름" FROM EMPLOYEE WHERE EMP_NAME LIKE '%연';
-- 2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호 출력
SELECT EMP_NAME "이름", PHONE "전화번호" FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';
/*
    3. 
    EMPLOYEE 테이블에서 메일주소에 's'가 들어가면서, DEPT_CODE가 D9 또는 D6이며,
    고용일이 90/01/01 ~ 00/12/01 이면서, 월급이 270만원 이상인 사원의 전체정보 출력
*/
SELECT * FROM EMPLOYEE
WHERE
    EMAIL LIKE '%s%' AND
    (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') AND
    (HIRE_DATE BETWEEN '90/01/01' AND '00/12/01') AND
    SALARY >= 2700000;
    
-- IS NULL / IS NOT NULL
-- 관리자도 없고, 부서배치도 받지 않은 직원 (부서코드(DEPT_CODE)가 NULL인 직원) 이름 조회
SELECT * FROM EMPLOYEE WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NOT NULL;

-- IN / NOT IN
-- 부서코드가 D6 이거나 D9인 직원 전체정보 조회 + 부서코드 D2인 직원 까지 포함
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D9' OR DEPT_CODE = 'D2';
-- IN () 안에 요소들 추가하면 됨 - OR / NOT IN 반대
SELECT * FROM EMPLOYEE WHERE DEPT_CODE NOT IN ('D6', 'D9', 'D2');

-- 부서원 중 직급코드(JOB_CODE)가 J7 또는 J2 이고, 급여가 200만원 초과인 사람의 이름, 급여, 직급코드
-- 연산자 우선순위 실습
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
-- 오름차순(ASC)
-- 숫자 : 작은 수 -> 큰 수
-- 날짜 : 빠른날 -> 느린 날
-- 문자 : 사전순

-- 내림차순(DESC)
-- 큰 수 -> 작은 수
-- 날짜 : 느린 날 -> 빠른 날
-- 문자 : 사전 역순

SELECT * FROM EMPLOYEE ORDER BY EMP_NAME DESC;
SELECT EMP_ID, EMP_NAME, EMAIL, SALARY FROM EMPLOYEE ORDER BY SALARY;
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY 3; -- SELECT한 COLUMN 순서 1부터 시작
/*
    03.15(월) 실습
*/
-- 문제 1. 입사일이 5년 이상, 10년 이하인 직원의 이름, 주민번호, 급여, 입사일을 검색하여라.
SELECT
    EMP_NAME 이름,
    EMP_NO 주민번호,
    SALARY 급여,
    HIRE_DATE 입사일
FROM
    EMPLOYEE
WHERE
    ( SYSDATE - HIRE_DATE ) / 365 BETWEEN 5 AND 10;
-- 문제 2. 재직중이 아닌 직원의 이름, 부서코드를 검색하여라 (퇴사 여부 : ENT_YN)
SELECT
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE,
    FLOOR(ENT_DATE - HIRE_DATE)
     || '일' "근무 기간",
    ENT_DATE
FROM
    EMPLOYEE
WHERE
    ENT_YN = 'Y';
-- 문제 3.
-- 근속년수가 10년 이상인 직원들을 검색하여
-- 출력 결과는 이름, 급여, 근속년수가 오름차순으로 정렬하여 출력하여라
-- 단, 급여는 50%인상된 급여로 출력 되도록 하여라.
SELECT
    EMP_NAME,
    SALARY * 1.5 "인상 급여",
    (SYSDATE - HIRE_DATE) / 365 "근속년수"
FROM
    EMPLOYEE
WHERE
    ( ( SYSDATE - HIRE_DATE ) / 365 ) >= 10
ORDER BY 3;
-- 문제 4.
-- 입사일이 99/01/01 ~ 10/01/01 인 사람 중에서 급여가 2000000 원 이하인 사람의
-- 이름, 주민번호, 이메일, 폰번호, 급여를 검색 하시오
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
-- 문제 5.
-- 급여가 200000원 ~ 3000000원 인 여직원 중에서 4월 생일자를 검색하여
-- 이름, 주민번호, 급여, 부서코드를 주민번호 순으로(내림차순) 출력하여라
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
-- 문제 6.
-- 남자 사원 중 보너스가 없는 사원의 오늘까지 근무일을 측정하여
-- 1000일 마다(소수점 제외)
-- 급여의 10% 보너스를 계산하여 이름, 특별 보너스 (계산 금액) 결과를 출력하여라.
-- 단, 이름 순으로 오름차순 정렬하여 출력하여라.
SELECT
    EMP_NAME,
    ( SALARY * 0.1 ) * FLOOR( (SYSDATE - HIRE_DATE) / 1000 )  "특별 보너스"
FROM
    EMPLOYEE
WHERE
    EMP_NO LIKE '%-1%' AND BONUS IS NULL
ORDER BY 1;

/* 
    [ 함수 ]
    1. 문자처리하는 함수
*/
-- 1) LENGTH : 주어진 값 또는 컬러의 문자열 길이(문자 개수) 를 반환하는 함수
SELECT EMP_NAME, LENGTH(EMP_NAME), EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;
-- 2) LENGTHB : 주어진 값 또는 컬럼의 문자열 길이(BYTE)를 반환 하는 함수
SELECT EMP_NAME, LENGTHB(EMP_NAME), EMAIL, LENGTHB(EMAIL) FROM EMPLOYEE;
-- 3) INSTR : 찾는 문자(열)이 지정한 위치부터 지정한 횟수만큼 나타난 위치를 반환 -- 항상 시작부터의 위치를 반환 / -1은 뒤에서부터
SELECT INSTR('Hello World Hi High', 'H', -1, 1) FROM DUAL;

-- EMPLOYEE 테이블에서 EMAIL컬럼에서 @의 위치를 출력
SELECT EMAIL, INSTR(EMAIL, '@', 1, 1) "@ 위치" FROM EMPLOYEE;

-- 4) LPAD / RPAD : 주어진 컬럼 문자열에 임의의 문자열을 왼쪽/오른쪽에 덧붙여 같이 N의 문자열을 반환
SELECT EMAIL, LENGTH(EMAIL), LPAD(EMAIL, 20, '#'), RPAD(EMAIL, 20, '#') FROM EMPLOYEE;
SELECT EMAIL, LPAD(EMAIL, INSTR(EMAIL, '@', 1, 1) - 1, '#') FROM EMPLOYEE; -- @앞까지 자르기 // LPAD에서 한글 2BYTE / BYTE 끊음

-- 5) LTRIM / RTRIM : 주어진 컬럼이나 문자열의 왼쪽 또는 오른쪽에서 지정한 STR에 포함된 모든 문자를 제거한 나머지 반환
SELECT 'aaaKH' FROM DUAL;
SELECT LTRIM('aaaKH', 'a') FROM DUAL;
SELECT LTRIM('aaaKaH', 'a') FROM DUAL; -- 다른 문자가 나오면 끝남 / KaH 출력됨
SELECT RTRIM('aaaKHaaa', 'a') FROM DUAL;
SELECT LTRIM('ABACAAABCKH', 'AB') FROM DUAL; -- 해당 패턴 다 사라짐 EX) A OR B 다 지움 - CAAABCKH 출력

-- 6) TRIM : 주어진 컬럼이나 문자열 앞/뒤/양쪽에 있는 지정한 문자를 제거한 나머지를 반환
-- 문자만 거르기 가능 / 패턴 불가
SELECT TRIM(LEADING 'a' FROM 'aaaKHaaa') FROM DUAL; -- LEADING : 앞만 지우기
SELECT TRIM(TRAILING 'a' FROM 'aaaKHaaa') FROM DUAL; -- LEADING : 앞만 지우기
SELECT TRIM(BOTH 'a' FROM 'aaaKHaaa') FROM DUAL;  -- BOTH : 양쪽 // DEFAULT BOTH 생략 가능

SELECT TRIM(LEADING 'B' FROM TRIM(LEADING 'A' FROM 'ABACAAABCKH')) FROM DUAL; -- A자르고 B 잘라서 'AB' 자르기 가능

SELECT RTRIM(DEPT_TITLE, '부') FROM DEPARTMENT;
SELECT TRIM(TRAILING '부' FROM DEPT_TITLE) FROM DEPARTMENT;

-- DUAL 테이블 사용
-- '982341678934509hello89798739273402' 문자열 앞 뒤 모든 숫자 제거
SELECT RTRIM( LTRIM('982341678934509hello89798739273402', '0123456789'), '0123456789' ) FROM DUAL;

-- 7) SUBSTR : 컬럼이나 문자열에서 지정한 위치부터 지정한 개수의 문자열을 잘라내어 리턴
SELECT SUBSTR( 'SHOWMETHEMONEY',1,4 ) FROM DUAL;
SELECT SUBSTR( 'SHOWMETHEMONEY',5,2 ) FROM DUAL;
SELECT SUBSTR( 'SHOWMETHEMONEY',-8,2 ) FROM DUAL; -- '-'인 경우 뒤에서 부터 시작 앞에서 부터 잘라냄
-- EMPLOYEE 테이블에서 사원명 중 성만 출력
SELECT DISTINCT( SUBSTR(EMP_NAME, 1, 1) ) "성" FROM EMPLOYEE; -- DISTINCT() 중복제거

-- EMPLOYEE 테이블에서 남자만 사원번호, 사원명, 주민번호, 월급
-- 주민번호 뒤 6자리는 *처리 EX) 990101-1******

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

-- 9) CONCAT : 컬럼의 문자 혹은 문자열 두 개를 전달받아 하나로 합친 후 리턴
SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라' || 'ABCD' || '안녕하세요' FROM DUAL;

-- 10) REPLACE : 문자열을 변환
SELECT REPLACE('NEXT007@nate.com', 'nate.com', 'iei.or.kr') FROM DUAL;

/* 
    [ 함수 ]
    2. 숫자 처리 함수
*/

-- 1) ABS : 절대값
SELECT ABS(10) FROM DUAL;
SELECT ABS(-10) FROM DUAL;

-- 2) MOD : 인자로 받은 숫자를 나누어 나머지를 구하는 함수
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(10,2) FROM DUAL;
SELECT MOD(10,4) FROM DUAL;

-- 3) ROUND / FLOOR / CEIL : 반올림/버림/올림
SELECT FLOOR(126.465) FROM DUAL;
SELECT CEIL(126.465) FROM DUAL;
SELECT ROUND(126.465, 2) FROM DUAL;
SELECT ROUND(126.465, -2) FROM DUAL;

/* 
    [ 함수 ]
    3. 날짜 처리 함수
*/
-- 1) SYSDATE : 시스템에 저장된 현재 날짜를 반환
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP, CURRENT_TIMESTAMP FROM DUAL;
-- 2) MONTHS_BETWEEN : 날짜 두 개를 전달 받아, 개월 수 차이를 숫자형으로 리턴
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE,HIRE_DATE) FROM EMPLOYEE;
-- 3) ADD_MONTHS : 인자로 전달받은 날짜에 인자로 전달받은 숫자만틈 개월 수를 더해서 날짜를 리턴
SELECT SYSDATE FROM DUAL;
SELECT ADD_MONTHS(SYSDATE,4) FROM DUAL;  -- 4개월 뒤
SELECT SYSDATE + 10 FROM DUAL; -- 10일 뒤
SELECT ADD_MONTHS(SYSDATE + 16,1) FROM DUAL; -- ADD_MONTHS 자동으로 마지막 날 계산 기능 제공
-- 4) NEXT_DAY : 인자로 전달 받은 날짜에 인자로 전달 받은 요일 중 가장 가까운 다음 요일
-- 1 = 일요일....7 = 토요일
SELECT NEXT_DAY(SYSDATE, '월') FROM DUAL;

-- 5) LAST_DAY : 인자로 전달받은 날짜가 속한 달의 마지막 날짜를 구하여 리턴
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 6) EXTRACT : 날짜 데이터에서 년도, 월, 일 정보를 추출
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL; --YEAR
SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL; --MONTH
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL; --DAY

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 년차를 출력
-- 단, 입사일 YYYY년M월D일로 출력
-- 년차 출력 시 소수점이면 올림으로 출력(29.124 -> 30)
-- 출력 시 정렬은 입사일 기준 오름차순
SELECT
    EMP_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) || '년' ||
    EXTRACT(MONTH FROM HIRE_DATE) || '월' ||
    EXTRACT(DAY FROM HIRE_DATE) || '일' 입사일,
    CEIL( (SYSDATE - HIRE_DATE) / 365 ) 년차
FROM EMPLOYEE
ORDER BY 2;

/* 
    [ 함수 ]
    4. 형변환 함수
*/

-- 1) TO_CHAR : 날짜형데이터 숫자 데이터를 문자형 데이터로 변환하여 리턴
-- TO_CHAR([숫자/날짜데이터],형식)
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL; -- MM/DD 월/일날짜
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD/DAY') FROM DUAL; -- DY : 요일빼고 앞자리만
SELECT TO_CHAR(SYSDATE,'YYYY-MONTH/DD') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-MONTH/DD/PM HH12"시"MI"분"SS"초"') FROM DUAL; -- MI 분
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD/PM HH24"시"MI"분"SS"초"') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'FMYYYY/MM/DD/PM HH24"시"MI"분"SS"초"') FROM DUAL; -- FM 앞자리 0뺌

SELECT TO_CHAR(1000000,'999,999,999') FROM DUAL; -- 자릿수 모자란 경우'#####' 으로 보임
SELECT TO_CHAR(1000000,'000,000,000') FROM DUAL; -- 빈 자리 0으로 채워 줌
SELECT TO_CHAR(1000000, 'L999,999,999') FROM DUAL; -- 설치된 언어에 따라 화폐 단위 출력
SELECT TO_CHAR(1000000, '$999,999,999') FROM DUAL; -- $ 어두에 출력

-- 2) TO_DATE : 숫자 홋은 문자형 데이터를 날짜형 데이터로 변환하여 리턴
-- TO_DATE([문자/숫자], 포맷)
SELECT TO_DATE(20210201,'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('20210709','YYYYMMDD') FROM DUAL;
-- 시간 설정 안하는 경우 0으로 초기화
SELECT TO_CHAR(TO_DATE(20210201,'YYYYMMDD'),'YYYY/MM/DD/HH24"시"MI"분"SS"초"') FROM DUAL;

-- 3) TO_NUMBER : 문자 데이터를 숫자 타입으로 변환하여 리턴
SELECT TO_NUMBER('1,000,000','9,999,999') FROM DUAL;
SELECT TO_NUMBER('100') FROM DUAL; -- 숫자가 아닌 문자열은 변환 불가능

SELECT '1000' + '100' FROM DUAL; -- Oracle에서 + 연산자는 항상 NUMBER 연산 / 마찬가지로 number 아닌 경우 에러

-- 5. 기타함수
-- 1) NVL : NULL로 되어있는 컬럼의 값을 지정한 숫자 혹은 문자로 변경하여 리턴
SELECT SALARY, BONUS, ((SALARY + SALARY * BONUS) * 12) FROM EMPLOYEE;
SELECT SALARY, NVL(BONUS,0), ( ( SALARY + SALARY * NVL(BONUS,0) ) * 12 ) FROM EMPLOYEE;
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음') FROM EMPLOYEE;

-- 2) DECODE : 여러가지 경우에 선택을 할 수 있는 기능을 제공
-- DECODE(표현식, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3,....)

/*
    SWITCH(표현식) {
    CASE 조건1 : 결과1; break;
    방식과 유사
*/

SELECT
    EMP_NAME,
    EMP_NO,
    DECODE(SUBSTR(EMP_NO,8,1), '1', '남자', '여자') 성별 -- 마지막 인자로 쌍으로 안 주면 DEFAULT 기능
FROM EMPLOYEE;

-- 3) CASE : 여러가지 경우에 선택을 할 수 있는 기능을 제공(범위값도 가능)
SELECT
    EMP_NAME,
    EMP_NO,
        CASE
            WHEN SUBSTR(EMP_NO,8,1) = 1 THEN '남자'
            ELSE '성별없음'
        END
    성별
FROM
    EMPLOYEE;
/*
    실습
*/
-- EMPLOYEE 테이블에서 60년대 생 중 65년 미만은 "60년대 초반", 65년생 이상은 "60년대 후반" 으로 출력
-- 단, 이름도 같이 출력할것
SELECT
    EMP_NAME 이름,
    EMP_NO,
        CASE
            WHEN SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 64 THEN '60년대생 초반'
            ELSE '60년대생 후반'
        END
    "1960"
FROM
    EMPLOYEE
WHERE
    SUBSTR(EMP_NO,1,1) = 6
ORDER BY 2;