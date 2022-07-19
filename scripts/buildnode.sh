wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt -y update
sudo apt -y upgrade
sudo apt install openjdk-11-jdk -y
sudo apt -y install jenkins
sudo ufw allow 8080

 #groups for Docker access
      groupadd docker
      gpasswd -a azureuser docker


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
    systemctl start docker
    systemctl enable docker

    #SonarQube
    jenkins=$(id -u jenkins)
    docker pull sonarsource/sonar-scanner-cli
    sudo mkdir -p /opt/sonarqube
    sudo chown -R jenkins:jenkins "/opt/sonarqube"


wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt -y update && sudo apt install -y terraform gradle
sudo rm /bin/gradle
sudo ln -s /usr/share/gradle/bin/gradle /bin/gradle