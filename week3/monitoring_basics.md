### Add Basic Logging + Health Checks

- Update app.py

```bash
import logging
from flask import Flask, jsonify

app = Flask(__name__)

# ---------- Logging Setup ----------
logging.basicConfig(
    level=logging.INFO,  # DEBUG in dev, INFO in prod
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)
# -----------------------------------


@app.route("/")
def home():
    logger.info("Home endpoint (/) was called")
    return "Hello from DevOps Week 3!"


# Simple health check endpoint
@app.route("/health")
def health():
    logger.info("Health check endpoint (/health) was called")
    return jsonify(status="ok", app="devops-week3", version="1.0.0"), 200


if __name__ == "__main__":
    logger.info("Starting Flask app on 0.0.0.0:5000")
    app.run(host="0.0.0.0", port=5000)
```

# Add Dockerfile HealthCheck

```bash
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
```

# Create requirements.txt file

```bash
flask
```


# Verify that the applicaiton is running locally

```bash
docker build -t sanaqvi573/week3-app:latest .
docker run -d --name week3-app-logging -p 5000:5000 sanaqvi573/week3-app:latest

docker ps
```

# Wire into Jenkins

```bash
// Jenkinsfile for Week 3 – Flask app + Docker
def dockerImage

pipeline {
    agent any

    environment {
        IMAGE_NAME     = "sanaqvi573/week3-app"   // your Docker Hub repo
        DOCKERHUB_CRED = "dockerhub-creds"        // Jenkins DockerHub credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                dir('week3') {
                    script {
                        dockerImage = docker.build(
                            "${IMAGE_NAME}:${env.BUILD_NUMBER}",
                            "-f dockerfile ."
                        )
                    }
                }
            }
        }

        // NEW: Local health check using /health
        stage('Health Check (Local)') {
            steps {
                script {
                    // separate name/port so it doesn't clash with anything else
                    def containerName = "week3-app-test-${env.BUILD_NUMBER}"
                    def healthPort    = "5001"

                    try {
                        sh """
                          echo "Starting test container: ${containerName}"
                          docker run -d --name ${containerName} -p ${healthPort}:5000 ${IMAGE_NAME}:${env.BUILD_NUMBER}

                          echo "Waiting for app to start..."
                          sleep 10

                          STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${healthPort}/health || echo "000")
                          echo "Health endpoint returned: \$STATUS"

                          if [ "\$STATUS" != "200" ]; then
                            echo "Local health check FAILED"
                            echo "---- Container logs ----"
                            docker logs ${containerName} || true
                            exit 1
                          fi

                          echo "Local health check PASSED"
                        """
                    } finally {
                        sh "docker rm -f ${containerName} || true"
                    }
                }
            }
        }

        stage('Push image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CRED) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to Lab VM') {
            steps {
                sshagent(credentials: ['jenkins-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no vagrant@192.168.56.11 '
                        docker pull sanaqvi573/week3-app:latest &&
                        docker stop week3-app || true &&
                        docker rm week3-app || true &&
                        docker run -d --name week3-app -p 5000:5000 sanaqvi573/week3-app:latest
                    '
                    '''
                }
            }
        }

        // NEW: Remote health check on Lab VM after deploy
        stage('Health Check (Lab VM)') {
            steps {
                sshagent(credentials: ['jenkins-ssh-key']) {
                    sh '''
                    echo "Performing remote health check on Lab VM..."
                    STATUS=$(ssh -o StrictHostKeyChecking=no vagrant@192.168.56.11 \
                      "sleep 5 && curl -s -o /dev/null -w \\"%{http_code}\\" http://localhost:5000/health || echo 000")

                    echo "Remote /health returned: $STATUS"

                    if [ "$STATUS" != "200" ]; then
                      echo "Remote health check FAILED"
                      exit 1
                    fi

                    echo "Remote health check PASSED"
                    '''
                }
            }
        }
    }

    post {
        always {
            // just in case the local test container is left behind
            sh 'docker rm -f week3-app-test-* || true || true'
        }
    }
}
```

# Push the code to github

```bash
docker push sanaqvi573/week3-app:latest
```

# Enable communication between Jenkins Docker and the host

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
 
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sanaqvi573/week3-app"
        IMAGE_TAG    = "section5-${env.BUILD_NUMBER}"
        CONTAINER    = "week3-app-test"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh """
                  docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                """
            }
        }

        // Monitoring / health stage
        stage('Health Check') {
            steps {
                script {
                    sh """
                      # Start container in background
                      docker run -d --name ${CONTAINER} -p 5000:5000 ${DOCKER_IMAGE}:${IMAGE_TAG}

                      # Wait a bit for app to start
                      sleep 10

                      # Call /health
                      STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health || echo "000")

                      echo "Health endpoint returned HTTP status: \$STATUS"

                      if [ "\$STATUS" != "200" ]; then
                        echo "Health check FAILED"
                        echo "---- Container logs ----"
                        docker logs ${CONTAINER} || true
                        docker stop ${CONTAINER} || true
                        exit 1
                      fi

                      echo "Health check PASSED"
                      docker stop ${CONTAINER}
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_TOKEN}
                  docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                  docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                  docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
    }

    post {
        always {
            // Cleanup if anything was left running
            sh 'docker rm -f week3-app-test || true'
        }
    }
}
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sanaqvi573/week3-app"
        IMAGE_TAG    = "section5-${env.BUILD_NUMBER}"
        CONTAINER    = "week3-app-test"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh """
                  docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                """
            }
        }

        // Monitoring / health stage
        stage('Health Check') {
            steps {
                script {
                    sh """
                      # Start container in background
                      docker run -d --name ${CONTAINER} -p 5000:5000 ${DOCKER_IMAGE}:${IMAGE_TAG}

                      # Wait a bit for app to start
                      sleep 10

                      # Call /health
                      STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health || echo "000")

                      echo "Health endpoint returned HTTP status: \$STATUS"

                      if [ "\$STATUS" != "200" ]; then
                        echo "Health check FAILED"
                        echo "---- Container logs ----"
                        docker logs ${CONTAINER} || true
                        docker stop ${CONTAINER} || true
                        exit 1
                      fi

                      echo "Health check PASSED"
                      docker stop ${CONTAINER}
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_TOKEN}
                  docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                  docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                  docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
    }

    post {
        always {
            // Cleanup if anything was left running
            sh 'docker rm -f week3-app-test || true'
        }
    }
}
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sanaqvi573/week3-app"
        IMAGE_TAG    = "section5-${env.BUILD_NUMBER}"
        CONTAINER    = "week3-app-test"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh """
                  docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                """
            }
        }

        // Monitoring / health stage
        stage('Health Check') {
            steps {
                script {
                    sh """
                      # Start container in background
                      docker run -d --name ${CONTAINER} -p 5000:5000 ${DOCKER_IMAGE}:${IMAGE_TAG}

                      # Wait a bit for app to start
                      sleep 10

                      # Call /health
                      STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health || echo "000")

                      echo "Health endpoint returned HTTP status: \$STATUS"

                      if [ "\$STATUS" != "200" ]; then
                        echo "Health check FAILED"
                        echo "---- Container logs ----"
                        docker logs ${CONTAINER} || true
                        docker stop ${CONTAINER} || true
                        exit 1
                      fi

                      echo "Health check PASSED"
                      docker stop ${CONTAINER}
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_TOKEN}
                  docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                  docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                  docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
    }

    post {
        always {
            // Cleanup if anything was left running
            sh 'docker rm -f week3-app-test || true'
        }
    }
}
 jenkins/jenkins:lts
```

# Commit and push the change to Github then re-run Jenkins pipeline


