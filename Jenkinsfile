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
     /*  stage('sonarqube-sa') {
            steps {
                withSonarQubeEnv('SonarQube') {
                  sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric1 -Dsonar.host.url=http://devtyss.eastus.cloudapp.azure.com:9000"
                }
                timeout(time: 2, unit: 'MINUTES') {
                  script {
                    waitForQualityGate abortPipeline: true
                  }
                }
            }  
            
      } */
    /*   stage('Vulnerability Scan - Docker'){
        steps {
           parallel(
            "dependency scan":{
               //sh "mvn dependency-check:check"
                sh "mvn -v"
            },
            "Trivy Scan":{
              sh "bash trivy-docker-image-scan.sh"
            }
          )
        }
      }  */
       stage('Docker Build and push') {
        steps {
          withDockerRegistry([credentialsId:"dockerhub"]){
            sh 'printenv'
            sh 'sudo usermod -aG docker $USER'
            sh ' sudo docker build -t adinagesh/numeric-app:""$GIT_COMMIT"" .'
            sh ' docker push adinagesh/numeric-app:""$GIT_COMMIT""'
          }
        }
      } 
     /*  stage('kubernetes Deployment - Dev'){
        steps {
           withKubeConfig([credentialsId: 'kubeconfig']){
            sh "sed -i 's#replace#adinagesh/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
            sh "kubectl apply -f k8s_deployment_service.yaml" //newcode
           }
        }

      }
    } */  
  }
}