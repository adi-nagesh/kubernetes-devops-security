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
      stage('sonarqube-sa') {
            steps {
                withSonarQubeEnv('SonarQube') {
                  sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric1 -Dsonar.host.url=http://devtyss.eastus.cloudapp.azure.com:9000 -Dsonar.login=sqp_1e8c8b7ae4c8d8b76b668653e3127c7ec98a5606"
                }
                timeout(time: 2, unit: 'MINUTES') {
                  script {
                    waitForQualityGate abortPipeline: true
                  }
                }
            }
            
      }
      stage('Docker Build and push') {
        steps {
          withDockerRegistry([credentialsId:"dockerhub", url: ""]){
            sh 'printenv'
            sh 'docker build -t adinagesh/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push adinagesh/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
      stage('kubernetes Deployment - Dev'){
        steps {
           withKubeConfig([credentialsId: 'kubeconfig']){
            sh "sed -i 's#replace#adinagesh/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
            sh "kubectl apply -f k8s_deployment_service.yaml"
           }
        }

      }
    }
}