node('node1') {
    def mvnHome
    
    stage('Cloning Source Code') {
        git branch: 'main', url: 'https://github.com/surya-projects-test/java_test.git'
        // Get the Maven tool.
        // ** NOTE: This 'M3' Maven tool is configured
        // **       in the global configuration.
        mvnHome = tool 'M3'
    }

    stage('Build Project') {
        // Run the maven build
        withEnv(["MVN_HOME=$mvnHome"]) {
            sh '"$MVN_HOME/bin/mvn" clean package -DskipTests'
        }
    }

    // Check if Docker is already installed
    def dockerInstalled = sh(script: "which docker", returnStatus: true) == 0
    
    // Console of Installing Docker in node if it's not already installed
    if (!dockerInstalled) {
        stage('Handling Docker installation error') {
            error "Docker is not installed on this machine."
        }
    }

    // Docker login
    stage('Docker Login') {
        // Defined Docker credentials in Global Manage credentials
        def dockerHubCredentials = 'docker-hub-credentials'

        // Check if the credentials exist
        if (credentials(dockerHubCredentials) != null) {
            // Docker login
            withCredentials([usernamePassword(credentialsId: dockerHubCredentials, usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
            }
        } else {
            error "Docker Hub credentials not found."
        }
    }

    // Docker build
    stage('Docker Build') {
        // Define variables
        def latestCommitId = sh(script: 'git rev-parse HEAD | cut -c1-8', returnStdout: true).trim()
        def imageTag = "test-app-${BUILD_NUMBER}-${latestCommitId}"
        def imageRepo = "dockerbalajisurya/image-repository"
        sh "docker build -t ${imageRepo}:${imageTag} ."
        sh "docker push ${imageRepo}:${imageTag}"
    }
}
