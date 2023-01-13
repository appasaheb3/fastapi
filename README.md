# fastapi
### #Jenkins Installation on ubuntu
*first add the key to your system:*
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
*Then add a Jenkins apt repository entry:*
```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```
*Update your local package index, then finally install Jenkins:*
```
sudo apt-get update
  sudo apt-get install fontconfig openjdk-11-jre
  sudo apt-get install jenkins
```


### #Jenkins Pipeline
```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/appasaheb3/fastapi.git']])
            }
        }
        
        stage('Build') {
            steps {
                git branch :'main',url:'https://github.com/appasaheb3/fastapi.git'
                sh 'python3 main.py'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 -m pytest'
            }
        }
    }
}
```


### Docker Installation on Ubuntu
*https://docs.docker.com/engine/install/ubuntu/*
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
```
```
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
```echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null```

```sudo apt-get update```

```sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
```

```
# verify
sudo docker run hello-world
```


### Jenkins With Docker
*Note:Set permission if not working*
```
sudo groupadd docker
```
```
usermod -aG docker jenkins
```
```
usermod -aG root jenkins
```
```
chmod 664 /var/run/docker.sock
```
```
# still not working then check with
reboot
```


### Docker Image Build and Push on hub
*Add Ussername and Password of Docker and Give uniq ID* 
```
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/appasaheb3/fastapi.git']])
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t fastapi .'
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                    sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin' 
                    sh 'docker push appasaheb3/fastapi'
                }
            }
        }
        
        
    }
}
```
