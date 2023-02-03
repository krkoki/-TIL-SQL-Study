USE sakila;

-- 배우 이름 조회
SELECT CONCAT(first_name, ' ' ,last_name) FROM actor;
-- son으로 끝나는 성을 가진 배우 조회
SELECT CONCAT(first_name, ' ' ,last_name) 슨슨이들 FROM actor WHERE UPPER(last_name) LIKE '%SON';
-- 배우들이 출연한 영화
SELECT CONCAT(A.first_name, ' ' , A.last_name) 배우, 
F.title, f.release_year
FROM actor A, film F, film_actor B
WHERE A.actor_id = B.actor_id 
	AND B.film_id = F.film_id;
-- 이름(last_name)별 배우 숫자
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;
-- 국가가 오스트레일리아, 독일 countryid / country
SELECT country_id,  country FROM country WHERE country IN ('Australia','Germany');
-- staff 테이블에서 성과 이름을 합치고 컬럼명을 STAFF, staff 테이블과 address 테이블을 합치고 합친 테이블에서 address, district, postal, code, city_id
SELECT CONCAT(S.first_name, ' ', S.last_name) STAFF, A.address 주소, A.district, IFNULL(A.postal_code, '식별불가') 우편번호, A.city_id 도시_ID
	FROM staff S, address A;
-- staff 테이블에서 성과 이름을 합치고 payment 테이블 pay컬럼 2005년 7월 월급 조회, 그룹은 staff
SELECT CONCAT(S.first_name, ' ', S.last_name), SUM(P.amount)
	FROM staff S, payment P
    WHERE S.staff_id = P.staff_id AND payment_date BETWEEN '2005-07-01' AND '2005-08-01'
    GROUP BY S.staff_id;
-- 영화별 출연 배우의 수
SELECT CONCAT(A.first_name, ' ' , A.last_name) 배우, 
F.title, f.release_year
FROM actor A, film F, film_actor B
WHERE A.actor_id = B.actor_id 
	AND B.film_id = F.film_id;
-- 국가가 CANADA인 고객의 이름 서브쿼리를 이용한 방법
SELECT CONCAT(first_name, ' ' , last_name) 고객, email
	FROM customer
    WHERE address_id IN 
		(SELECT address_id FROM address WHERE city_id IN 
			(SELECT city_id FROM city WHERE country_id IN
				(SELECT country_id FROM country WHERE country = "CANADA")));
-- JOIN을 이용한 방법
SELECT CONCAT(CUS.first_name, ' ' , CUS.last_name) 고객, CUS.email
	FROM customer CUS
		JOIN address ADR ON CUS.address_id = ADR.address_id
		JOIN city CIT ON ADR.city_id = CIT.city_id
		JOIN country COU ON CIT.country_id = COU.country_id
	WHERE COU.country = "CANADA";
-- 영화 등급
SELECT RATING FROM film GROUP BY rating;
-- 1. 영화에서 PG 또는 G등급 조회
SELECT rating 등급, COUNT(*) 수량 FROM film WHERE rating = 'PG' OR rating = 'G' GROUP BY rating;
-- 1. PG 또는 G등급 영화 제목
SELECT title 영화제목, rating 등급, release_year 개봉연도 FROM film WHERE rating IN ('PG', 'G');
-- 대여비 관련하여 대여비가 1~6 이하
SELECT title 영화제목, rental_rate 대여비 FROM film WHERE rental_rate BETWEEN 1 AND 6;
-- 등급별 영화의 수를 출력
SELECT rating 등급, COUNT(*) 수량 FROM film GROUP BY rating;
-- 대여비가 1~6 인 등급별 영화의 수
SELECT rating 등급, COUNT(*) 수량 FROM film WHERE rental_rate BETWEEN 1 AND 6 GROUP BY rating;
-- 등급별 영화의 수와 합계, 최대, 최소 대여비용을 조회하고 평균대여비용으로 정렬
SELECT rating 등급, 
COUNT(*) '등급별 대여수', 
SUM(rental_rate) '등급별 대여비용합계', 
MAX(rental_rate) '최대대여비용', 
MIN(rental_rate) '최소대여비용',
AVG(rental_rate) '평균대여비용'
FROM film GROUP BY rating ORDER BY '평균대여비율';
-- 등급별 영화 개수, 등급, 평균대여비용을 출력하고 평균대여비용 내림차순 정렬
SELECT rating 등급, 
COUNT(*) '등급별 대여수', 
AVG(rental_rate) '평균대여비용'
FROM film GROUP BY rating ORDER BY '평균대여비율' DESC;
-- category 테이블에서 분류가 family 인 영화
SELECT film_id, title, release_year
FROM film WHERE film_id IN
	(SELECT film_id FROM film_category WHERE category_id IN 
			(SELECT category_id FROM category WHERE name = 'Family'));
-- 영화 분류별 영화의 개수 film film_category, category 동등조인 활용 또는 left join 활용
SELECT C.name 분류, COUNT(F.title) 영화개수
FROM film F
	LEFT JOIN film_category FC ON FC.film_id = F.film_id
    LEFT JOIN category C ON C.category_id = FC.category_id
    GROUP BY C.name;
-- action 영화개수, 합계(rental_rate), 평균, 최소, 최고 집계
SELECT COUNT(title) 영화개수, SUM(rental_rate) 대여비용합계, AVG(rental_rate) 대여비용평균, MIN(rental_rate) 최소대여비용, MAX(rental_rate) 최대대여비용
FROM film WHERE film_id IN
	(SELECT film_id FROM film_category WHERE category_id IN 
			(SELECT category_id FROM category WHERE name = 'Action'));

-- 카테고리별로 가장 대여비가 높은 영화 분류
-- category, film_category, inventory, payment, rental
SELECT CAT.name category_name, SUM(IFNULL(PAY.amount, 0)) revenue
	FROM category CAT
    LEFT JOIN film_category FLM_CAT ON CAT.category_id = FLM_CAT.category_id
    LEFT JOIN film FIL ON FLM_CAT.film_id = FIL.film_id
    LEFT JOIN inventory INV ON FIL.film_id = INV.film_id
    LEFT JOIN rental REN ON INV.inventory_id = REN.inventory_id
    LEFT JOIN payment PAY ON REN.rental_id = PAY.rental_id
    GROUP BY CAT.name
    ORDER BY revenue DESC;
-- 뷰를 생성, 뷰이름은 v_cat_revenue
-- 컬럼1 : category.name  = category_name
-- 컬럼2 : sum(ifnull(pay.amount, 0) =  revenue
DROP VIEW IF EXISTS v_cat_revenue;
CREATE VIEW v_cat_revenue
	AS SELECT CAT.name category_name, SUM(IFNULL(PAY.amount, 0)) revenue
	FROM category CAT
    LEFT JOIN film_category FLM_CAT ON CAT.category_id = FLM_CAT.category_id
    LEFT JOIN film FIL ON FLM_CAT.film_id = FIL.film_id
    LEFT JOIN inventory INV ON FIL.film_id = INV.film_id
    LEFT JOIN rental REN ON INV.inventory_id = REN.inventory_id
    LEFT JOIN payment PAY ON REN.rental_id = PAY.rental_id
    GROUP BY CAT.name
    ORDER BY revenue DESC;
SELECT * FROM v_cat_revenue;