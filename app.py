"""Simple Flask API that checks PostgreSQL connectivity."""

import os
from flask import Flask, jsonify
import psycopg2


app = Flask(__name__)


def get_db_connection():
    """
    Create and return a PostgreSQL database connection.
    """
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        database=os.getenv("DB_NAME", "appdb"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
        port=os.getenv("DB_PORT", "5432"),
    )


@app.route("/health")
def health_check():
    """
    Health check endpoint that verifies DB connection.
    """
    conn = None
    cur = None

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("SELECT version();")
        db_version = cur.fetchone()

        return jsonify(
            {
                "status": "Conexión exitosa",
                "db_version": db_version[0],
            }
        )

    except psycopg2.Error as db_error:
        return jsonify({"status": "Error de base de datos", "error": str(db_error)})

    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
