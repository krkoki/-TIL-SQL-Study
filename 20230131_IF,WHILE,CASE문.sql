/* SQL 프로그래밍 */
-- IF 문
DROP PROCEDURE IF EXISTS ifProc1;
DELIMITER $$  
CREATE PROCEDURE ifProc1()
BEGIN
	IF 100 = 100 THEN
		SELECT '100은 100과 같습니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc1();

-- IF ELSE 문
DROP PROCEDURE IF EXISTS ifProc2;
DELIMITER //
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE myNum INT; -- 함수내는 DECLARE 함수밖은 @ 붙인다
    SET myNum = 200;
    IF myNum = 100 THEN
		SELECT '100입니다.';
	ELSE
		SELECT '100이 아닙니다.';
	END IF;
END //
DELIMITER ;
CALL ifProc2();

-- 데뷔한지 5년 이상이면 축하메세지, 5년 이하면 격려메세지가 나오게 해보기
-- 데뷔한지, 000days, 일이 지났습니다. 축하합니다.
-- 데뷔한지, 000days, 일밖에 안되었네요. 좀 더 노력해주세요.
DROP PROCEDURE IF EXISTS deBut;
DELIMITER //
CREATE PROCEDURE deBut()
BEGIN
	DECLARE debutDate DATE;
    DECLARE nowDate DATE;
    DECLARE days INT;
    SELECT debut_date INTO debutDate FROM market_db.member WHERE mem_id = 'ITZ';
    SET nowDate = CURRENT_DATE();
    SET days = DATEDIFF(nowDate, debutDate);
    
    IF (days/365) >= 5 THEN
		SELECT '데뷔한 지', days, '일이나 지났습니다. 축하합니다!!';
	ELSE
		SELECT '데뷔한 지', days, '일밖에 안되었네요.. 조금만 더 노력해주세요..';
	END IF;
END //
DELIMITER ;
CALL deBut();

-- CASE 문
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER %%
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 88;
    
    CASE
		WHEN point >= 90 THEN
        SET credit = 'A';
        WHEN point >= 80 THEN
        SET credit = 'B';
        WHEN point >= 70 THEN
        SET credit = 'C';
        WHEN point >= 60 THEN
        SET credit = 'D';
	ELSE
		SET credit = 'F';
    END CASE;
    SELECT CONCAT("취득점수 ==>", point) "점수", CONCAT("학점은 ", credit, "입니다.") "학점";
END %%
DELIMITER ;
CALL caseProc();

-- 해보기
USE market_db;
DROP PROCEDURE IF EXISTS buyKing;
DELIMITER //
CREATE PROCEDURE buyKing()
BEGIN
	SELECT M.mem_id, M.mem_name, SUM(price*amount) "총 구매 금액",
	CASE
		WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
        WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
        WHEN (SUM(price*amount) >= 1) THEN '일반고객'
        ELSE '유령고객'
    END "회원등급"
	FROM buy B
		RIGHT OUTER JOIN member M
		ON B.mem_id = M.mem_id
    GROUP BY M.mem_id
	ORDER BY SUM(price*amount) DESC;
END //
DELIMITER ;
CALL buyKing();

-- WHILE 문
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER %%
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;
    DECLARE J INT;
    SET i = 1;
    SET j = 0;
WHILE (i <= 100) DO
	SET j = j + i;
    SET i = i + 1;
END WHILE;
SELECT '1부터 100까지의 합 ==>', j;
END %%
DELIMITER ;
CALL whileProc();

DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER %%
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT;
    DECLARE J INT;
    SET i = 1;
    SET j = 0;
    
    myWhile: -- 레이블 지정
	WHILE (i <= 100) DO
		IF (I%4 =0) THEN
			SET i = i + 1;
            ITERATE myWhile;
        END IF;
        SET j = j + i;
        IF (j > 1000) THEN
			LEAVE myWhile;
		END IF;
        SET i = i + 1;
	END WHILE;
SELECT '1부터 100까지의 합(4의 배수 제외), 1000이 넘으면 종료', j;
END %%
DELIMITER ;
CALL whileProc2();

-- 해보기
-- bookstore 이동
-- 주문고객목록 custid 중복제거
-- 판매가격 목록 salesprice 중복제거
-- case 다중조건을 활용
/* 고객등급으로 컬럼명을 표시
salesprice >= 15000 '최우수고객'
salesprice >= 10000 '우수고객'
salesprice >= 5000 '일반고객'
salesprice = 0 '유령고객'
 */ 
USE bookstore;
SELECT DISTINCT custid FROM orders;
SELECT DISTINCT saleprice FROM orders;
SELECT custid, SUM(saleprice) AS '총구매액',
	CASE
    WHEN (SUM(saleprice) >= 15000) THEN '최우수고객'
    WHEN (SUM(saleprice) >= 10000) THEN '우수고객'
    WHEN (SUM(saleprice) >= 5000) THEN '일반고객'
    ELSE '유령고객'
  END AS '고객 등급'
FROM orders O
GROUP BY custid; 

/* 동적 SQL */
DROP TABLE IF EXISTS gate_table;
CREATE TABLE gate_table (id INT AUTO_INCREMENT PRIMARY KEY, entry_time DATETIME);

SET @curDate = CURRENT_TIMESTAMP();

PREPARE myQuery FROM 'INSERT INTO gate_table VALUES (NULL, ?)';
EXECUTE myQuery USING @curDate;

SELECT * FROM gate_table;