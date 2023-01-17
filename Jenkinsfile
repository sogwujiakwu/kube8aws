pipeline {
    agent any
    environment {
             TF_VAR_AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
             TF_VAR_AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
     }
    stages {
        stage('create s3 bucket') {
            agent {
                docker {
                    image 'amazon/aws-cli:2.7.29'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                    sh 'aws s3 mb s3://cimonibucket-20221216 --region us-east-1'
            }
        }
        stage('validate') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform validate'
            }
        }        
        stage('plan') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform plan -out terraform.plan -input=false'
            }
        }        
        stage('apply') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                input 'Deploy to Production'
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform apply -input=false terraform.plan'
            }
        }   
 
        stage('destroy') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                input 'Destroy!!!'
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform apply -input=false terraform.plan'
            }
        }           
          stage('delete s3 bucket') {
            agent {
                docker {
                    image 'amazon/aws-cli:2.7.29'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                input 'Delete S3 Bucket!!!'
                    sh 'aws s3 rb s3://cimonibucket-20221216 --force --region us-east-1'
            }
        }              
    }
}     
        
