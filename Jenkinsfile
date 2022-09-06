pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' 
            }
        }
      stage('unit tests - JUnit and Jacoco') {
            steps {
              sh "mvn test"
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
      }
      stage('Docker Build and push') {
        steps {
          sh 'printenv'
          sh 'docker build -t adinagesh/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push adinagesh/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
}