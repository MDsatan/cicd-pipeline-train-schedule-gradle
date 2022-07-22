node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("mdsatan/cicd-pipeline-demo")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image. */
        app.inside {
            sh 'echo "Its alive"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
    stage('Kubernetes Deployment') {
        steps{
            sshagent(credentials:['id_rsa']){
                sh 'ssh  -o StrictHostKeyChecking=no  azureuser@masternode sudo kubectl get service'
    }

}
