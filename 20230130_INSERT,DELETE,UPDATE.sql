USE market_db;

CREATE TABLE hongong1 (toy_id INT, toy_name CHAR(4), age INT);
INSERT INTO hongong1 VALUES (1, '우디', 25);
INSERT INTO hongong1 (toy_id, toy_name) VALUES (2, '버즈');
INSERT INTO hongong1 (toy_name, age, toy_id) VALUES ('제시', 20, 3);
SELECT * FROM market_db.hongong1;

CREATE TABLE hongong2 (
toy_id INT AUTO_INCREMENT PRIMARY KEY,
toy_name CHAR(4),
age INT);
INSERT INTO hongong2 VALUES (NULL, '보핍', 25);
INSERT INTO hongong2 VALUES (NULL, '슬링키', 22);
INSERT INTO hongong2 VALUES (NULL, '렉스', 21);
SELECT * FROM market_db.hongong2;
SELECT LAST_INSERT_ID(); -- 마지막 ID값 확인
ALTER TABLE hongong2 AUTO_INCREMENT = 100; -- 시작값 변경
INSERT INTO hongong2 VALUES (NULL, '기태', 35);

CREATE TABLE hongong3 (
toy_id INT AUTO_INCREMENT PRIMARY KEY,
toy_name CHAR(4),
age INT);
ALTER TABLE hongong3 AUTO_INCREMENT = 1000;
SET @@auto_increment_increment = 3;
INSERT INTO hongong3 VALUES (NULL, "토마스", 20), (NULL, "제임스", 23), (NULL, "고든", 25);

SELECT COUNT(*) FROM world.city;
DESC world.city;
SELECT * FROM world.city LIMIT 5;
CREATE TABLE city_popul (city_name CHAR(35), population INT);
INSERT INTO city_popul SELECT Name, Population FROM world.city;

-- UPDATE = 수정
-- 데이터 바꾸기
USE market_db;
UPDATE city_popul
	SET city_name = '서울'
    WHERE city_name = 'Seoul';
SELECT * FROM city_popul WHERE city_name = '서울';

-- 여러데이터 동시에 바꾸기
SELECT * FROM city_popul WHERE city_name LIKE 'New%';
UPDATE city_popul
	SET city_name = "뉴욕", population = 0
    WHERE city_name = "New York"; -- 이 조건절이 없다면 모든 도시이름이 뉴욕으로 변경이됨. 그럼 아주 ㅈ되는거야
SELECT * FROM city_popul WHERE city_name = '뉴욕';

-- 데이터 전체 바꾸기
UPDATE city_popul
	SET population = population / 10000;
SELECT * FROM city_popul LIMIT 5;

-- DELETE
DELETE FROM city_popul WHERE city_name LIKE "New%";
DELETE FROM city_popul WHERE city_name LIKE "New%" LIMIT 5; -- New로 시작하는 상위 5개 도시를 삭제

CREATE TABLE big_table1 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table2 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table3 (SELECT * FROM world.city, sakila.country);
SELECT COUNT(*) FROM big_table2;
DELETE FROM big_table1; -- DROP 비하여 삭제가 느림, 빈테이블이 남아있음 (약 45만개 기준 30초가 넘음)
DROP TABLE big_table2; -- TABLE 전체를 삭제, 속도가 제일 빠름 (약 45만개 기준 0.68초)
TRUNCATE TABLE big_table3; -- DELETE와 같지만 조건문을 사용불가, 속도가 DELETE보다 빠름 (약 45만개 기준 0.53초)