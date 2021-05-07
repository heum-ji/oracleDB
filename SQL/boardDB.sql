CREATE TABLE BOARD (
    BOARD_NO        NUMBER PRIMARY KEY,   -- 게시판 관리번호
    BOARD_TITLE     VARCHAR2(1000) NOT NULL,
    BOARD_WRITER    VARCHAR2(20)
        REFERENCES MEMBER ( MEMBER_ID )
            ON DELETE CASCADE,            -- 작성자는 회원 테이블 참조,탈퇴 시 삭제 옵션
    BOARD_CONTENT   VARCHAR2(4000),       -- 게시판 내용
    BOARD_DATE      CHAR(10),             -- 작성일
    FILENAME        VARCHAR2(500),        -- 사용자가 첨부한 파일 이름
    FILEPATH        VARCHAR2(500)          -- 실제 서버에 업로드된 파일 이름
);

CREATE SEQUENCE BOARD_SEQ NOCACHE;

DROP SEQUENCE BOARD_SEQ;

SELECT
    *
FROM
    BOARD;

INSERT INTO BOARD VALUES (
    BOARD_SEQ.NEXTVAL,
    '자유다 자유라구' || BOARD_SEQ.CURRVAL,
    'user03',
    '여기는 자유 게시판' || BOARD_SEQ.CURRVAL,
    TO_CHAR(SYSDATE,'YYYY-MM-DD'),
    NULL,
    NULL
);

DELETE FROM BOARD WHERE
    BOARD_NO = 2;

SELECT
    COUNT(*)
FROM
    BOARD;

COMMIT;

-- 게시물 조회
SELECT
    ROWNUM AS RNUM,
    N.*
FROM
    (
        SELECT
            *
        FROM
            BOARD
        ORDER BY BOARD_NO DESC
    ) N;
    
SELECT
    *
FROM
    (
        SELECT
            ROWNUM AS RNUM,
            N.*
        FROM
            (
                SELECT
                    *
                FROM
                    BOARD
                ORDER BY BOARD_NO DESC
            ) N
    )
WHERE
    RNUM BETWEEN 1 AND 10;