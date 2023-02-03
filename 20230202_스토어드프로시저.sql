/* 스토어드 프로시저 형식

DELIMITER // -- //, %%, $$, && 등으로 대체 가능
CREATE PROCEDURE user_proc()
BEGIN
	-- SQL 쿼리 작성
END //
DELIMITER ; 
CALL user_proc();
				*/

USE market_db;
DROP PROCEDURE IF EXISTS user_proc;

-- 스토어드 프로시저 생성
DELIMITER //
CREATE PROCEDURE user_proc()
BEGIN
	SELECT * FROM member;
END //
DELIMITER ;
CALL user_proc();

-- 스토어드 프로시저 삭제
DROP PROCEDURE user_proc;

-- 매개변수를 추가하여 생성해보기
DROP PROCEDURE IF EXISTS user_proc;
DELIMITER $$
CREATE PROCEDURE user_proc(IN userName VARCHAR(10)) -- 매개변수 추가
BEGIN
	SELECT * FROM member WHERE mem_name = userName;
END $$
DELIMITER ;
CALL user_proc('에이핑크'); -- 괄호안 변수를 입력하면

-- 여러개 매개변수를 추가하여 생성해보기
DROP PROCEDURE IF EXISTS user_proc2;
DELIMITER %%
CREATE PROCEDURE user_proc2(
IN userNumber INT,
IN userHeight INT)
BEGIN
	SELECT * FROM member 
		WHERE mem_number > userNumber
        AND height > userHeight;
END %%
DELIMITER ;
CALL user_proc2(6, 160);

-- OUT (출력) 매개변수 활용
DELIMITER !!
CREATE PROCEDURE user_proc3 (
IN txtValue CHAR(10),
OUT outValue INT)
BEGIN
	INSERT INTO noTable VALUES (NULL, txtValue);
    SELECT MAX(id) INTO outValue FROM noTable;
END !!
DELIMITER ;
CALL user_proc3(); -- noTable이 없어 작동하지 않음.
DESC noTable;

CREATE TABLE IF NOT EXISTS noTable(
	id INT AUTO_INCREMENT PRIMARY KEY,
    txt CHAR(10)); -- noTable 테이블 생성
CALL user_proc3('', @myValue);
SELECT CONCAT('입력된 ID 값 ==>', @myValue);
SELECT * FROM noTable;

-- SQL 프로그래밍의 활용
DROP PROCEDURE IF EXISTS ifelse_proc;
DELIMITER //
CREATE PROCEDURE ifelse_proc(IN memName VARCHAR(10))
BEGIN
	DECLARE debutYear INT;
    SELECT YEAR(debut_date) INTO debutYear FROM member WHERE mem_name = memName;
    IF (debutYear >= 2015) THEN
		SELECT '신인 가수네요. 화이팅 하세요.' AS '메세지';
	ELSE
		SELECT '고령 가수네요. 수고하셨어요.' AS '메세지';
	END IF;
END //
DELIMITER ;
CALL ifelse_proc('소녀시대');

/* 스토어드 함수 */
SET GLOBAL log_bin_trust_function_creators = 1; -- 함수 생성 권한 허용
USE market_db;
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)
	RETURNS INT
BEGIN
	RETURN number1 + number2;
END $$
DELIMITER ;
SELECT sumFunc(16, 17) '합계';

-- 걸그룹 활동 년수 계산기 만들기
DROP FUNCTION IF EXISTS calcYearfunc;
DELIMITER %%
CREATE FUNCTION calcYearfunc(dYear INT)
	RETURNS INT
BEGIN
	DECLARE runYear INT; 
    SET runYear = YEAR(CURDATE()) - dYear;
    RETURN runYear;
END %%
DELIMITER ;
SELECT mem_id, mem_name, calcYearfunc(YEAR(debut_date)) '활동한 년도'FROM member;

-- 현재 선언된 스토어드 함수를 확인
SHOW CREATE FUNCTION calcYearfunc;

-- 스토어드 함수 삭제
DROP FUNCTION calcYearfunc;

/* 커서 형식
USE market_db;
DROP PROCEDURE IF EXISTS  cursor_proc;
DELIMITER //
CREATE PROCEDURE cursor_proc()
BEGIN
	-- 1. 변수를 선언
    -- 2. 커서 선언
    -- 3. 반복조건 선언
    -- 4. 커서 열기
    -- 5. 행 반복
    -- 6. 커서 닫기
END //
DELIMITER ;
CALL cursor_proc(); 
 */
USE market_db;
DROP PROCEDURE IF EXISTS  cursor_proc;
DELIMITER //
CREATE PROCEDURE cursor_proc()
BEGIN
	-- 1. 변수를 선언
    DECLARE memNumber INT; -- 회원의 인원수
    DECLARE cnt INT DEFAULT 0; -- 읽은 행의 수 (초기값을 0으로)
    DECLARE totNumber INT DEFAULT 0; -- 인원의 합계 (초기값을 0으로)
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부 endOfRow를 기본값은 FALSE로 초기화
    -- 2. 커서 선언
    DECLARE memberCuror CURSOR FOR SELECT mem_number FROM member;
    -- 3. 반복조건 선언
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endOfRow = TRUE; -- 행이 끝나면 endOfRow 값은 TRUE 값으로
    -- 4. 커서 열기
    OPEN memberCuror;
    -- 5. 행 반복
    cursor_loop: LOOP
		FETCH memberCuror INTO memNumber;
        IF endOfRow THEN
		LEAVE cursor_loop;
	END IF;
    
    SET cnt = cnt + 1;
    SET totNumber = totNumber + memNumber;
    END LOOP cursor_loop;
    
	SELECT (totNumber/cnt) '회원의 평균 인원 수';
    -- 6. 커서 닫기
    CLOSE memberCuror;
END //
DELIMITER ;
CALL cursor_proc();

/* 트리거 */
USE market_db;
CREATE TABLE IF NOT EXISTS trigger_table (id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES (1, '레드벨벳'), (2, '잇지'), (3, '블랙핑크');
SELECT * FROM trigger_table;
-- 생성한 테이블에 트리거 부착
DROP TRIGGER IF EXISTS myTrigger;
DELIMITER //
CREATE TRIGGER myTrigger
	AFTER DELETE
	ON trigger_table
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹이 삭제됨'; -- 트리거 실행 시 작동되는 코드
END //
DELIMITER ;

DROP TRIGGER IF EXISTS myTrigger2;
DELIMITER //
CREATE TRIGGER myTrigger2
	AFTER INSERT
	ON trigger_table
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹이 추가됨'; -- 트리거 실행 시 작동되는 코드
END //
DELIMITER ;

DROP TRIGGER IF EXISTS myTrigger3;
DELIMITER //
CREATE TRIGGER myTrigger3
	AFTER UPDATE
	ON trigger_table
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹 정보가 변경됨'; -- 트리거 실행 시 작동되는 코드
END //
DELIMITER ;

SET @msg = '';
DELETE FROM trigger_table WHERE txt = '레드벨벳';
SELECT @msg;
INSERT INTO trigger_table VALUES (2, '잇지');
SELECT @msg;
UPDATE trigger_table SET id = 1 WHERE id = 2;
SELECT @msg;

CREATE TABLE singer (SELECT mem_id, mem_name, mem_number, addr FROM member);
CREATE TABLE backup_singer (
mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL,
mem_number INT NOT NULL,
addr CHAR(2) NOT NULL,
modType CHAR(2),
modDate DATE,
modUser VARCHAR(30)
);
DROP TRIGGER IF EXISTS singer_updateTrg;
DELIMITER //
CREATE TRIGGER singer_updateTrg
	AFTER UPDATE
    ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES(OLD.mem_id, OLD.mem_name, OLD.mem_number, OLD.addr, '수정', CURDATE(), CURRENT_USER());
END //
DELIMITER ;

DROP TRIGGER IF EXISTS singer_deleteTrg;
DELIMITER //
CREATE TRIGGER singer_deleteTrg
	AFTER DELETE
    ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES(OLD.mem_id, OLD.mem_name, OLD.mem_number, OLD.addr, '삭제', CURDATE(), CURRENT_USER());
END //
DELIMITER ;

UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
DELETE FROM singer WHERE mem_number >= 7;
SELECT * FROM backup_singer; -- 트리거 작동 확인

TRUNCATE TABLE singer; -- TRUNCATE 트리거는 만들지 않았기 때문에 작동하지않음. DELETE문에만 작동
DELETE FROM singer;
SELECT * FROM backup_singer; -- TRUNCATE는 반응하지 않지만 DELETE에는 반응하여 백업됨.