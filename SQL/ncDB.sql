CREATE TABLE NOTICE_COMMENT(
    NC_NO       NUMBER          PRIMARY KEY,
    NC_LEVEL    NUMBER,             -- 댓글인지/대댓글인지 구분
    NC_WRITER   VARCHAR2(20)    REFERENCES MEMBER(MEMBER_ID) ON DELETE CASCADE, -- 댓글 작성자
    NC_CONTENT  VARCHAR2(1000)  NOT NULL,
    NC_DATE     CHAR(10),
    NOTICE_REF  NUMBER          REFERENCES NOTICE(NOTICE_NO) ON DELETE CASCADE, -- 어떤 공지사항의 댓글인지 구분용
    NC_REF      NUMBER          REFERENCES NOTICE_COMMENT(NC_NO) ON DELETE CASCADE -- 어떤 댓글의 댓글인지 구분용
);
-- 조회
SELECT * FROM notice_comment;

delete from notice_comment where nc_no = 4;

CREATE SEQUENCE NC_SEQ;