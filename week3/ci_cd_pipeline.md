### Install Jenkins
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install fontconfig openjdk-17-jre -y
java -version

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

- Now open Jenkins in Browser: http://192.168.56.10

Get the admin password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install Suggested Plugins


Alternatively, Use Jenkins Docker

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

- Get the admin password
```bash
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

- RUN Docker inside Jenkins container
```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

Then install docker-cli inside container:
```bash
docker exec -it jenkins bash
apt update
apt install docker.io -y
exit
```

Now Install Additional Plugins
Go to:
```bash
Manage Jenkins → Plugins → Available Plugins
```

- Git plugin
- Docker Pipeline
- Docker
- Docker Commons
- Docker API
- Pipeline Utility Steps
- SSH Agent

- Now add required credentials
* GitHub Credentials

Kind: Username & Password # this worked for deployment
OR
Kind: Secret Text (GitHub PAT)

** Docker Hub Credentials

Kind: Username & Password
Username: your-dockerhub-username
Password: your token/password


*** SSH Key for deployment to EC2 / VM

Deploy via SSH:
Kind: SSH Username with private key
Username → ubuntu
Private Key → paste id_rsa or .pem

Enter the container as root (UID 0)

```bash
docker exec -u 0 -it jenkins bash

apt-get update
apt-get install -y docker.io

docker ps
```

# If the below command fails due to insufficient permissions
```bash
docker exec -it jenkins docker ps
```

Verify
```bash
docker inspect jenkins | grep docker.sock
```

Enter container as root
```bash
docker exec -u 0 -it jenkins bash

groupadd -f docker

usermod -aG docker jenkins

chown root:docker /var/run/docker.sock

chmod 666 /var/run/docker.sock

exit

docker restart jenkins
```

then try again
```bash
docker exec -it jenkins docker ps
```


# Add a Jenkinsfile to your Week 3 repo
```bash
pipeline {
    agent any

    environment {
        IMAGE_NAME      = "sanaqvi573/week3-app"   // change if your DockerHub repo is different
        DOCKERHUB_CRED  = "dockerhub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
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

        // Optional: simple deploy via SSH using your vagrant-ssh key
        stage('Deploy (SSH)') {
            when {
                expression { return false } // set to true / remove this when you’re ready to actually deploy
            }
            steps {
                sshagent(credentials: ['vagrant-ssh']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no vagrant@<TARGET_IP> '
                        docker pull ${IMAGE_NAME}:latest &&
                        docker rm -f week3-app || true &&
                        docker run -d --name week3-app -p 5000:5000 ${IMAGE_NAME}:latest
                    '
                    '''
                }
            }
        }
    }
}
```

- Commit the changes and push to github
```bash
git add Jenkinsfile
git commit -m "Add Jenkins pipeline"
git push
```

# Run the pipeline in Jenkins
```bash
Pipeline
Definition:  Pipeline script from SCM
SCM: Git
Repository URL:
https://github.com/yourusername/devops-lab.git
Github Creds:
github-creds
Branch Specifier:
*/main
Script Path:
week3/Jenkinsfile
```

# Edit Jenkins file and update deploy stage
```bash
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
```

- Update your git and push to github
``````bash
cd ~/devops-lab
git add week3/Jenkinsfile
git commit -m "Add deploy stage to lab VM"
git push origin master
```

# Install docker on tartget VM

```bash
ssh -i /home/vagrant/.ssh/jenkins-key vagrant@192.168.56.11

# Become root
sudo su -

# Install Docker
apt-get update
apt-get install -y docker.io

# Enable & start the service
systemctl enable --now docker

usermod -aG docker vagrant
exit   # leave root back to vagrant
exit   # logout
```

- On DockerHub Week3 repository had to be set to public



