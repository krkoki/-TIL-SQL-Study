CREATE DATABASE netflix_db;
USE netflix_db;
CREATE TABLE movie(
movie_id INT,
movie_title VARCHAR(30),
movie_director VARCHAR(20),
movie_star VARCHAR(20),
movie_script LONGTEXT,
movie_film LONGBLOB);

USE market_db;
SET @myVar1 = 5;
SET @myVar2 = 4.25;

SELECT @myVar1;
SELECT @myVar1 + @myVar2;

SET @txt = '가수 이름 ==>';
SET @height = 166;
SELECT @txt , mem_name FROM member WHERE height > @height;

-- 비교연산
SELECT 1 > 100;
SELECT 1 < 100;
SELECT 10 = 10;
SELECT 101 != 10;
SELECT 101 <> 10;

-- 논리연산
SELECT (10 >= 10) AND (5 < 10);
SELECT (10 > 10) AND (5 < 10);
SELECT (10 > 10) OR (5 < 10);
SELECT NOT (10 > 10);

SET @count = 3;
SELECT mem_name, height FROM member ORDER BY height LIMIT @count; -- LIMIT는 변수를 사용할 수 없다
PREPARE KK FROM'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';
EXECUTE KK USING @count; -- PREPARE ~ EXECUTE문을 사용하면 가능하다

-- 데이터 형 변환
SELECT AVG(price) AS '평균 가격' FROM buy;
SELECT CAST(AVG(price) AS SIGNED) AS '평균 가격' FROM buy; 
SELECT CONVERT(AVG(price), SIGNED) AS '평균 가격' FROM buy;

/* 내부 조인 */
USE market_db;
SELECT * FROM buy JOIN member ON buy.mem_id = member.mem_id WHERE buy.mem_id = "GRL";
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, CONCAT(phone1, phone2) AS '연락처'
 FROM buy B 
 JOIN member M
 ON B.mem_id = M.mem_id;

-- 전체 회원 아이디 이름 구매한 제품 주소
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
 FROM buy B 
 JOIN member M
 ON B.mem_id = M.mem_id
 ORDER BY M.mem_id; -- 내부 조인은 두 테이블에 모두 있는 내용만 출력되어 전체 회원으로 검색하더라도 결과는 동일하다.
 
-- 중복된 결과를 제외한 회원 출력하기
SELECT DISTINCT M.mem_id, M.mem_name, M.addr
 FROM buy B 
 JOIN member M
 ON B.mem_id = M.mem_id
 ORDER BY M.mem_id;

/* 외부 조인 */
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM member M
LEFT OUTER JOIN buy B
ON M.mem_id = B.mem_id
ORDER BY M.mem_id;

/* 기타 조인 */
SELECT * FROM buy CROSS JOIN member;

-- 상호 조인
CREATE TABLE cross_table
	SELECT *
		FROM sakila.actor
			CROSS JOIN world.country;
SELECT * FROM cross_table LIMIT 5;
SELECT COUNT(*) FROM cross_table;
DROP TABLE cross_table;

-- 자체 조인
CREATE TABLE emp_table(
emp CHAR(4),
manager CHAR(4),
phone VARCHAR(8));
INSERT INTO emp_table VALUES('대표', NULL, '0000'), 
							('영업이사', '대표', '1111'), 
							('관리이사', '대표', '2222'), 
							('정보이사', '대표', '3333'), 
							('영업과장', '영업이사', '1111-1'), 
							('경리부장', '관리이사', '2222-1'), 
							('인사부장', '관리이사', '2222-2'), 
							('개발팀장', '정보이사', '3333-1'), 
							('개발주임', '정보이사', '3333-1-1');
SELECT A.emp "직원", B.emp "직속상관", B.phone "직속상관 연락처" FROM emp_table A INNER JOIN emp_table B ON A.manager = B.emp;