pipeline {
    environment {
        imagename = "khadydiagne/sonar_jenkins"
        registryCredential = 'simple-java-project'
        dockerImage = ''
        
        // Propriétés SonarQube
        SONAR_PROJECT_KEY = 'test_java'
        SONAR_HOST_URL = 'http://localhost:9000/'
        SONAR_TOKEN = credentials('sonarqube')
        WEBHOOK_URL = 'https://chat.googleapis.com/v1/spaces/AAAAF-fYuRc/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=YquNatic_vtgLs662cM1OUCjqcwb_gZ7EIxBcWLRbB0'
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
    }

    // Envoyer une notification au début du build
    post {
        always {
            script {
                def response = httpRequest(
                    httpMode: 'POST',
                    url: WEBHOOK_URL,
                    contentType: 'APPLICATION_JSON',
                    requestBody: '{"status": "Build started for ${env.JOB_NAME} Build #${env.BUILD_NUMBER}"}',
                    validResponseCodes: '100:499'
                )
                echo "Response: ${response}"
            }
        }

        // Envoyer une notification à la fin du build en cas de succès
        success {
            script {
                def response = httpRequest(
                    httpMode: 'POST',
                    url: WEBHOOK_URL,
                    contentType: 'APPLICATION_JSON',
                    requestBody: '{"status": "Build finished successfully for ${env.JOB_NAME} Build #${env.BUILD_NUMBER}"}',
                    validResponseCodes: '100:499'
                )
                echo "Response: ${response}"
            }

            emailext(
                to: 'khady.diagne@baamtu.com',
                subject: "SonarQube Analysis Succeeded: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a réussi pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les résultats ici : ${SONAR_HOST_URL}dashboard?id=${SONAR_PROJECT_KEY}</p>"""
            )
        }

        // Envoyer une notification à la fin du build en cas d'échec
        failure {
            script {
                def response = httpRequest(
                    httpMode: 'POST',
                    url: WEBHOOK_URL,
                    contentType: 'APPLICATION_JSON',
                    requestBody: '{"text": "Build failed for ${env.JOB_NAME} Build #${env.BUILD_NUMBER}"}',
                    validResponseCodes: '100:499'
                )
                echo "Response: ${response}"
            }

            emailext(
                to: 'khady.diagne@baamtu.com',
                subject: "SonarQube Analysis Failed: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a échoué pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les détails dans la console de Jenkins.</p>"""
            )
        }
    }
}
