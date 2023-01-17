pipeline {
    agent any
  environment {
  
  }
    stages {
        stage('create s3 bucket') {
            steps {
                container('amazon/aws-cli:2.7.29') {
                    sh 'aws s3 mb s3://cimonibucket-20221216 --region us-east-1'
                }
            }
        }
        stage('validate') {
            steps {
                container('hashicorp/terraform:latest') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform validate'
                }
            }
        }
        stage('plan') {
            steps {
                container('hashicorp/terraform:latest') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform plan -out terraform.plan -input=false'
                }
            }
        }
        stage('apply') {
            steps {
                container('hashicorp/terraform:latest') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform apply -input=false terraform.plan'
                }
            }
        }
         stage('destroy') {
            steps {
                container('hashicorp/terraform:latest') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform destroy --auto-approve'
                }
            }
        }   
         stage('delete s3 bucket') {
            steps {
                container('amazon/aws-cli:2.7.29') {
                    sh 'aws s3 rb s3://cimonibucket-20221216 --force --region us-east-1'
                }
            }
        }     
