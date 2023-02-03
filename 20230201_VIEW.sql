USE market_db;
/* VIEW */
SELECT mem_id, mem_name, addr FROM member; -- SELECT는 VIEW와 같다

-- VIEW 생성
CREATE VIEW v_member -- VIEW 생성하기 (SELECT 코드를 저장하는 의미)
	AS SELECT mem_id, mem_name, addr FROM member;

-- VIEW 불러오기
SELECT * FROM v_member;
SELECT mem_name, addr FROM v_member WHERE addr IN ('서울', '경기');

-- VIEW의 실제 작동
CREATE VIEW v_viewtest1
AS
	SELECT B.mem_id 'Member ID', M.mem_name 'Member Name', B.prod_name 'Product Name', CONCAT(M.phone1, M.phone2) "Office phone"
    FROM buy B
    INNER JOIN member M
    ON B.mem_id = M.mem_id;
SELECT DISTINCT `Member ID`, `Member Name` FROM v_viewtest1; -- 기존에는 공백을 '' 따옴표로 묶어주지만, VIEW에서는 `` 백틱으로 묶어주어야한다.

-- VIEW 의 수정
ALTER VIEW v_viewtest1
AS
	SELECT B.mem_id '회원 ID', M.mem_name '회원 이름', B.prod_name '제품 이름', CONCAT(M.phone1, M.phone2) "연락처"
    FROM buy B
    INNER JOIN member M
    ON B.mem_id = M.mem_id;
SELECT DISTINCT `회원 ID`, `회원 이름`, `연락처` FROM v_viewtest1;

-- VIEW DROP
DROP VIEW v_viewtest1;

-- REPLACE 덮어쓰기
CREATE OR REPLACE VIEW v_viewtest2 -- 만들던지 생성되어 있으면 덮어쓰라는 뜻
AS
	SELECT mem_id, mem_name, addr FROM member;

-- VIEW 정보 확인
DESCRIBE v_viewtest2; -- VIEW도 TABLE과 동일하게 정보를 보여주지만, PRIMARY KEY등의 1값은 확인이 불가능하다.
SHOW CREATE VIEW v_viewtest2;

-- VIEW 수정 및 삭제
UPDATE v_member SET addr = '부산' WHERE mem_id = 'BLK';
INSERT INTO v_member VALUES ('BTS', '방탄소년단', '경기'); -- 원래 member TABLE 안에 mem_number 가 NOT NULL 제약조건이 있어, mem_number를 넣어줘야함.

-- 지정한 범위 VIEW를 생성
CREATE VIEW v_height167
AS
	SELECT * FROM member WHERE height >= 167;

SELECT * FROM v_height167;
DELETE FROM v_height167 WHERE height <167; -- 167 이하 값 삭제, 값이 없으므로 0개 값이 삭제되었다는 메세지가 나온다.

INSERT INTO v_height167 VALUES ('TRA', '티아라', 6, '서울', NULL, NULL, 159, '2005-01-01'); -- 167 이하 값을 추가해보면
SELECT * FROM v_height167; -- 조건에 부합되지않아 표시가 되지 않는다. (member TABLE엔 들어가있음)

-- VIEW의 설정값의 범위가 벗어나는 값은 입력되지 않도록 속성값 수정
ALTER VIEW v_height167
AS
	SELECT * FROM member WHERE height >= 167
		WITH CHECK OPTION; -- check 옵션 추가하여 벗어나는 값이 입력되지 않도록 방지.
INSERT INTO v_height167 VALUES ('TOB', '텔레토비', 4, '영국', NULL, NULL, 140, '1995-01-01'); -- CHECK 옵션으로 인하여 VIEW 조건에 부합하지 않아 오류가 발생한다.

-- 복합뷰는 입력/수정/삭제가 불가능하다.