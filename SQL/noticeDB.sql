CREATE TABLE NOTICE (
    NOTICE_NO        NUMBER PRIMARY KEY,      -- 공지사항 관리번호
    NOTICE_TITLE     VARCHAR2(1000) NOT NULL,
    NOTICE_WRITER    VARCHAR2(20)
        REFERENCES MEMBER ( MEMBER_ID )
            ON DELETE CASCADE,                -- 작성자는 회원 테이블 참조,탈퇴 시 삭제 옵션
    NOTICE_CONTENT   VARCHAR2(4000),          -- 공지사항 내용
    NOTICE_DATE      CHAR(10),                -- 작성일
    FILENAME         VARCHAR2(500),           -- 사용자가 첨부한 파일 이름
    FILEPATH         VARCHAR2(500)              -- 실제 서버에 업로드된 파일 이름
);

CREATE SEQUENCE NOTICE_SEQ NOCACHE;

SELECT
    *
FROM
    MEMBER;

INSERT INTO NOTICE VALUES (
    NOTICE_SEQ.NEXTVAL,
    '공지사항' || NOTICE_SEQ.CURRVAL,
    'admin',
    '내용' || NOTICE_SEQ.CURRVAL,
    TO_CHAR(SYSDATE,'YYYY-MM-DD'),
    NULL,
    NULL
);

SELECT
    COUNT(*)
FROM
    NOTICE;

SELECT
    *
FROM
    NOTICE;

COMMIT;
    
SELECT * FROM NOTICE;   
    
-- 공부
SELECT ROWNUM AS RNUM, N.* FROM (SELECT * FROM NOTICE ORDER BY NOTICE_NO DESC) N;    
    
    DELETE FROM notice WHERE notice_no = 90;
    commit;
-- 최근글 정렬 조회
SELECT * FROM NOTICE ORDER BY NOTICE_NO DESC;
-- 최근글 다시 번호 내림차순 매기기
SELECT ROWNUM AS RNUM, N.* FROM (SELECT * FROM NOTICE ORDER BY NOTICE_NO DESC) N;
-- 원하는 구간의 게시물 조회
SELECT * FROM (SELECT ROWNUM AS RNUM, N.* FROM (SELECT * FROM NOTICE ORDER BY NOTICE_NO DESC) N) WHERE RNUM BETWEEN 11 AND 20;