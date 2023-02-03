/* 서브 쿼리 형태 */
CREATE DATABASE lecture;
USE lecture;

CREATE TABLE product(
	code INT,
    name VARCHAR(20),
    price INT);
    
INSERT INTO product VALUES 
(1, '녹차', 2300),
(2, '홍자', 3000), 
(3, '유자차', 1800), 
(4, '보리차', 2500);

SELECT * FROM product;

-- 평균을 구하고 평균 이상의 차를 출력
SELECT * FROM product WHERE price >= (SELECT AVG(price) FROM product);

USE bookstore;

-- 출판사별로 출판사의 평균 도서가격보다 비싼 도서를 구하시오.
SELECT B1.bookname 
	FROM book B1 
    WHERE B1.price > (SELECT AVG(B2.price) 
						FROM book B2 
                        WHERE B2.publisher = B1.publisher);

-- 주문한 내용에서 도서의 가격과 판매가격의 차이가 가장 많은 도서
SELECT MAX(price - saleprice)
	FROM book B, orders O
    WHERE B.bookid = O.bookid;
SELECT * 
	FROM book B, orders O
    WHERE B.bookid = O.bookid
    AND B.price - O.saleprice = (SELECT MAX(price - saleprice)
									FROM book, orders
									WHERE book.bookid = orders.bookid);
