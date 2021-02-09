pipeline {

  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            job: ${env.JOB_NAME}
            job_id: ${env.BUILD_NUMBER}
        spec:
          nodeSelector:
            role: worker
          containers:
          - name: ecs-pipeline
            image: 165562107270.dkr.ecr.eu-west-2.amazonaws.com/ecs-pipeline
            imagePullPolicy: Always
            command:
            - cat
            tty: true
        """
    }
  }

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(daysToKeepStr: '180'))
  }

  stages {
    stage('Init') {
      steps {
        script {
          timestamps {
            validateDeclarativePipeline("${env.WORKSPACE}/Jenkinsfile")
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        container('ecs-pipeline') {
          script {
            timestamps {
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: env.CredentialsId]]) {
                sh "/ecs-deploy-3.6.0/ecs-deploy --region eu-west-2 --timeout 600 --max-definitions 1 --cluster ${env.Cluster} --service-name ${env.Service} --image ${env.Image}"
              }
            }
          }
        }
      }
    }
  }
}
