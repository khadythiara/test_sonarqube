pipeline {
  environment {
    imagename = "khadydiagne/k8s_jenkins"
    registryCredential = 'docker'
    SONAR_PROJECT_KEY = 'test_java'
    SONAR_HOST_URL = 'http://192.168.230.128:9000'
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/test_sonarqube.git', branch: 'main'])
        // Vérifiez la présence de `mvnw` et lui donner les permissions d'exécution
        sh 'ls -l' // Lister les fichiers pour vérifier si `mvnw` est présent
        sh 'chmod +x ./mvnw'
      }
    }

    stage('SonarQube analysis') {
      steps {
        withSonarQubeEnv('sonarqube') {
          // Exécutez `mvnw` pour SonarQube
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
  environment {
    SONAR_TOKEN = credentials('sonarqube') // Jeton d'accès SonarQube
  }
}
