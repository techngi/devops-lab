import logging
from flask import Flask, jsonify

app = Flask(__name__)

# ---------- Basic Logging Setup ----------
logging.basicConfig(
    level=logging.INFO,  # change to DEBUG if you want more detail
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)
# ----------------------------------------


@app.route("/")
def home():
    logger.info("Home endpoint (/) was called")
    return "Hello from DevOps Week 3!"


# Health check endpoint
@app.route("/health")
def health():
    logger.info("Health endpoint (/health) was called")
    return jsonify(status="ok", app="devops-week3", version="1.0.0"), 200


if __name__ == "__main__":
    logger.info("Starting Flask app on 0.0.0.0:5000")
    app.run(host="0.0.0.0", port=5000)
