import pymysql

conn = pymysql.connect(host='127.0.0.1', user='root', password='0000', db='soloDB',charset='utf8')
cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS userTable")
cur.execute("CREATE TABLE userTable (id VARCHAR(15), userName CHAR(15), email CHAR(20), birthYear YEAR)")
cur.execute("INSERT INTO userTable VALUES ('hong', '홍지윤', 'hong@naver.com', '1996')")
cur.execute("INSERT INTO userTable VALUES ('kim', '김태연', 'kim@naver.com', '2011')")
cur.execute("INSERT INTO userTable VALUES ('star', '별사랑', 'star@naver.com', '1990')")
cur.execute("INSERT INTO userTable VALUES ('yang', '양지은', 'yang@naver.com', '1993')")
conn.commit()
conn.close()