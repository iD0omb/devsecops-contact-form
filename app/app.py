import os
import psycopg2
from flask import Flask, request, render_template, redirect, url_for

app = Flask(__name__)

def get_db_connection():
    # Credentials come from environment variables.
    # Local dev: set via docker-compose / shell. In EKS: from Secrets Manager.
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    )

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        conn = get_db_connection()
        with conn, conn.cursor() as cur:
            # Parameterized query (%s) — prevents SQL injection.
            cur.execute(
                "INSERT INTO submissions (name, email, message) VALUES (%s, %s, %s)",
                (request.form["name"], request.form["email"], request.form["message"]),
            )
        conn.close()
        return redirect(url_for("index"))
    return render_template("form.html")

@app.route("/health")            # Kubernetes liveness/readiness probe
def health():
    return {"status": "ok"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)