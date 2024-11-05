pipeline {
  environment {
    imagename = "khadydiagne/k8s_jenkins"
    registryCredential = 'docker'
    SONAR_PROJECT_KEY = 'test_java'
    SONAR_HOST_URL = 'http://localhost:9000/'
    // Définir le jeton d'accès SonarQube depuis Jenkins
    SONAR_TOKEN = credentials('sonarqube') // Définir SONAR_TOKEN ici pour SonarQube
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/test_sonarqube.git', branch: 'main'])
        // Rendre mvnw exécutable immédiatement après le clonage
        sh 'chmod +x ./mvnw'
      }
    }

    stage('SonarQube analysis') {
      steps {
        withSonarQubeEnv('sonarqube') {
          sh './mvnw sonar:sonar -Dsonar.projectKey=$SONAR_PROJECT_KEY -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN -Dsonar.java.binaries=src'
        }
      }
    }

    stage('Building image') {
      steps {
        script {
          dockerImage = docker.build(imagename, ".")
        }
      }
    }

    stage('Check target directory') {
      steps {
        sh 'ls -R target'
      }
    }

    stage('Push Image') {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push("$BUILD_NUMBER")
            dockerImage.push('latest')
          }
        }
      }
    }

    stage('Run Docker Container') {
      steps {
        script {
          dockerImage.run("-d -p 8087:8087")
        }
      }
    }
  }
}

