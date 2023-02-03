DROP DATABASE IF EXISTS  bookstore;
CREATE SCHEMA bookstore;
USE bookstore;
CREATE TABLE book(
bookid INT PRIMARY KEY AUTO_INCREMENT,
bookname VARCHAR(40),
publisher VARCHAR(40),
price INT);
CREATE TABLE customer(
custid INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(40),
address VARCHAR(50),
phone VARCHAR(20));
CREATE TABLE orders(
orderid INT PRIMARY KEY AUTO_INCREMENT,
custid INT,
bookid INT,
saleprice INT,
orderdate DATE,
FOREIGN KEY (custid) REFERENCES customer(custid),
FOREIGN KEY (bookid) REFERENCES book(bookid)
);

INSERT INTO book VALUES(NULL, '철학의 역사', '정론사', 7500);
INSERT INTO book VALUES(NULL, '3D 모델링 시작하기', '한비사', 15000);
INSERT INTO book VALUES(NULL, 'SQL 이해', '새미디어', 22000);
INSERT INTO book VALUES(NULL, '텐서플로우 시작', '새미디어', 35000);
INSERT INTO book VALUES(NULL, '인공지능 개론', '정론사', 8000);
INSERT INTO book VALUES(NULL, '파이썬 고급', '정론사', 8000);
INSERT INTO book VALUES(NULL, '객체지향 Java', '튜링사', 20000);
INSERT INTO book VALUES(NULL, 'C++ 중급', '튜링사', 18000);
INSERT INTO book VALUES(NULL, 'Secure 코딩', '정보사', 7500);
INSERT INTO book VALUES(NULL, 'Machine learning 이해', '새미디어', 32000);

INSERT INTO customer VALUES (NULL, '박지성', '영국 맨체스터', '010-1234-1010');
INSERT INTO customer VALUES (NULL, '김연아', '대한민국 서울', '010-1223-3456');
INSERT INTO customer VALUES (NULL, '장미란', '대한민국 강원도', '010-4878-1901');
INSERT INTO customer VALUES (NULL, '추신수', '대한민국 부산', '010-8000-8765');
INSERT INTO customer VALUES (NULL, '박세리', '대한민국 대전', NULL);

INSERT INTO orders VALUES (NULL, 1, 1, 7500, STR_TO_DATE('2021-02-01','%Y-%m-%d')); 
INSERT INTO orders VALUES (NULL, 1, 3, 44000, STR_TO_DATE('2021-02-03','%Y-%m-%d'));
INSERT INTO orders VALUES (NULL, 2, 5, 8000, STR_TO_DATE('2021-02-03','%Y-%m-%d')); 
INSERT INTO orders VALUES (NULL, 3, 6, 8000, STR_TO_DATE('2021-02-04','%Y-%m-%d')); 
INSERT INTO orders VALUES (NULL, 4, 7, 20000, STR_TO_DATE('2021-02-05','%Y-%m-%d'));
INSERT INTO orders VALUES (NULL, 1, 2, 15000, STR_TO_DATE('2021-02-07','%Y-%m-%d'));
INSERT INTO orders VALUES (NULL, 4, 8, 18000, STR_TO_DATE( '2021-02-07','%Y-%m-%d'));
INSERT INTO orders VALUES (NULL, 3, 10, 32000, STR_TO_DATE('2021-02-08','%Y-%m-%d')); 
INSERT INTO orders VALUES (NULL, 2, 10, 32000, STR_TO_DATE('2021-02-09','%Y-%m-%d')); 
INSERT INTO orders VALUES (NULL, 3, 8, 18000, STR_TO_DATE('2021-02-10','%Y-%m-%d'));

CREATE TABLE BookLibrary(
bookid INT,
bookname VARCHAR(20),
publisher VARCHAR(20),
price INT,
PRIMARY KEY(bookname, publisher));

-- 1. 테이블을 요약
DESC BookLibrary;

-- 2. 집계
-- orders 도서판매건수를 구하는 쿼리 작성해보기
-- 고객이 주문한 도서의 총 판매액을 구하는 쿼리 작성
-- 고객이 주문한 도서의 총 판매액을 '총매출'로 구하시오
-- 고객이 주문한 도서의 총 판매액의 평균을 구하고 '매출평균'으로 구하시오
-- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오 (Total, Average, Minimum, Maximum)

SELECT COUNT(saleprice) FROM orders; -- orders 도서판매건수
SELECT SUM(saleprice) FROM orders; -- 고객이 주문한 도서의 총 판매액
SELECT SUM(saleprice) 총매출 FROM orders; -- 고객이 주문한 도서의 총 판매액을 '총매출'로 구하시오
SELECT AVG(saleprice) 매출평균 FROM orders; -- 고객이 주문한 도서의 총 판매액의 평균을 구하고 '매출평균'으로 구하시오
SELECT SUM(saleprice) Total,
		AVG(saleprice) Average,
		MIN(saleprice) Minimum,
		MAX(saleprice) Maximum 
	FROM orders; -- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오 (Total, Average, Minimum, Maximum)

-- 3. 조회
-- 책 가격이 22000원 미만인 도서 검색해보기
-- 책 가격이 10000보다 크고 20000 이하인 도서 검색 and
-- 책 가격이 10000보다 크고 20000 이하인 도서 검색 between
-- 주문 일자가 2021/02/01에서 2021/02/07사이에 주문내역 출력
-- 도서번호가 3,4,5,6인 주문 목록을 출력

SELECT * FROM book WHERE price < 22000; -- 책 가격이 22000원 미만인 도서 검색
SELECT * FROM book WHERE price >= 10000 AND price <=20000; -- 책 가격이 10000보다 크고 20000 이하인 도서 검색 and
SELECT * FROM book WHERE price BETWEEN 10000 AND 20000; -- 책 가격이 10000보다 크고 20000 이하인 도서 검색 between
SELECT * FROM orders WHERE orderdate >= '2021-02-01' AND orderdate <= '2021-02-07';
SELECT * FROM orders WHERE bookid IN (3, 4, 5, 6); -- 도서번호가 3,4,5,6인 주문 목록을 출력 IN
SELECT * FROM orders WHERE bookid BETWEEN 3 AND 6; -- 도서번호가 3,4,5,6인 주문 목록을 출력 BETWEEN
SELECT * FROM orders WHERE bookid >= 3 AND bookid <= 6; -- 도서번호가 3,4,5,6인 주문 목록을 출력 AND

INSERT INTO book VALUES(11, 'SQL 기본 다지기', 'MS출판사', NULL);
-- 11번에 price를 1000원 올려서 출력
-- price 컬럼의 집계함수를 실행 sum, avg, count, count(price)
-- book 에서 null인 레코드를 출력하는 쿼리 작성해보기
-- customer에서 이름, 전화번호가 포함된 고객목록을 조회하고 전화번호가 없으면 '연락처 없음'으로 바꾸기

SELECT price + 1000 FROM book WHERE bookid = 11; -- 11번에 price를 1000원 올려서 출력
SELECT SUM(price), AVG(price), COUNT(*), COUNT(price) FROM book; -- price 컬럼의 집계함수를 실행 sum, avg, count, count(price)
SELECT * FROM book WHERE price IS NULL; -- book 에서 null인 레코드를 출력
SELECT username 이름, IFNULL(phone, '연락처 없음') '전화번호' FROM customer; -- customer에서 이름, 전화번호가 포함된 고객목록을 조회하고 전화번호가 없으면 '연락처 없음'으로 바꾸기

-- 박씨성을 가진 고객만 출력
-- 2번째 글자가 '지'인 고객을 출력
-- '철학의 역사'를 출간한 출판사 검색
-- 도서이름 '파이썬'이 포함된 출판사 검색
-- '썬'으로 일치하는 도서중 가격이 20000원 이상인 도서 검색
-- 출판사 이름이 '정론사' 또는 '새미디어'인 도서를 검색

SELECT username FROM customer WHERE username LIKE '박%'; -- 박씨성을 가진 고객을 출력
SELECT username FROM customer WHERE username LIKE '_지_'; -- 2번째 글자가 '지'인 고객을 출력
SELECT bookname, publisher FROM book WHERE bookname = '철학의 역사'; -- '철학의 역사'를 출간한 출판사 검색
SELECT * FROM book WHERE bookname LIKE '%파이썬%';-- 도서이름 '파이썬'이 포함된 출판사 검색
SELECT * FROM book WHERE bookname LIKE '%썬%' AND price >= 20000; -- '썬'으로 일치하는 도서중 가격이 20000원 이상인 도서 검색
SELECT * FROM book WHERE publisher = '정론사' OR publisher = '새미디어'; -- 출판사 이름이 '정론사' 또는 '새미디어'인 도서를 검색

/* ORDER BY */
-- 도서 이름 순으로 검색
-- 도서 가격으로 검색하고 가격이 같으면 이름순으로
-- 도서가격의 내림차순으로 검색하고 만약 같다면 출판사 이름으로 오름차순 검색
-- 주문일자 내림차순으로 정렬
-- 책이름중 '썬'이 포함되어 있고 가격이 20000원 미만 출판사로 오름차순 검색
-- 판매가격이 1000원 초과인 책 id를 출력

SELECT * FROM book ORDER BY bookname; -- 도서 이름 순으로 검색
SELECT * FROM book ORDER BY price, bookname; -- 도서 가격으로 검색하고 가격이 같으면 이름순으로
SELECT * FROM book ORDER BY price DESC, bookname; -- 도서가격의 내림차순으로 검색하고 만약 같다면 출판사 이름으로 오름차순 검색
SELECT * FROM orders ORDER BY orderdate DESC; -- 주문일자 내림차순으로 정렬
SELECT * FROM book WHERE bookname LIKE '%썬%' AND price < 20000 ORDER BY publisher; -- 책이름중 '썬'이 포함되어 있고 가격이 20000원 미만 출판사로 오름차순 검색
SELECT bookid FROM book WHERE price > 1000; -- 판매가격이 1000원 초과인 책 id를 출력