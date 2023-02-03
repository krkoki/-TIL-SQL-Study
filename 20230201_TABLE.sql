/* TABLE 만들기 */
CREATE DATABASE naver_db;
USE naver_db;
CREATE TABLE member (
mem_id CHAR(8) NOT NULL PRIMARY KEY, 
mem_name VARCHAR(10) NOT NULL,
men_numberr TINYINT NOT NULL,
addr CHAR(2) NOT NULL,
phone1 CHAR(3),
phone2 CHAR(8),
height TINYINT UNSIGNED,
debut_date DATE);

CREATE TABLE buy (
num INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
mem_id CHAR(8) NOT NULL, 
prod_name CHAR(6) NOT NULL, 
group_name CHAR(4),
price INT UNSIGNED,
amount SMALLINT UNSIGNED,
FOREIGN KEY(mem_id) REFERENCES member(mem_id));

/* 데이터
INSERT INTO member VALUES 
('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19'), 
('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-08-08'), 
('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-01-15'), 
('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015-04-21'),
('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007-08-02'), 
('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019-02-12'),
('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014-08-01'),
('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011-02-10'),
('SPC', '우주소녀', 13, '서울', '02', '88888888', 162,  '2016-02-25'),
('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014-06-19');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4); */

/* ALTER TABLE (TABLE 생성 후 지정하기) */
-- PRIMARY KEY
DROP TABLE IF EXISTS member;
CREATE TABLE member (
mem_id CHAR(8) NOT NULL, 
mem_name VARCHAR(10) NOT NULL,
men_numberr TINYINT NOT NULL,
addr CHAR(2) NOT NULL,
phone1 CHAR(3),
phone2 CHAR(8),
height TINYINT UNSIGNED,
debut_date DATE);
ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY (mem_id);
    
-- FOREIGN KEY
DROP TABLE IF EXISTS buy;
CREATE TABLE buy (
num INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
mem_id CHAR(8) NOT NULL, 
prod_name CHAR(6) NOT NULL, 
group_name CHAR(4),
price INT UNSIGNED,
amount SMALLINT UNSIGNED);
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id) 
    REFERENCES member(mem_id);

INSERT INTO member VALUES ('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-08-08');
INSERT INTO buy VALUES (NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES (NULL, 'BLK', '맥북프로', '디지털', 1000, 1);

/* ON UPDATE CASCADE & ON DELETE CASCADE */
DROP TABLE IF EXISTS buy;
CREATE TABLE buy (
num INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
mem_id CHAR(8) NOT NULL, 
prod_name CHAR(6) NOT NULL, 
group_name CHAR(4),
price INT UNSIGNED,
amount SMALLINT UNSIGNED);
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id) REFERENCES member(mem_id)
    ON UPDATE CASCADE -- 기준 테이블이 변경되면 참조 테이블도 변경되게 하는 기능
    ON DELETE CASCADE; -- 기준 테이블이 삭제되면 참조 테이블도 삭제되게 하는 기능

INSERT INTO buy VALUES (NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES (NULL, 'BLK', '맥북프로', '디지털', 1000, 1);

UPDATE member SET mem_id = 'PINK' WHERE mem_id = "BLK"; -- ON CASCADE 기능으로 인하여 값 변경가능
DELETE FROM member WHERE mem_id = "PINK"; -- ON CASCADE 기능으로 인하여 값 삭제도 가능

/* 기타 제약 조건 */
-- 고유 키 제약조건 (UNIQUE)
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member (
mem_id CHAR(8) NOT NULL PRIMARY KEY, 
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED,
email CHAR(30) UNIQUE);

INSERT INTO member VALUES ('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES ('TWC', '트와이스', 167, NULL);
INSERT INTO member VALUES ('APK', '에이핑크', 164, 'pink@gmail.com'); -- email 이 unique 제약조건이 걸려있어, 오류가 발생

-- 체크 제약조건 (CHECK)
DROP TABLE IF EXISTS member;
CREATE TABLE member (
mem_id CHAR(8) NOT NULL PRIMARY KEY, 
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED CHECK(height >= 100),
phone1 CHAR(3));
INSERT INTO member VALUES ('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES ('TWC', '트와이스', 99, NULL); -- height 가 check 100이상이라는 제약조건이 걸려있어, 오류가 발생

ALTER TABLE member
	ADD CONSTRAINT
    CHECK (phone1 IN ('02', '031', '032', '054', '055', '061')); -- ALTER로 제약을 추가해줄 수 있다.

INSERT INTO member VALUES ('TWC', '트와이스', 167, '02');    
INSERT INTO member VALUES ('OMY', '오마이걸', 160, '010'); -- ALTER로 추가한 check 제약으로 인하여 제약목록에 없는 값이므로 오류가 발생

-- 기본값 정의 (DEFAULT)
DROP TABLE IF EXISTS member;
CREATE TABLE member (
mem_id CHAR(8) NOT NULL PRIMARY KEY, 
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED DEFAULT 160,
phone1 CHAR(3));
ALTER TABLE member
	ALTER COLUMN phone1 SET DEFAULT '02';
    
INSERT INTO member VALUES ('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES ('SPC', '우주소녀', DEFAULT, DEFAULT); -- TABLE 설정 및 ALTER로 추가 설정한 default 제약 값이 자동으로 입력된다.
