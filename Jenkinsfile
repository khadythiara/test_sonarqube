pipeline {
  environment {
    imagename = "khadydiagne/k8s_jenkins"
    registryCredential = 'docker'
    dockerImage = ''

 // Définir le nom du projet Sonar et les propriétés SonarQube
        SONAR_PROJECT_KEY = 'test_java'
        SONAR_HOST_URL = 'http://localhost:9000/'
        SONAR_TOKEN = credentials('sonarqube') // Jeton d'accès SonarQube stocké dans Jenkins
    
    
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/test_sonarqube.git', branch: 'main'])

      }
    }
    stage('Building image') {
      steps{
        script {
          sh 'chmod +x ./mvnw'
          dockerImage = docker.build(imagename, ".")
        }
      }
    }
    stage('Check target directory') {
    steps {
        sh 'ls -R target'
    }
}

stage('SonarQube analysis') {
    steps {
        withSonarQubeEnv('sonarqube') {
            sh './mvnw sonar:sonar -Dsonar.projectKey=test_java -Dsonar.java.binaries=target/sonar'
        }
    }
}
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
 
     stage('Run Docker Container') {
          steps {
              script {
                    // Exécution du conteneur Docker
                    dockerImage.run("-d -p 8086:8086")
                }
            }
        }
  }
}
