USE bookstore;
/* 기초문법 */

-- TRIM 문자열 좌우 공백 제거
SELECT TRIM('           안녕하세요         ');
SELECT LTRIM('           안녕하세요         ');
SELECT RTRIM('           안녕하세요         ');

-- BOTH 문자열 좌,우 문자 제거
SELECT TRIM(BOTH '안' FROM '안녕하세요안');

-- LEADING 문자열 좌측 문자 제거
SELECT TRIM(LEADING '안' FROM '안녕하세요안');
SELECT TRIM(LEADING FROM '안녕하세요			'); -- 아무것도 입력을 안하면 문자열 좌측 공백 제거

-- TRAILING 문자열 우측 문자 제거
SELECT TRIM(TRAILING '안' FROM '안녕하세요안');
SELECT TRIM(TRAILING FROM '			안녕하세요'); -- 아무것도 입력을 안하면 문자열 우측 공백 제거

-- LENGTH 글자길이를 나타내줌
SELECT LENGTH('HELLO');
SELECT LENGTH('안녕'); -- BITE 수로 표현
SELECT CHAR_LENGTH('HELLO');
SELECT CHARACTER_LENGTH('안녕'); -- 길이로 표현

-- 대소문자
SELECT UPPER('sql로 시작되는 하루');
SELECT LOWER('A에서 z까지');
SELECT LOWER(bookname) FROM book;

-- 추출
SELECT SUBSTRING('안녕하세요',2,3); -- 2~3번 인덱스 문자를 추출
SELECT SUBSTRING_INDEX('안.녕.하.세.요', '.',2); -- . 을 만난후 2번째 인덱스 문자까지
SELECT SUBSTRING_INDEX('안.녕.하.세.요', '.',-3); -- 뒤에서부터 . 을 만난후 3번째 인덱스 문자까지

SELECT LEFT('안녕하세요', 3); -- 왼쪽(앞)에서 3번째까지
SELECT RIGHT('안녕하세요', 3); -- 오른쪽(뒤)에서 3번째까지

-- CONCAT 결합
SELECT CONCAT('짜릿해 ', '늘새로와', ' 잘생긴게', ' 최고야');
SELECT CONCAT_WS(' 짜릿해! ', '늘새로와', ' 잘생긴게', ' 최고야');
SELECT CONCAT_WS(' : ', bookname, publisher) FROM book;
SELECT bookname, ':', publisher FROM book; -- 구분을 하고싶을때는 CONCAT을 사용하지 않는다
SELECT GROUP_CONCAT(username, ':', phone) '전화' FROM customer; -- customer에서 username과 phone을 ':'로 연결

-- 시간 함수
SELECT NOW(), SYSDATE(), CURRENT_TIMESTAMP;
SELECT CURTIME(), CURRENT_TIME;

-- 날짜 시간 증감 함수
SELECT ADDDATE('2021-08-31', INTERVAL 5 DAY),
		ADDDATE('2021-08-31', INTERVAL 1 MONTH),
        ADDDATE('2021-08-31', INTERVAL 3 YEAR);
SELECT ADDTIME('2021-08-31 23:59:59', '0:0:1'),
		ADDTIME('09:00:00', '2:10:10');
SELECT NOW(), DATE_ADD(NOW(), INTERVAL -1 DAY); -- 하루전        
SELECT NOW(), DATE_ADD(NOW(), INTERVAL -1 MONTH); -- 한달전
SELECT NOW(), DATE_ADD(NOW(), INTERVAL -1 YEAR); -- 일년전
        
-- 날짜/시간 사이의 차이
SELECT DATEDIFF('2022-12-12', NOW());
SELECT TIMEDIFF('2022-12-12 09:30:00', NOW());
SELECT TIMEDIFF('23:23:59', '2:1:1');

-- 날짜/시간 생성
SELECT MAKEDATE(2023, 33); -- 2023년으로부터 33일이 지난날을 표시
SELECT MAKETIME(11,11,10); -- 시간,분,초
SELECT DATE_FORMAT(MAKEDATE(2023, 33), '%Y.%m.%d'); -- 표시 형식을 설정 가능
SELECT QUARTER('2023-02-02'); -- 설정한 날짜가 몇분기인지 표시

-- bookstore 실습
-- 구매 테이블에서 평균 구매 가격을 구함
SELECT AVG(saleprice) FROM orders;
-- CAST() 사용하여 구매 가격을 정수로 출력
SELECT CAST(AVG(saleprice) AS SIGNED) '평균 구매 가격' FROM orders;

-- 데이터 형식 변환
-- CAST() 함수에 다양한 구분자 ($,/,%,@)를 날짜 형식으로 사용해서 변환
SELECT CAST('2023$02$02' AS DATE) '오늘';
SELECT CAST('2023/02/02' AS DATE) '오늘';
SELECT CAST('2023%02%02' AS DATE) '오늘';
SELECT CAST('2023@02@02' AS DATE) '오늘';
SELECT CAST('2023/02@02 11$49%13' AS DATE) '오늘';
SELECT CAST('2023/02@02 11$49%13' AS TIME) '오늘';
SELECT CAST('2023/02@02 11$49%13' AS DATETIME) '오늘';

SELECT * FROM orders;
-- 직전 셀렉트문에서 조회된 행의 개수를 반환
SELECT FOUND_ROWS();

-- bookstore 실습
-- orders 테이블에서 주문일자의 한달전 날짜를 계산
SELECT *, DATE_ADD(orderdate, INTERVAL -1 MONTH) '주문 한달전 날짜' FROM orders;
-- orders 테이블에서 주문일자의 하루전 날짜를 계산
SELECT *, DATE_ADD(orderdate, INTERVAL -1 DAY) '주문 하루전 날짜' FROM orders;
-- orders 테이블에서 분기를 추가해보기
SELECT *, QUARTER(orderdate) FROM orders;
-- 분기를 더하려면
SELECT *, QUARTER(DATE_ADD(orderdate, INTERVAL 3 MONTH)) '분기' FROM orders;