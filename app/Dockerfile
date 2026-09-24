FROM python:3.12-slim

WORKDIR /app

# Copy requirements FIRST, install, then copy code.
# Docker caches each layer, code changes don't trigger a reinstall.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Create an unprivileged user and switch to it.
# Everything after this line runs as appuser, not root.
RUN useradd --create-home appuser
USER appuser

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]