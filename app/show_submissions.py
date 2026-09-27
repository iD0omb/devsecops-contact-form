from app import get_db_connection

cur = get_db_connection().cursor()
cur.execute("SELECT id, name, email, message, created_at FROM submissions ORDER BY id")
for row in cur.fetchall():
    print(row)