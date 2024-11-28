from flask import Flask, jsonify
from flask_cors import CORS
import psycopg2

app = Flask(__name__)
CORS(app)

# Подключение к базе данных PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        dbname='epg_stats_db', 
        user='lemonlens', 
        password='strongpassword', 
        host='localhost', 
        port='5432'
    )
    return conn

@app.route('/get_epg_stats', methods=['GET'])
def get_epg_stats():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM get_epg_stats();")  # вызов вашей функции в PostgreSQL
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(rows)

if __name__ == '__main__':
    app.run(debug=True)
