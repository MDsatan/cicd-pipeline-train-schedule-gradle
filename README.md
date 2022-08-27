# cicd-pipeline-train-schedule-gradle (fork for Security Automation learning)

## Why is it forked?
This is a small project made for learning purposes.
1) Using Terraform to deploy infrastructure in Azure
2) Using Jenkins to deploy Jenkins Pipeline
3) Deploying Jenkins Pipeline in Kubernetes Cluster
4) Using SonarQube to analyze this project
5) Using Checkov to analyze this project
6) Using OWASP ZAP to analyze running Application
~~7) More to come...~~
~~8) Plan to Scan docker image with Trivy/Hadolint/Clair/Anchore~~
~~9) SAST Scanner on GitHub project node~~

### Some things for manual configuration:
#### Credentials:
1) Docker Pipelines and SSH Agent plugins are required to be installed on the BuildNode Jenkins.
2) Add id_rsa of azureuser on the BuildNode Jenkins. (ID: id_rsa)
3) Add DockerHub credentials on the BuildNode Jenkins. (ID: docker-hub-credentials)
4) Add SonarQube credentials on the BuildNode Jenkins. (ID: token)
5) Add Azure Managed Credentials on the BuildNode Jenkins. (ID: azure-credentials)
#### Jenkins Plugins:
1) Docker Pipeline, 
2) SSH Agent, 
3) SonarQube Scanner, 
4) Azure Credentials plugins.




## Original Descrtiption Below:
This is a simple train schedule app written using nodejs. It is intended to be used as a sample application for a series of hands-on learning activities.


## Running the app

It is not necessary to run this app locally in order to complete the learning activities, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:3000](http://localhost:3000)


