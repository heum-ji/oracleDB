--------------------------------------------------------------------------------
/*
    03.18(목) 
*/
--------------------------------------------------------------------------------
/*
    다중열 서브쿼리
    - 다중열 / 단일행
*/
--------------------------------------------------------------------------------
-- 1. 퇴사한 여직원이 1명 그 직원이랑 같은부서, 같은 직급에 해당하는 사원의 이름, 직급, 부서코드
-- 단일행 방법
SELECT EMP_NAME, JOB_CODE, DEPT_CODE FROM EMPLOYEE
WHERE
    DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y') AND
    JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y');
-- 다중열 방법
SELECT EMP_NAME, JOB_CODE, DEPT_CODE FROM EMPLOYEE
WHERE
    (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1) = 2 AND ENT_YN = 'Y');
    
-- 2. 기술지원부이면서, 급여가 200만원인 직원의 이름, 부서코드, 급여, 부서 지역명(LOCATION)
-- JOIN 방법
SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE DEPT_TITLE LIKE '기술지원%' AND SALARY = 2000000;
-- 서브쿼리 방법
SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN LOCATION ON (DEPT_CODE,LOCAL_CODE) IN (SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부')
WHERE SALARY = 2000000;

SELECT EMP_NAME, DEPT_CODE, SALARY, LOCAL_NAME FROM EMPLOYEE
JOIN LOCATION ON (DEPT_CODE,LOCAL_CODE) IN (SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT);

SELECT DEPT_ID, LOCATION_ID FROM DEPARTMENT;
--------------------------------------------------------------------------------
/*
    다중행 다중열 서브쿼리 : 조회 결과의 컬럼 및 행의 개수가 여러개인 경우
*/
--------------------------------------------------------------------------------
-- 1. 직급별 최소급여를 받는 직원의 이름, 직급, 월급
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE (JOB_CODE,SALARY) IN (SELECT JOB_CODE, MIN(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE) ORDER BY 2;

--------------------------------------------------------------------------------
/*
    상관쿼리(상호연관서브쿼리)
    - 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행하고, 그 결과를 다시 메인쿼리로 반환해서 수행하는 쿼리
    - 성능이 좋지 않음
    - 서브쿼리의 WHERE을 수행하기 위해 메인쿼리가 먼저 수행되는 구조
    - 메인쿼리의 각 행의 값마다 응답이 달라져야 하는 경우 사용
*/
--------------------------------------------------------------------------------
-- 1. 부서가 '인사관리부', '회계관리부','마케팅부' 인 직원의 이름, 부서코드, 급여
-- JOIN
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('인사관리부','회계관리부','마케팅부');
-- 서브쿼리
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE IN ('인사관리부','회계관리부','마케팅부'));
-- 상관쿼리
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE E
WHERE EXISTS (
    SELECT DEPT_ID FROM DEPARTMENT D
    WHERE DEPT_TITLE IN ('인사관리부','회계관리부','마케팅부')
    AND E.DEPT_CODE = D.DEPT_ID
);
--------------------------------------------------------------------------------
/*
	스칼라 서브쿼리 : 상관쿼리이면서 결과값이 1개인 서브쿼리
*/
--------------------------------------------------------------------------------
-- 1) WHERE절에 사용
-- 자신이 속한 직급의 평균 급여보다 급여를 많이 받는 직원의 이름, 직급코드, 급여
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E1
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE E2 WHERE E2.JOB_CODE = E1.JOB_CODE); -- 자신이 속한 직급의 평균 급여

-- 2) SELECT절에 사용
-- 사원명, 부서코드, 부서별 평균임금을 출력
SELECT
    EMP_NAME,
    NVL(DEPT_CODE,'배정대기') "부서",
    FLOOR((SELECT AVG(SALARY) FROM EMPLOYEE E2 WHERE NVL(E1.DEPT_CODE,'없음') = NVL(E2.DEPT_CODE,'없음') GROUP BY DEPT_CODE))
    "부서별 평균 임금"
FROM EMPLOYEE E1;
-- 사원명, 관리자 사번, 관리자 이름
SELECT EMP_NAME, NVL(MANAGER_ID,'없음') "관리자 ID",
    NVL((SELECT E2.EMP_NAME FROM EMPLOYEE E2 WHERE E1.MANAGER_ID = E2.EMP_ID),'없음') "관리자 이름"
FROM EMPLOYEE E1;

-- 3) ORDER BY절에 사용
-- 이름, 부서코드, 급여 출력하는데 정렬은 부서이름 기준
SELECT EMP_NAME,DEPT_CODE,SALARY,(SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_CODE = DEPT_ID) "부서이름"
FROM EMPLOYEE
ORDER BY (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_CODE = DEPT_ID);

--------------------------------------------------------------------------------
/*
	인라인뷰 : FROM절에서 사용되는 서브쿼리
*/
--------------------------------------------------------------------------------
SELECT * FROM (SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY FROM EMPLOYEE);

--------------------------------------------------------------------------------
/*
	TOP-N 분석
    1) ROWNUM : 출력되는 행마다 자동으로 순차적인 번호를 붙여주는 값
*/
--------------------------------------------------------------------------------
-- 현재 직원중에 급여를 가장 많이 받는 5명 이름, 급여 출력
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 3700000 ORDER BY 2 DESC;
-- ROWNUM 실행 후 ORDER BY 실행됨
SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC;
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC;
-- 급여 정렬된 TABLE 을 인라인뷰로 넣고, ROWNUM 상위 5명 출력
SELECT ROWNUM, EMP_NAME, SALARY FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC) WHERE ROWNUM < 6;

-- RANK() OVER - 중복 순위 다음은 중복 갯수만큼 건너뛰고 반환
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;
-- DENSE_RANK() OVER - 중복 순위와 상관없이 순차적으로 반환
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;
-- ROWNUM 이랑 같은 기능 / 중복 상관 X
SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
	서브쿼리를 이용한 테이블 생성
*/
--------------------------------------------------------------------------------
/*
    테이블 생성 구문
    CREATE TABLE 테이블명(컬럼명 데이터타입 제약조건, ....);
*/
-- NOT NULL만 복사 - 다른 제약조건은 복사 안됨
CREATE TABLE EMP_COPY
AS 
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '부서 없음') DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB USING (JOB_CODE)
ORDER BY 1;

SELECT * FROM EMP_COPY;

-- TABLE COLUMN 구조만 복사하는 경우 - DATA X
CREATE TABLE EMP_COPY1
AS
SELECT * FROM EMPLOYEE WHERE 1=0;

SELECT * FROM EMP_COPY1;

DROP TABLE EMP_COPY;
DROP TABLE EMP_COPY2;
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_COPY;

-- 서브쿼리를 이용한 수정
-- UPDATE EMP_COPY SET 수정컬럼 = 수정값, ... WHERE 조건

-- 1. 방명수 직원의 급여를 선동일의 급여로 변경
-- 1) 선동일의 급여 검색
SELECT SALARY FROM EMP_COPY WHERE EMP_NAME = '선동일';
-- 2) 방명수 급여 변경
UPDATE EMP_COPY SET SALARY = (SELECT SALARY FROM EMP_COPY WHERE EMP_NAME = '선동일') WHERE EMP_NAME = '방명수';

-- 서브쿼리를 이용한 삭제
-- 방명수 직원과 같은 부서의 직원 모두 삭제
-- 1) 방명수 부서코드 검색
SELECT DEPT_CODE FROM EMP_COPY WHERE EMP_NAME = '방명수';
-- 2) 방명수와 같은 부서 직원 삭제
DELETE FROM EMP_COPY WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMP_COPY WHERE EMP_NAME = '방명수');
SELECT * FROM EMP_COPY;

-- 서브쿼리를 이용한 INSERT
CREATE TABLE EMP1
AS
SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMP2
AS
SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMP3
AS
SELECT EMP_ID,EMP_NAME,JOB_CODE FROM EMPLOYEE WHERE 1=0;

INSERT INTO EMP1 VALUES(1, '테스트','D5');

INSERT INTO EMP1 (SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '송종기');
INSERT INTO EMP2 (SELECT EMP_ID,EMP_NAME,DEPT_CODE FROM EMPLOYEE);

DELETE FROM EMP2;

SELECT * FROM EMP1;
SELECT * FROM EMP2;
SELECT * FROM EMP3;

-- INSERT ALL
INSERT ALL
INTO EMP2 VALUES(EMP_ID,EMP_NAME,DEPT_CODE)
INTO EMP3 VALUES(EMP_ID,EMP_NAME,JOB_CODE)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    TCL
*/
--------------------------------------------------------------------------------
COMMIT;

CREATE TABLE USERTBL(
    USER_NO NUMBER  PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PW VARCHAR2(20) NOT NULL
);
INSERT INTO USERTBL VALUES(1,'USER01','1111');
INSERT INTO USERTBL VALUES(2,'USER02','2222');
INSERT INTO USERTBL VALUES(3,'USER03','3333');
INSERT INTO USERTBL VALUES(4,'USER04','4444');
SAVEPOINT spl;
INSERT INTO USERTBL VALUES(5,'USER05','9999');
SELECT * FROM USERTBL;
COMMIT; -- savepoint 삭제 및 현재 상태 저장
ROLLBACK; -- 가장 최근 commit 으로 이동
ROLLBACK TO spl; -- savepoint로 이동
DELETE FROM USERTBL;

UPDATE USERTBL SET USER_PW = '4544' WHERE USER_NO = 2;
--------------------------------------------------------------------------------
/*
    DATA DICTIONARY
    - 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
    - 사용자가 테이블을 만들고 데이터를 입출력 X
    - 사용자가 DB 작업을 하면 자동으로 갱신
    - VIEW : 원본테이블을 커스터마이징해서 보여주는 가상 테이블
    
    대표적인 DICTIONARY VIEW
    1. DBA_XXXX : DB 관리자만 접근이 가능한 객체 정보등을 조회
    -> DBA는 모든 접근이 가능하므로 DB에 있는 모든 객체에 대한 정보 조회
    2. ALL_XXXX : 자신의 계정이 소유하거나 권한을 부여 받은 객체 정보등을 조회
    3. USER_XXXX : 자신의 계정이 소유한 객체 정보등을 조회
*/
--------------------------------------------------------------------------------
SELECT * FROM USER_TABLES;
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE';
SELECT * FROM USER_COL_COMMENTS;
--------------------------------------------------------------------------------
/*
	OBJECT
*/
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
/*
	1. VIEW : 
    -- ADMIN에서 GRANT CREATE VIEW TO 계정명 // 권한 설정 해야 사용 가능
*/
--------------------------------------------------------------------------------

-- TABLE 복사 -- 배열(깊은 복사)
CREATE TABLE EMP01
AS
SELECT EMP_NO,EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;

SELECT * FROM EMP01;
SELECT * FROM EMPLOYEE;

UPDATE EMP01 SET PHONE = '01099999999' WHERE EMP_NAME = '심봉선';

-- VIEW -- 배열(얕은 복사)
CREATE VIEW EMP_VIEW
AS
SELECT EMP_NO,EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;
SELECT * FROM EMP_VIEW;

UPDATE EMP_VIEW SET PHONE = '01088888888' WHERE EMP_NAME = '심봉선';
UPDATE EMPLOYEE SET PHONE = '01012341234' WHERE EMP_NAME = '심봉선';

CREATE VIEW EMP_VIEW2
AS
SELECT EMP_NO,EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM EMP_VIEW2;
SELECT * FROM EMPLOYEE;

UPDATE EMP_VIEW2 SET EMP_NO = '621235-1985699' WHERE EMP_NAME = '선동일';

-- 수정 불가 / 조인해서 만든 가상의 COLUMN이기 때문
UPDATE EMP_VIEW2 SET DEPT_TITLE = '해외영업2부' WHERE EMP_NAME = '선동일';

--------------------------------------------------------------------------------
/*
	2. SEQUENCE
    - 자동으로 번호 생성
*/
--------------------------------------------------------------------------------
CREATE SEQUENCE TEST_SEQ
START WITH 10
INCREMENT BY 2
MAXVALUE 30
NOCYCLE
NOCACHE;
-- SEQUENCE 조회
SELECT * FROM USER_SEQUENCES;

SELECT TEST_SEQ.CURRVAL FROM DUAL; -- 가장 처음 사용 시 항상 NEXTVAL 후 사용
SELECT TEST_SEQ.NEXTVAL FROM DUAL;

CREATE SEQUENCE TEST_SEQ2
START WITH 10
INCREMENT BY 2
MAXVALUE 30
CYCLE
NOCACHE;

SELECT TEST_SEQ2.CURRVAL FROM DUAL;
SELECT TEST_SEQ2.NEXTVAL FROM DUAL;

CREATE TABLE SEQ_TEST1(
    NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL
);

CREATE SEQUENCE SEQ_TEST1_NO
START WITH 10
INCREMENT BY 10
MAXVALUE 100
NOCYCLE
NOCACHE;

DROP SEQUENCE SEQ_TEST1_NO;
DROP TABLE SEQ_TEST1;
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST1',10);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST2',20);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST3',30);
INSERT INTO SEQ_TEST1 VALUES(SEQ_TEST1_NO.NEXTVAL,'TEST4',30);
SELECT * FROM SEQ_TEST1;

DROP TABLE SEQ_TEST2;

CREATE TABLE SEQ_TEST2(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL
);

CREATE SEQUENCE SEQ_TEST2_NO; -- 1 ~ ++
INSERT INTO SEQ_TEST2 VALUES('L-'||SEQ_TEST2_NO.NEXTVAL,'TEST1',11);
INSERT INTO SEQ_TEST2 VALUES('L-'||SEQ_TEST2_NO.NEXTVAL,'TEST2',22);
SELECT * FROM SEQ_TEST2;

SELECT * FROM USER_SEQUENCES;
-- 시퀀스 생성
-- 시작값 100, 최대값 500, 증가폭 50, 반복없고, 캐시X -> 시쿤스 이름 : TEST_SEQ2
CREATE SEQUENCE TEST_SEQ2
START WITH 100
INCREMENT BY 50
MAXVALUE 500
NOCYCLE
NOCACHE;

-- START 값은 수정 X - 필요 시 DROP 후 CREATE
ALTER SEQUENCE TEST_SEQ2
INCREMENT BY 10
MAXVALUE 500
NOCYCLE
NOCACHE;