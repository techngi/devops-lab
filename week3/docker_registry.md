### Build Falsk Application to run on your system locally

- Create flask applicaiton on your machine locally

```bash
sudo nano app.py
```

```bash
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from DevOps Week 3!"

app.run(host="0.0.0.0", port=5000)
```

- Install pip and flask

```bash
sudo apt install python3-pip -y
sudo apt install python3-flask -y

python3 - <<EOF					# verify the installation
import flask
print("Flask imported OK!", flask.__version__)
EOF
```

- Now run the applicaton locally on your system and verify in browser

```bash
python3 app.py
```


### Write DockerFile

```bash
FROM python:3.10-slim

WORKDIR /app
COPY . .
RUN pip install flask

EXPOSE 5000

CMD ["python", "app.py"]
```

### Run docker locally

- Install Docker

```bash
sudo apt remove docker docker-engine docker.io containerd runc # remove previously installed components
sudo apt update
sudo apt install ca-certificates curl gnupg -y # install the certificates

sudo install -m 0755 -d /etc/apt/keyrings	# add official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# add docker repository
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo systemctl enable docker
sudo systemctl start docker
sudo docker version
sudo usermod -aG docker $USER
```

- Log out and back in

### Build and run the image locally

```bash
docker build -t week3-app .
docker run -p 5000:5000 week3-app
```

### Create a Private Registry Container
- Create repo devops-week3 on dockerhub: sanaqvi573/week3-app

- Rename local docker file same as the one created on dockerhub

```bash
docker tag app.py:latest sanaqvi573/week3-app:latest
docker images
```

- Login on the docker hub

```bash
docker login
```

- Push the code to docker hub

```bash
docker push sanaqvi573/week3-app:latest
```
