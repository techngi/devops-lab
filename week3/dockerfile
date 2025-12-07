FROM python:3.10-slim

WORKDIR /app

# Install deps first (cached)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Then copy app code
COPY . .

# Optional: curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["python", "app.py"]
