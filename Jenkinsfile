pipeline {
  environment {
    imagename = "khadydiagne/sonar_jenkins"
    registryCredential = 'simple-java-project'
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
stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    // Lancer l'analyse SonarQube avec la spécification des fichiers compilés
                    sh './mvnw sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.java.binaries=target/classes'
                }
            }
        }
        stage('Quality Gate') {
            steps {
                // Attendre que l'analyse SonarQube soit terminée
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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
                    dockerImage.run("-d -p 8086:80")
                }
            }
        }
  }
}
