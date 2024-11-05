<<<<<<< HEAD
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
=======
pipeline {
    environment {
        imagename = "khadydiagne/sonar_jenkins"
        registryCredential = 'simple-java-project'
        dockerImage = ''

        // Propriétés SonarQube
        SONAR_PROJECT_KEY = 'test_java'
        SONAR_HOST_URL = 'http://localhost:9000/'
        SONAR_TOKEN = credentials('sonarqube') // Jeton SonarQube
        WEBHOOK_URL = 'https://chat.googleapis.com/v1/spaces/AAAAF-fYuRc/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=YquNatic_vtgLs662cM1OUCjqcwb_gZ7EIxBcWLRbB0' // URL du webhook
    }
    
    agent any

    stages {
        stage('Cloning Git') {
            steps {
                git([url: 'https://github.com/khadythiara/test_sonarqube.git', branch: 'main'])
            }
        }

        stage('Building image') {
            steps {
                script {
                    sh 'chmod +x ./mvnw'
                    dockerImage = docker.build(imagename, ".")
                }
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
                    dockerImage.run("-d -p 8086:8086")
                }
            }
        }
stage('Remove Unused docker image') {
      steps{
        sh "docker rmi -f $imagename:$BUILD_NUMBER"
         sh "docker rmi -f $imagename:latest"

      }
    }
        stage('Send Webhook Notification') {
            steps {
                script {
                    def response = httpRequest(
                        httpMode: 'POST',
                        url: WEBHOOK_URL,
                        contentType: 'APPLICATION_JSON',
                        requestBody: '{"text": "Build test_sonar_jenkins finished successfully!"}',
                        validResponseCodes: '100:499'
                    )
                    echo "Response: ${response}"
                }
            }
        }
    }

    post {
        success {
            emailext(
                to: 'khady.diagne@baamtu.com',
                subject: "SonarQube Analysis Succeeded: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a réussi pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les résultats ici : ${SONAR_HOST_URL}dashboard?id=${SONAR_PROJECT_KEY}</p>"""
            )
        }

        failure {
            emailext(
                to: 'khady.diagne@baamtu.com',
                subject: "SonarQube Analysis Failed: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a échoué pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les détails dans la console de Jenkins.</p>"""
            )
        }
    }
}
>>>>>>> 85aea87c000c5000aa8b679922173e5765f7f120
