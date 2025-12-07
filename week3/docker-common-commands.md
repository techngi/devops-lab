```bash
docker stop jenkins
docker rm jenkins

docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

docker exec -it jenkins bash

docker --version
docker ps

docker images

docker logs jenkins

docker exec -u root -it jenkins bash -c "apt-get update && apt-get install -y docker-cli && docker --version"

docker exec -it jenkins which docker

docker exec -it jenkins docker ps
