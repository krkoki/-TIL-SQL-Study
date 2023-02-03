USE market_db;
SELECT * FROM member;

SELECT mem_name FROM member;

SELECT addr, mem_name, debut_date FROM member;

-- alias 별칭
SELECT addr 주소, 
mem_name 그룹명, 
debut_date "데뷔 날짜" 
FROM member;

-- 이거슨 주석

-- 관걔 연산자
SELECT * FROM member WHERE debut_date >= "2016-08-08";
-- 논리 연산자
SELECT * FROM member WHERE height >= 165 AND mem_number >6;
SELECT * FROM member WHERE height >= 165 OR mem_number >6;

-- BETWEEN (숫자형만)
SELECT * FROM member WHERE height <= 165 AND height >= 160;
SELECT * FROM member WHERE height BETWEEN 160 AND 165;

-- IN()
SELECT * FROM member WHERE addr = '경기' OR addr = '서울';
SELECT * FROM member WHERE addr IN('경기', '서울');

-- LIKE (문자열의 일부분을 검색)
SELECT * FROM member WHERE mem_name LIKE '%이%';
SELECT * FROM member WHERE mem_name LIKE '__핑크';
SELECT * FROM member WHERE mem_name LIKE '___';

-- 해보기 name "에이핑크"의 키 값을 확인한뒤, 확인한 키 값보다 큰 걸그룹만 보이게
SELECT height FROM member WHERE mem_name = '에이핑크';
SELECT mem_name, height FROM member WHERE height > 164;
SELECT mem_name, height FROM member WHERE height > (SELECT height FROM member WHERE mem_name = '에이핑크');

-- 3장 2절
-- ORDER BY = 정렬
-- 데뷔일을 빠른순서대로 정렬 (Default 값은 오름차순)
SELECT mem_id, mem_name, debut_date FROM member ORDER BY debut_date;
-- 내림차순
SELECT mem_id, mem_name, debut_date 
FROM member 
ORDER BY debut_date DESC;

-- 조건절 추가 정렬
SELECT mem_id, mem_name, debut_date, height
FROM member 
WHERE height >= 164 
ORDER BY debut_date DESC;

-- 해보기 키를 기준으로 내림차순
SELECT mem_id, mem_name, debut_date, height
FROM member
ORDER BY height DESC;

-- 정렬 세부 조건 추가
SELECT mem_id, mem_name, debut_date, height
FROM member
ORDER BY height DESC, debut_date ASC;

-- LIMIT = 출력개수 제한 (파이썬의 head()와 비슷)
SELECT mem_id, mem_name, debut_date, height
FROM member
ORDER BY height DESC, debut_date ASC
LIMIT 5;

-- DISTINCT = 중복제거
SELECT DISTINCT addr FROM member;

-- GROUP BY
SELECT mem_id, SUM(amount) FROM buy GROUP BY mem_id; -- SUM = 합계
SELECT mem_id, AVG(amount) FROM buy GROUP BY mem_id; -- AVG = 평균
SELECT mem_id, MIN(amount) FROM buy GROUP BY mem_id; -- MIN = 최소값
SELECT mem_id, MAX(amount) FROM buy GROUP BY mem_id; -- MAX = 최대값
SELECT mem_id, COUNT(amount) FROM buy GROUP BY mem_id; -- COUNT = 행의 개수

-- 회원아이디 총 구매 개수 해보기
SELECT mem_id "회원 아이디", SUM(amount) "총 구매 개수" 
FROM buy 
GROUP BY mem_id 
ORDER BY mem_id;

-- 총 구매 금액 해보기
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
FROM buy
GROUP BY mem_id
ORDER BY mem_id;

-- 평균 구매 개수 해보기
SELECT AVG(amount) "평균 구매 개수" FROM buy;

-- 총 구매 금액이 1000원 이상인 걸그룹
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액" 
FROM buy
GROUP BY mem_id
HAVING SUM(price*amount) > 1000;

-- 총 구매 금액이 1000원이상인 걸그룹을 총 구매 금액으로 내림차순 정렬
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액" 
FROM buy
GROUP BY mem_id
HAVING SUM(price*amount) > 1000
ORDER BY SUM(price*amount) DESC;