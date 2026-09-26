import os
import psycopg2
from flask import Flask, request, render_template, redirect, url_for
import json
import boto3

app = Flask(__name__)

def get_db_credentials():
    secret_arn = os.environ.get("DB_SECRET_ARN")
    if secret_arn:
        # On EKS: IRSA gives this pod temporary AWS credentials,
        # which boto3 finds automatically. No keys anywhere.
        client = boto3.client("secretsmanager")
        secret = json.loads(client.get_secret_value(SecretId=secret_arn)["SecretString"])
        return secret["username"], secret["password"]
    # Local dev (docker compose): values from .env
    return os.environ["DB_USER"], os.environ["DB_PASSWORD"]


def get_db_connection():
    user, password = get_db_credentials()
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ["DB_NAME"],
        user=user,
        password=password,
        # RDS enforces TLS; local Postgres has none, so compose sets "disable"
        sslmode=os.environ.get("DB_SSLMODE", "require"),
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