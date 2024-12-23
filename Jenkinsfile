pipeline {
  environment {
    imagename = "khadydiagne/k8s_app"
    registryCredential = 'docker'
    SONAR_PROJECT_KEY = 'test_java'
    SONAR_HOST_URL = 'http://192.168.230.128:9000'
    SONAR_TOKEN = credentials('sonarqube') // Jeton d'accès SonarQube stocké dans Jenkins
    KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Chemin vers le fichier kubeconfig dans Jenkins
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
          // Exécuter la commande kubectl pour déployer
          sh 'kubectl apply -f k8s/ --validate=false'
        }
      }
    }

    stage('Scale Deployment') {
      steps {
        script {
          // Mise à l'échelle des réplicas à 5
          sh 'kubectl scale deployment k8s-app-deployment --replicas=3'
          // Vérification de la mise à l'échelle
          sh 'kubectl get pods -o wide'
        }
      }
    }

    stage('Monitor Scaling') {
      steps {
        script {
          // Affichage des métriques de ressources
          sh 'kubectl top pods'
          
          // Optionnel : vérifier l'état de la charge sur les nœuds
          sh 'kubectl top nodes'
        }
      }
    }

    stage('Verify Deployment') {
      steps {
        script {
          // Vérifier que les ressources Kubernetes sont correctement déployées
          sh 'kubectl get all -n default'
          sh 'kubectl get pv'
          sh 'kubectl get pvc'
          sh 'kubectl get hpa'
          sh 'kubectl get vpa'
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
