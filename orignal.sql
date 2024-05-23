# 데이터 베이스를 사용함을 알리는 코드(필수 입력)
USE kdh;

# 모든 데이터 베이스를 보여줌
SHOW DATABASES;

# 자신이 사용하고 있는 데이터 베이스의 테이블 목록
SHOW TABLES;

# 각 테이블의 통계량을 보여줌
SHOW TABLE STATUS;

# 내림차순으로 고객 테이블에 대한 내용을 보여줌
DESC 고객;

# ----------------------------------------

# SQL 데이터 조작어(DML)의 SELECT문

# 기본구조
# SELCET 필드명, 필드명, ...
# FROM 테이블명
# WHERE 검색조건 AND/OR 검색조건 LIKE IN ('조건', '조건')
# GROUP BY 필드명
# HAVING 검색조건		GROUP BY로 집계한 결과를 사용하고 싶을 때
# ORDER BY 필드명 ASC/DESC
# LIMIT 시작행, 뽑을갯수

USE WORLD;
SHOW TABLES;
SELECT id, name, countrycode, district, population FROM city;

#-----------------------------------------

# 열 별칭 지정
SELECT id, name, countrycode as country_id, district, population FROM city;

# 산술식을 통한 새로운 열 지정
SELECT id, name, countrycode, district, population, population/100 as "percent pp" FROM city;

#-----------------------------------------

# where문

# District가 England 인 경우만 선택
SELECT id, name, countrycode, district, population FROM city
WHERE district = 'England';

# District가 England 이고 Population > 300000 인 경우만 선택
SELECT * FROM city
WHERE district = 'England' and Population > 300000;

# District가 England 혹은 Population > 300000 인 경우만 선택
SELECT * FROM city
WHERE district = 'England' or Population > 300000;

# 특정 구간 선택하기(BETWEEN ~ AND ~)
SELECT id, name, countrycode as country_id, district, population FROM city
WHERE population BETWEEN 700000 AND 800000;

# 특정 값만 선택하기(IN)
SELECT id, name, countrycode as country_id, district, population FROM city
WHERE name IN('Seoul', 'New York', 'Tokyo');

#-------------------------------------------------

# WHERE를 통한 조건검색(LIKE 이용)
# LIKE '데이터%' => 데이터로 시작하는 문자열(데이터 이후 글자 수 상관 없음)
# LIKE '%데이터' => 데이터로 끝나는 문자열
# LIKE '%데이터%' => 데이터가 포함된 문자열
# LIKE '데이터___' => 데이터로 시작하는 6글자 길이의 문자열
# LIKE '__한%' => 세 번째 글자가 '한'인 문자열

# District에서 앞에 'E'로 시작하는 경우만 선택
SELECT * FROM city
WHERE district LIKE 'E%';

# District에서 중간에 '-'이 들어 있는 경우만 선택
SELECT * FROM city
WHERE district LIKE '%-%';

# District에서 길이가 7자인 경우만 선택
SELECT * FROM city
WHERE district LIKE '_______';

#-----------------------------------------------

# WHERE를 통한 조건검색(NULL 이용)
# IS NULL 키워드를 이용해 특정 속성의 값이 NULL 값인 경우만 검색
# IS NOT NULL 키워드를 이용해 특정 속성의 값이 NULL 값이 아닌 경우만 검색

SELECT * FROM city WHERE district is null;
SELECT * FROM city WHERE district is not null;

#------------------------------------------------- 

# 연습문제 1(country 테이블)
# Continent는 Asia 인 나라들 중 Population이 40000000 이상인 것을 검색
SELECT * FROM country
WHERE continent = 'Asia' and population >= 40000000;

# 우리나라 (South Korea)보다 GNP가 높은 나라들을 찾으시오
SELECT * FROM country
WHERE name = 'South Korea';

SELECT * FROM country
WHERE GNP > 320749;

# CONTINEN가 AISA인 국가들의 GNP/POPULATION * 10000를 G_P라는 변수로 만들고
# CODE, NAME, G_P만 출력하되 G_P가 큰 순서대로 출력하시오.
SELECT CODE, NAME, GNP / POPULATION * 10000 AS G_P FROM country
ORDER BY G_P DESC;

# 남북한의 총 인구합은 몇 명인가? (LIKE를 이용)
SELECT sum(population) FROM country
WHERE name LIKE '%KOREA';

# Code가 KOR인 나라보다 POPULATION이 큰 나라의 개수는?
SELECT * FROM country
WHERE Code = 'KOR';

SELECT COUNT(Code) FROM country
WHERE POPULATION > 46844000;

# 연습문제 2(city 테이블)
# 대한민국(CountryCode = KOR) 중 인구가 1,000,000명 이상인 도시가 몇 개 있는가?
SELECT * FROM city
WHERE CountryCODE = 'KOR' AND Population >= 1000000;

# CountryCode 기준으로 Population을 합한 결과 중 50000000명 이상인 국가는?
SELECT  CountryCode, SUM(Population) AS Sum_Population FROM city
GROUP BY CountryCode
HAVING Sum_Population >= 50000000;

# CountryCode 기준으로 Population을 합한 결과 중 우리나라 도시 Population 합한 결과보다 큰 국가는?
SELECT  CountryCode, SUM(Population) AS Sum_Population FROM city
GROUP BY CountryCode
HAVING Sum_Population >= (SELECT SUM(Population) FROM city
							GROUP BY CountryCode
                            HAVING CountryCODE = 'KOR');

#-------------------------------------------------------------

# 내부 조인의 형식(INNER JOIN)
# SELECT <열목록>
# FROM <첫 번째 테이블>
# INNER JOIN <두 번째 테이블>
# ON <조인될 조건>
# WHERE <검색조건>;

# World DB에서 Country와 Countrylanguage 테이블을 Code 기준으로 inner join하여 Language가 English인 국가를, 총 몇 개 나라인지출력하시오
USE World;
SELECT * FROM Country;
SELECT * FROM Countrylanguage;

SELECT count(a.code) as '나라 갯수' FROM Country AS A
INNER JOIN Countrylanguage AS B
ON A.Code = B.CountryCode
WHERE B.Language = 'English';

#---------------------------------------------------------

# 집계함수를 이용한 검색
SELECT *, max(population) FROM city;

# 조사된 자료의 평균 population은 얼마인가?
SELECT *, AVG(population) FROM city;

# Population이 1000000 이상인 경우의 도시는 몇개인가?
SELECT count(name) FROM city
WHERE population >= 1000000;

SELECT count(DISTINCT name) FROM city	#DISTINCT는 중복된 항목을 제거해줍니다.
WHERE population >= 1000000;

#--------------------------------------------------------

# 연습문제 3(city 테이블)
# 한국의 도시의 개수는 몇 개인가?
SELECT * FROM CITY;
SELECT COUNT(ID) FROM CITY
WHERE COUNTRYCODE = 'KOR';

# 각 국가들 중 인구수가 가장 많은 도시를 찾고 도시 이름 기준으로 내림차순 하시오
SELECT * FROM CITY;
SELECT *, MAX(POPULATION) FROM CITY
GROUP BY COUNTRYCODE
ORDER BY NAME DESC;

# 국가 이름들의 첫 글자가 'K'로 시작하는 국가들의 평균 인구수를 출력하시오
SELECT AVG(POPULATION) FROM City
WHERE NAME LIKE 'K%';

# 각 국가들 중 도시의 인구수가 5000000명 이상인 국가들을 출력하시오
SELECT *, SUM(POPULATION) AS SUM_POPULATION FROM CITY
GROUP BY COUNTRYCODE
HAVING SUM_POPULATION >= 5000000;

#----------------------------------------------------------

# 연습문제 4(Country 테이블)
# 우리나라 (Sounth Korea)보다 GNP가 높은 나라들이 총 몇개국인가
SELECT COUNT(CODE) FROM COUNTRY
WHERE GNP > (SELECT GNP FROM COUNTRY
				WHERE NAME = 'South Korea');
                
# 국가 면적 크기로 내림차순으로 정렬하여 상위 5개의 국가를 선택하시오
SELECT * FROM COUNTRY
ORDER BY SURFACEAREA DESC
LIMIT 5;

# 한국(KOR), 미국(USA), 일본(JPN)의 평균 GNP를 계산하시오
SELECT AVG(GNP) FROM COUNTRY
WHERE CODE IN ('KOR', 'USA', 'JPN');

#------------------------------------------------------

# CREATE문
# CREATE DATABASE sampleDB;
# USE sampleDB;
# CREATE TABLE 테이블_이름 (
#	속성_이름 데이터_타입 [NOT NULL] [DEFAULT 기본_값]
#	PRIMARY KEY (속성_리스트)
#	UNIQUE (속성_리스트)
#	FOREIGN KEY (속성_리스트) REFERENCES 테이블_이름(속성_리스트)
#	(ON DELETE 옵션) (ON UPDATE 옵션)
#	CONSTRAINT 이름 CHECK(조건)
#);

# CREATE문
CREATE DATABASE study_alone;
USE study_alone;

# CREATE TABLE문 작성
CREATE TABLE 고객(
	고객아이디 VARCHAR(20) NOT NULL,
	고객이름 VARCHAR(10) NOT NULL,
    나이 INT,
    등급 VARCHAR(10) NOT NULL,
    직업 VARCHAR(20),
    적립금 INT DEFAULT 0,
    PRIMARY KEY(고객아이디)
);

SELECT * FROM 고객;

CREATE TABLE 제품(
	제품번호 CHAR(3) NOT NULL,
    제품명 VARCHAR(20),
    재고량 INT,
    단가 INT,
    제조업체 VARCHAR(20),
    PRIMARY KEY(제품번호),
    CHECK(재고량>=0 AND 재고량 <= 10000)
);

CREATE TABLE 주문(
	주문번호 CHAR(3) NOT NULL,
    주문고객 VARCHAR(20),
    주문제품 CHAR(3),
    수량 INT,
    배송지 VARCHAR(30),
    주문일자 DATE,
    PRIMARY KEY(주문번호),
    FOREIGN KEY(주문고객) REFERENCES 고객(고객아이디),
    FOREIGN KEY(주문제품) REFERENCES 제품(제품번호)
);

CREATE TABLE 배송업체(
	업체번호 CHAR(3) NOT NULL,
    업체명 VARCHAR(20),
    주소 VARCHAR(100),
    전화번호 VARCHAR(20),
    PRIMARY KEY(업체번호)
);

# 새로운 속성 추가
# ALTER TABLE 데이블_이름
#	ADD 속성_이름 데이터_타입 [NOT NULL] [DEFAULT 기본_값];

ALTER TABLE 고객 ADD 가입날짜 DATE;

# 기존 속성 삭제
#ALTER TABLE 테이블_이름 DROP COLUMN 속성_이름;

ALTER TABLE 고객 DROP COLUMN 가입날짜;

# 새로운 제약조건의 추가
# ALTER TABLE 테이블_이름 ADD CONSTRAINT 제약조건_이름 제약조건_내용;
# 고객 테이블에 20세 이상의 고객만 가입할 수 있다는 데이터 무결성 제약조건 추가
ALTER TABLE 고객 ADD CONSTRAINT CHK_AGE CHECK(나이>=20);

# 기존 제약조건의 삭제
# ALTER TABLE 테이블_이름 DROP CONSTRAINT 제약조건_이름;
# 추가한 20세 이상의 고객만 가입할 수 있다는 데이터 무결성 제약조건을 삭제
ALTER TABLE 고객 DROP CONSTRAINT CHK_AGE;

# 테이블 삭제
# DROP TABLE 테이블_이름;
DROP TABLE IF EXISTS 배송업체;

# 데이터 직접 삽입
# INSERT INTO 테이블_이름[(속성_리스트)] VALUES (속성값_리스트);
INSERT INTO 고객(고객아이디, 고객이름, 나이, 등급, 직업, 적립금)
VALUES
('APPLE', '정소화', 20, 'GOLD', '학생', 1000),
('BANANA', '김선우', 25, 'VIP', '간호사', 2500),
('CARROT', '고명석', 28, 'GOLD', '교사', 4500),
('ORANGE', '김용욱', 22, 'SILVER', '학생', 0),
('MELON', '성원용', 35, 'GOLD', '회사원', 5000),
('PEACH', '오형준', NULL, 'SILVER', '의사', 300),
('PEAR', '채광주', 31, 'SILVER', '회사원', 500);

SELECT * FROM 고객;

INSERT INTO 제품(제품번호, 제품명, 재고량, 단가, 제조업체)
VALUES
('P01', '그냥만두', 5000, 4500, '대한식품'),
('P02', '매운쫄면', 2500, 5500, '민국푸드'),
('P03', '쿵떡파이', 3600, 2600, '한빛제과'),
('P04', '맛난초콜릿', 1250, 2500, '한빛제과'),
('P05', '얼큰라면', 2200, 1200, '대한식품'),
('P06', '통통우동', 1000, 1550, '민국푸드'),
('P07', '달콤비스킷', 1650, 1500, '한빛제과');

SELECT * FROM 제품;

INSERT INTO 주문(주문번호, 주문고객, 주문제품, 수량, 배송지, 주문일자)
VALUES
('o01', 'apple', 'p03', 10, '서울시 마포구', '19/01/01'),
('o02', 'melon', 'p01', 5, '인천시 계양구', '19/01/10'),
('o03', 'banana', 'p06', 45, '경기도 부천시', '19/01/11'),
('o04', 'carrot', 'p02', 8, '부산시 금정구', '19/02/01'),
('o05', 'melon', 'p06', 36, '경기도 용인시', '19/02/20'),
('o06', 'banana', 'p01', 19, '충청북도 보은군', '19/03/15'),
('o07', 'apple', 'p03', 22, '서울시 영등포구', '19/03/15'),
('o08', 'pear', 'p02', 50, '강원도 춘천시', '19/04/10'),
('o09', 'banana', 'p04', 15, '전라남도 목포시', '19/04/11'),
('o10', 'carrot', 'p03', 20, '경ㅇ기도 안양시', '19/05/22');

SELECT * FROM 주문;

#----------------------------------------------------

# ALTER TABLE과 UPDATE, DROP을 통한 수정 및 추가
# 테이블 이름 변경 : RENAME
# 테이블 칼럼, 제약조건 추가 : ADD
# 테이블 변경 : CHANGE, MODIFY
# 테이블 제약 조건 제거 : DROP

# 테이블 이름 바꾸기 예시
# ALTER TABLE CUST RENAME TO CUSTMS;

# 열 이름 바꾸기 예시
# ALTER TABLE PROD CHANGE 본래이름 바꿀이름 INT;

# 데이터 변경 예시
# UPDATE ORDR
# SET 배송지 = '서울'
# WHERE 배송지 LIKE '서울%';

# ALTER TABLE을 이용하여 새로운 변수 생성 예시
# ALTER TABLE PROD
# ADD COLUMN 재고금액 INT NOT NULL;
# UPDATE PROD
# SET 재고금액 = 재고량 * 단가;custcust

#-------------------------------------------------

# 연습문제 5
USE KDH;
SELECT * FROM PROD;
SELECT * FROM ORDR;
SELECT * FROM CUST;

# 재고금액을 만들고 재고금액이 가장 큰 제품번호, 제품명, 재고량, 단가, 제조업체를 출력하시오.
SELECT 제품번호, 제품명, 재고량, 단가, 제조업체 FROM PROD
ORDER BY 재고금액 DESC;

# 직업별 주문한 제품의 총 수량(SUM)을 출력하시오
SELECT B.직업, SUM(A.수량) AS '총 수량'
FROM ORDR AS A
INNER JOIN CUST AS B
ON A.주문고객 = B.고객아이디
GROUP BY B.직업;

# 직업별 주문한 제품의 총 금액의 합을 출력하시오
SELECT C.직업, A.단가 * SUM(B.수량) AS '주문한 제품의 총 금액' 
FROM PROD AS A
INNER JOIN ORDR AS B
ON A.제품번호 = B.주문제품
INNER JOIN CUST AS C
ON B.주문고객 = C.고객아이디
GROUP BY C.직업;

#---------------------------------------------
USE KDH;
SELECT * FROM CUST;
SELECT * FROM PROD;
SELECT * FROM ORDR;

# LEFT JOIN

# SELECT A.*, B.*
# FROM CUST AS A
# LEFT JOIN ORDR AS B
# ON A.고객아이디 = B.주문고객;

SELECT A.*, B.*
FROM CUST AS A
LEFT JOIN ORDR AS B
ON A.고객아이디 = B.주문고객
WHERE B.주문고객 IS NULL;		# 대상자에게 특정 조건을 부여

# RIGHT JOIN

# SELECT A.*, B.*
# FROM CUST AS A
# RIGHT JOIN ORDR AS B
# ON A.고객아이디 = B.주문고객;

SELECT A.*, B.*
FROM CUST AS A
RIGHT JOIN ORDR AS B
ON A.고객아이디 = B.주문고객
WHERE A.고객아이디 IS NULL;

#-----------------------------------------

# UNION/ UNION ALL 이해하기

# UNION : 중복되는 행은 하나만 표시
# UNION ALL : 중복제거 하지 않고 모두 표시

# UNION 예시
# SELECT *
#	FROM TABLEA AS T1
#    LEFT JOIN TABLEB AS T2
#	ON T1.ID = T2.ID
# UNION
# SELECT *
#	FROM TABLEA AS T1
#    RIGHT JOIN TABLEB AS T2
#    ON T1.ID = T2.ID;

#----------------------------------------
USE KDH;
SELECT * FROM CUST;
SELECT * FROM PROD;
SELECT * FROM ORDR;

# 연습문제 6

# (고객) 직업별 인원수를 출력하시오.
SELECT 직업, COUNT(고객아이디) AS '인원수' FROM CUST
GROUP BY 직업;

# (고객) 회사원의 평균 적립금은 얼마인가
SELECT 직업, AVG(적립금) AS '평균 적립금' FROM CUST
GROUP BY 직업
HAVING 직업 = '회사원';

# (고객) 회사원의 평균 적립금과 학생의 평균 적립금을 더한 결과를 출력하시오.
SELECT 직업, AVG(적립금) AS '평균 적립금' FROM CUST
GROUP BY 직업
HAVING 직업 = '회사원' OR 직업 = '학생';

SELECT 직업, AVG(적립금) AS '평균 적립금' FROM CUST
GROUP BY 직업
HAVING 직업 IN ('회사원', '학생');