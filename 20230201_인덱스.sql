USE market_db;
/* 인덱스 */
-- 기준인덱스 (클러스터 인덱스)
CREATE TABLE table1 (
	col1 INT PRIMARY KEY,
    col2 INT,
    col3 INT);
SHOW INDEX FROM table1;

CREATE TABLE table2 (
	col1 INT PRIMARY KEY,
    col2 INT UNIQUE,
    col3 INT UNIQUE);
SHOW INDEX FROM table2;

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
(mem_id CHAR(8),
mem_name VARCHAR(10),
mem_number INT,
addr CHAR(2));
INSERT INTO member VALUES ('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES ('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES ('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES ('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;
-- 아이디로 기준 키 지정
ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY (mem_id);
SELECT * FROM member;
-- 멤버이름으로 정렬됨
ALTER TABLE member DROP PRIMARY KEY;
ALTER TABLE member 
	ADD CONSTRAINT
    PRIMARY KEY (mem_name);
SELECT * FROM member;
-- 데이터를 추가하면 알아서 기준에 맞춰 정렬됨
INSERT INTO member VALUES ('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

-- 보조인덱스
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
(mem_id CHAR(8),
mem_name VARCHAR(10),
mem_number INT,
addr CHAR(2));
INSERT INTO member VALUES ('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES ('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES ('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES ('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;
-- 보조 인덱스 설정
ALTER TABLE member
	ADD CONSTRAINT
    UNIQUE (mem_id);
SELECT * FROM member;
-- 보조 인덱스 추가
ALTER TABLE member
	ADD CONSTRAINT
    UNIQUE (mem_name);
SELECT * FROM member;
-- 보조 인덱스는 데이터를 추가하여도 기준에 맞게 정렬되지않음.
INSERT INTO member VALUES ('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

-- 인덱스 내부 작동
USE market_db;
CREATE TABLE cluster
(mem_id CHAR(8),
mem_name VARCHAR(10));
INSERT INTO cluster VALUES('TWC', '트와이스');
INSERT INTO cluster VALUES('BLK', '블랙핑크');
INSERT INTO cluster VALUES('WMN', '여자친구');
INSERT INTO cluster VALUES('OMY', '오마이걸');
INSERT INTO cluster VALUES('GRL', '소녀시대');
INSERT INTO cluster VALUES('ITZ', '잇지');
INSERT INTO cluster VALUES('RED', '레드벨벳');
INSERT INTO cluster VALUES('APN', '에이핑크');
INSERT INTO cluster VALUES('SPC', '우주소녀');
INSERT INTO cluster VALUES('MMU', '마마무');
SELECT * FROM cluster;

ALTER TABLE cluster
	ADD CONSTRAINT
    PRIMARY KEY (mem_id);
SELECT * FROM cluster;

USE market_db;
CREATE TABLE second
(mem_id CHAR(8),
mem_name VARCHAR(10));
INSERT INTO second VALUES('TWC', '트와이스');
INSERT INTO second VALUES('BLK', '블랙핑크');
INSERT INTO second VALUES('WMN', '여자친구');
INSERT INTO second VALUES('OMY', '오마이걸');
INSERT INTO second VALUES('GRL', '소녀시대');
INSERT INTO second VALUES('ITZ', '잇지');
INSERT INTO second VALUES('RED', '레드벨벳');
INSERT INTO second VALUES('APN', '에이핑크');
INSERT INTO second VALUES('SPC', '우주소녀');
INSERT INTO second VALUES('MMU', '마마무');

ALTER TABLE second
	ADD CONSTRAINT
    UNIQUE (mem_id);
SELECT * FROM second;

-- 인덱스 생성과 제거
-- market_db 다시불러오기
SHOW INDEX FROM member;
SHOW TABLE STATUS;

CREATE INDEX idx_member_addr 
	ON member (addr); -- 단순 보조 인덱스 생성
SHOW INDEX FROM member;
SHOW TABLE STATUS LIKE 'member'; -- 단순 보조 인덱스 적용 확인 > 적용안되어있음
ANALYZE TABLE member; -- 인덱스 적용을 위하여 분석/처리
SHOW TABLE STATUS LIKE 'member'; -- 단순 보조 인덱스 적용 재확인 > 적용되어있음

CREATE UNIQUE INDEX idx_member_mem_number
	ON member (mem_number); -- 고유 보조 인덱스는 중복된 값이 없어야한다.
    
CREATE UNIQUE INDEX idx_member_mem_name
	ON member (mem_name); -- 중복된 값이 없어 고유 보조 인덱스 생성됨.
SHOW INDEX FROM member;
-- 이름이 같은 태국 가수가 회원가입을 하려고 한다.
INSERT INTO member VALUES ('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020.10.10'); -- 이름 고유 보조 인덱스 중복으로 가입이 안된다.

-- 인덱스 활용
ANALYZE TABLE member;
SHOW INDEX FROM member;
SELECT * FROM member; -- 전체조회이기때문에 인덱스가 작동하지 않음.
SELECT mem_id, mem_name, addr FROM member; -- 인덱스가 있는 열을 조회해도 인덱스를 사용하지 않음.
SELECT mem_id, mem_name, addr FROM member WHERE mem_name = '에이핑크'; -- 인덱스가 사용됨
SELECT mem_id, mem_name, addr FROM member WHERE mem_name IN ('에이핑크', '마마무', '블랙핑크'); -- 인덱스가 사용됨

CREATE INDEX idx_member_mem_number
	ON member (mem_number); -- 단순 보조 인덱스 생성
ANALYZE TABLE member;
SELECT mem_id, mem_name, addr FROM member WHERE mem_number >= 7; -- 인덱스가 사용됨
SELECT mem_id, mem_name, addr FROM member WHERE mem_number*2 >= 14; -- 위와 같은 조건이지만 컬럼에 연산이 적용되면 인덱스가 사용되지 않음.
SELECT mem_id, mem_name, addr FROM member WHERE mem_number >= 14/2; -- 인덱스가 사용됨

-- 인덱스 제거
SHOW INDEX FROM member; -- 인덱스 확인
DROP INDEX idx_member_mem_name ON member;
DROP INDEX idx_member_addr ON member;
DROP INDEX idx_member_mem_number ON member; -- 인덱스는 보조 인덱스부터 삭제하는것이 좋다. (클러스터 인덱스부터 제거시 쓸데없이 데이터를 재구성하기에 시간이 오래걸림.)

ALTER TABLE member
	DROP PRIMARY KEY; -- member의 mem_id를 buy가 참조하고 있기때문에 삭제가 안됨.

SELECT table_name, constraint_name
	FROM information_schema.referential_constraints
    WHERE constraint_schema = 'market_db'; -- 외래 키를 확인할 수 있음

ALTER TABLE buy
	DROP FOREIGN KEY buy_ibfk_1; -- 외래 키를 먼저 제거
ALTER TABLE member
	DROP PRIMARY KEY; -- 이후 기준 키를 제거
