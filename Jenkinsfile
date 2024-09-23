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
                    dockerImage.run("-d -p 8086:8086")
                }
            }
        }
    }
    post {
        success {
            // Envoie d'un email en cas de succès
            emailext(
                subject: "SonarQube Analysis Succeeded: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a réussi pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les résultats ici : ${SONAR_HOST_URL}dashboard?id=${SONAR_PROJECT_KEY}</p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']]
            )
        }
        failure {
            // Envoie d'un email en cas d'échec
            emailext(
                subject: "SonarQube Analysis Failed: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """<p>La tâche SonarQube a échoué pour le projet ${SONAR_PROJECT_KEY}.</p>
                         <p>Voir les détails dans la console de Jenkins.</p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']]
            )
        }
    }
}
