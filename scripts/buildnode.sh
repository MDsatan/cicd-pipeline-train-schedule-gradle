wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt -y update
sudo apt -y upgrade
sudo apt install openjdk-11-jdk -y
sudo apt -y install jenkins
sudo apt -y install azure-cli
sudo ufw allow 8080
# I wanted to install Docker Pipelines but this cli thing without a password it a little bit of a pain.
curl -La http://localhost:8080/jnlpJars/jenkins-cli.jar --output jenkins-cli.jar
jenkinspass=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
java -jar jenkins-cli.jar -s http://localhost:8080 -webSocket -auth admin:$jenkinspass install-plugin sonar:2.14 docker-workflow:1.29 ssh-agent:295.v9ca_a_1c7cc3a_a_
java -jar jenkins-cli.jar -s http://localhost:8080 -webSocket -auth admin:$jenkinspass create-job test < /tmp/jenkinsjob.xml
java -jar jenkins-cli.jar -s http://localhost:8080 -webSocket -auth admin:$jenkinspass restart


 #groups for Docker access
      groupadd docker
      gpasswd -a azureuser docker
      gpasswd -a jenkins docker

#Need to restart Jenkins to make it work with docker after it's been installed.
sudo service jenkins restart


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
    systemctl start docker
    systemctl enable docker

    #SonarQube
    sysctl -w vm.max_map_count=524288
    sysctl -w fs.file-max=131072
    ulimit -n 131072
    ulimit -u 8192
    jenkins=$(id -u jenkins)
    usermod -aG sudo jenkins

    #Containers in use
    docker pull sonarqube:latest
    docker pull bridgecrew/checkov
    docker pull owasp/zap2docker-stable

    #Configure Containers
    sudo mkdir -p /opt/sonarqube
    sudo chown -R jenkins:jenkins "/opt/sonarqube"
    docker run -d -p 9000:9000 --user $jenkins --name sonarqube  sonarqube:latest
    


wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt -y update && sudo apt install -y terraform gradle npm
sudo rm /bin/gradle
sudo ln -s /usr/share/gradle/bin/gradle /bin/gradle
