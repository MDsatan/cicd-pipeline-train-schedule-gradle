# cicd-pipeline-train-schedule-gradle (fork for Security Automation learning)

## Why is it forked?
This is a small project made for learning purposes.
1) Using Terraform to deploy infrastructure in Azure
2) Using Jenkins to deploy Jenkins Pipeline
3) Deploying Jenkins Pipeline in Kubernetes Cluster
4) Using SonarQube to analyze this project
5) More to come...

### Some things for manual configuration
1) Docker Pipelines and SSH Agent plugins are required to be installed on the BuildNode Jenkins.
2) Add id_rsa of azureuser on the BuildNode Jenkins. (ID: id_rsa)
3) Add DockerHub credentials on the BuildNode Jenkins. (ID: docker-hub-credentials)


## Original Descrtiption Below:
This is a simple train schedule app written using nodejs. It is intended to be used as a sample application for a series of hands-on learning activities.


## Running the app

It is not necessary to run this app locally in order to complete the learning activities, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:3000](http://localhost:3000)



