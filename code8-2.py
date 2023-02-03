import pymysql
con, cur = None, None
data1, data2, data3, data4 = "", "", "", ""
row = None

conn = pymysql.connect(host='127.0.0.1', user='root', password='0000', db='soloDB',charset='utf8')
cur = conn.cursor()

cur.execute("SELECT * FROM userTable")

print("   사용자ID      사용자이름                  이메일          출생연도")
print("================================================================")

while (True) :
    row = cur.fetchone()
    if row == None :
        break
    data1 = row[0]
    data2 = row[1]
    data3 = row[2]
    data4 = row[3]
    print("%10s%10s%30s%10s" %(data1, data2, data3, data4))

conn.close()