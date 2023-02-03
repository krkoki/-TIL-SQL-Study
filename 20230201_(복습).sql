USE bookstore;
INSERT INTO book VALUES(NULL, 'Open 파이썬', '포웨이', 23500);
INSERT INTO book VALUES(NULL, '자연어 처리 시작하기', '투시즌', 20000);
INSERT INTO book VALUES(NULL, 'SQL 이해', '새미디어', 22000);

INSERT INTO customer VALUES (NULL, '박보영', '서울 서초구', '010-5634-4450');
INSERT INTO customer VALUES (NULL, '오정세', '서울 중구', '010-1464-4556');
INSERT INTO customer VALUES (NULL, '이병헌', '서울 성북구', NULL);

INSERT INTO orders VALUES (11, 6, 12, 23500, STR_TO_DATE('2020-02-01', '%Y-%m-%d'));
INSERT INTO orders VALUES (12, 6, 13, 44000, STR_TO_DATE('2020-02-03', '%Y-%m-%d'));
INSERT INTO orders VALUES (13, 8, 13, 20000, STR_TO_DATE('2020-02-03', '%Y-%m-%d'));
INSERT INTO orders VALUES (14, 3, 13, 20000, STR_TO_DATE('2020-02-04', '%Y-%m-%d'));
INSERT INTO orders VALUES (15, 4, 12, 23500, STR_TO_DATE('2020-02-05', '%Y-%m-%d'));
INSERT INTO orders VALUES (16, 5, 8, 35000, STR_TO_DATE('2020-02-07', '%Y-%m-%d'));

SELECT * FROM book WHERE bookid IN (12, 13, 14);
-- SELECT @@SQL_SAFE_UPDATES; -- 현재 보안 등급 확인
-- SET SQL_SAFE_UPDATES=0;
-- SET SQL_SAFE_UPDATES=1;

-- v_order 뷰를 생성
-- orderid, custid, username, bookid, saleprice, orderdate
CREATE OR REPLACE VIEW v_order
AS
	SELECT orderid, O.custid, username, O.bookid, saleprice, orderdate 
    FROM customer C, orders O, book B
    WHERE C.custid = O.custid AND B.bookid = O.bookid;
-- 도서 가격이 20000원 이상인 레코드로 변경
CREATE OR REPLACE VIEW v_order
AS SELECT C.custid, username, address, saleprice
    FROM customer C, orders O, book B
    WHERE C.custid = O.custid AND B.bookid = O.bookid AND B.price >= 20000;
-- customer 뷰도 생성 v_cust_purchase
-- username -> 고객, saleprice를 sum -> 구매액
-- 고객을 기준으로 집계한 후 구매액을 기준으로 내림차순
-- 구매 고객의 매출 순위 RANK() 사용
CREATE OR REPLACE VIEW v_cust_purchase
AS
	SELECT C.username 고객, SUM(O.saleprice) 구매액,
    DENSE_RANK() OVER (ORDER BY SUM(O.saleprice) DESC) DENSE_RANK순위
    FROM customer C, orders O
	WHERE O.custid = C.custid
    GROUP BY 고객
    ORDER BY 구매액 DESC;
-- 두개 뷰 삭제
DROP VIEW v_order, v_cust_purchase;