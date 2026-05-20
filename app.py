from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# Función para conectar a la base de datos PostgreSQL local
def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        database=os.getenv("DB_NAME", "appdb"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
        port=os.getenv("DB_PORT", "5432")
    )
    return conn

@app.route('/health')
def index():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Ejecutar una consulta de ejemplo (debes tener la tabla creada)
        cur.execute('SELECT version();')
        db_version = cur.fetchone()
        
        cur.close()
        conn.close()
        
        return jsonify({"status": "Conexión exitosa", "db_version": db_version[0]})
    except Exception as e:
        return jsonify({"status": "Error", "error": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)