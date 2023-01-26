pipeline {
    agent any
    environment {
        // S3_BUCKET_NAME = '<bucket-name>'
        // TF_VAR_AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        // TF_VAR_AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')        
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
                    args '--entrypoint='
                }
            }
            steps {
                /* withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                    sh 'aws s3 mb s3://$S3_BUCKET_NAME --region us-east-1'
                } */
                sh 'aws s3 mb s3://$S3_BUCKET_NAME --region us-east-1'
                
            }
        }
        stage('replace S3_BUCKET_NAME in provider.tf ') {
            steps {
                sh """#!/bin/bash
                   cat providers.tf | grep S3_BUCKET_NAME
                   sed -i 's|S3_BUCKET_NAME: .*|version: "${S3_BUCKET_NAME}"|' providers.tf
                   cat providers.tf | grep S3_BUCKET_NAME
                   """
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
                    args '--entrypoint='
                }
            }
            steps {
                    /*withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform validate'
                 }*/
                    sh 'terraform init -input=false -backend-config="access_key=$AWS_ACCESS_KEY_ID" -backend-config="secret_key=$AWS_SECRET_ACCESS_KEY"'
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
                    args '--entrypoint='
                }
            }
            steps {
                   /* withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform plan -out terraform.plan -input=false'
                    archiveArtifacts artifacts: 'terraform.plan', fingerprint: true 
                    }*/
                    sh 'terraform init -input=false -backend-config="access_key=$AWS_ACCESS_KEY_ID" -backend-config="secret_key=$AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform plan -out terraform.plan -input=false'
                    archiveArtifacts artifacts: 'terraform.plan', fingerprint: true                 
            }
        }        
        stage('apply') {
             when {
                branch 'main'
            }
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                    args '--entrypoint='
                }
            }
            steps {
                /*withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        input 'Deploy to Production'
                          sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                          sh 'terraform apply -input=false terraform.plan'
                    }
                }*/
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        input 'Deploy to Production'
                          sh 'terraform init -input=false -backend-config="access_key=$AWS_ACCESS_KEY_ID" -backend-config="secret_key=$AWS_SECRET_ACCESS_KEY"'
                          sh 'terraform apply -input=false terraform.plan'
                    }                
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
                    args '--entrypoint='
                }
            }
            steps {
               /* withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                input 'Destroy!!!'
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform destroy --auto-approve'
                }*/
                    input 'Destroy!!!'
                    sh 'terraform init -input=false -backend-config="access_key=$AWS_ACCESS_KEY_ID" -backend-config="secret_key=$AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform destroy --auto-approve'                
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
                    args '--entrypoint='
                }
            }
            steps {
               /* withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                input 'Delete S3 Bucket!!!'
                    sh 'aws s3 rb s3://$S3_BUCKET_NAME --force --region us-east-1'
                }*/
                input 'Delete S3 Bucket!!!'
                sh 'aws s3 rb s3://$S3_BUCKET_NAME --force --region us-east-1'                
            }
        }              
    }
}     
        
