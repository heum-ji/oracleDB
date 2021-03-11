/*
범위주석
*/
-- 한 줄 주석

--1. 사용자 계정 생성
CREATE USER aclass IDENTIFIED BY 1234;
--2. 생성한 계정에 접속, 데이터를 관리하는 권한을 부여
GRANT CONNECT, RESOURCE TO aclass;