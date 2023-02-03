USE market_db;
CREATE TABLE hongong4(
tinyint_col TINYINT, -- 127
smallint_col SMALLINT, -- 32767
int_col INT, -- 21억
bigint_col BIGINT); -- 900경

INSERT INTO hongong4 VALUES (127, 32767, 2147483647, 9000000000000000000);
INSERT INTO hongong4 VALUES (127, 32767, 2147483647, 90000000000000000000);

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL, -- VARCHAR는 가변으로 들어감
mem_number TINYINT NOT NULL,
addr CHAR(2) NOT NULL, -- 서울, 경기, 인천 등등
phone1 CHAR(3), -- 국번 02, 031
phone2 CHAR(8),
height TINYINT UNSIGNED, -- UNSIGNED는 -128~127의 음수부분을 양수부분으로 활용하여 TINYINT기준 256바이트를 사용하여 0~255까지 표현할 수있게 해준다.
debut_date DATE);

-- 실습
CREATE TABLE products(
PRODUCT_ID INT NOT NULL PRIMARY KEY,
PRODUCT_NAME VARCHAR(10) NOT NULL,
REG_DATE DATE,
WEIGHT INT,
PRICE INT)
INSERT INTO products VALUES (1, "Computer", '21/01/01', 10, 1600000), (2, "Smartphone", '21/02/01', 0.2, 1000000), (3, "Television", '21/03/01', 20, 2000000);