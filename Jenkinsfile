pipeline {
  environment {
    imagename = "khadydiagne/k8s_app"
    registryCredential = 'docker'
    SONAR_PROJECT_KEY = 'test_java'
    SONAR_HOST_URL = 'http://192.168.230.128:9000'
    SONAR_TOKEN = credentials('sonarqube') // Jeton d'accès SonarQube stocké dans Jenkins
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/test_sonarqube.git', branch: 'main'])
        sh 'chmod +x ./mvnw'
      }
    }

    stage('Building Image') {
      steps {
        script {
          dockerImage = docker.build(imagename, ".")
        }
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

    stage('Deploy to Minikube') {
      steps {
        script {
          
            sh 'kubectl apply -f k8s/ '
          
        }
      }
    }


    stage('Verify Deployment') {
      steps {
        script {
          // Vérifier que les ressources Kubernetes sont correctement déployées
          sh 'kubectl get all -n default'
        }
      }
    }
  }
  post {
    always {
      echo 'Pipeline terminé'
    }
  }
}
