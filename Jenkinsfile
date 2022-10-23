@Library('slack') _


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
          } 
          stage('Vulnerability Scan - Docker'){
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
          }   
          stage('sonar-qube'){
              steps {
                 withSonarQubeEnv('SonarQube') {
                  sh  "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric -Dsonar.host.url=http://ec2-52-90-156-55.compute-1.amazonaws.com:9000 -Dsonar.login=sqp_8b5387236d59bb9d5ab2d5d3f2a58741695960e1"
                 }
                 timeout(time: 3, unit: 'MINUTES') {
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
                  sh 'sudo usermod -aG docker $USER'
                  sh ' sudo docker build -t adinagesh/numeric-app:""$GIT_COMMIT"" .'
                  sh ' docker push adinagesh/numeric-app:""$GIT_COMMIT""'
                  }
              }
          } 
          stage('kubernetes Deployment - Dev'){
              steps {
                  withKubeConfig([credentialsId: 'kubeconfig']){
                  sh "sed -i 's#replace#adinagesh/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                  sh "kubectl apply -f k8s_deployment_service.yaml" //newcode
                  }
              }

          } 
          stage ('promote to prod') {
            steps{
               timeout(time: 2, unit: 'DAYS') {
                  input 'do you want to approve build to production'
               }
            }
          }
          stage ('k8s cis bench mark'){
            steps{
              script {
                parallel(
                  "master": {
                    sh "bash cis-master.sh"
                  },
                  "etcd":{
                    sh "bash cis-etcd.sh"
                  },
                  "kubelet":{
                    sh "bash cis-kubelet.sh"
                  }
                )
              }
            }
          }
          stage ('k8s prod deployment') {
            steps {
              parallel(
                "Deployment": {
                  withKubeConfig([credentialsId: 'kubeconfig']){
                  sh "sed -i 's#replace#adinagesh/numeric-app:${GIT_COMMIT}#g' k8s_prod_deployment_service.yaml"
                  sh "kubectl -n prod  apply -f k8s_prod_deployment_service.yaml" //newcode
                  }
                },
                "Rollout Status": {
                  withKubeConfig([credentialsId: 'kubeconfig']){
                    sh "bash k8s-prod-deployment-rollout-status.sh"
                   }
                }
              )
            }
          }
  } 

  post {
    always { 
         // echo 'I will always say Hello again!'
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
          sendnotification currentBuild.result
         }
   }
  //success {}
  //failure {}
}


