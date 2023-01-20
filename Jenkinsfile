pipeline {
    agent any
    environment {
        S3_BUCKET_NAME = 'tfstate-bucket-20230119'
        REGION = getRegionName(env.BRANCH_NAME)
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
                withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                    sh 'aws s3 mb s3://$S3_BUCKET_NAME --region us-east-1'
                } 
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
                    withAWS(credentials: 'cloud_playgroud_aws_cred', region: '$REGION') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform validate'
                 }
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
                    withAWS(credentials: 'cloud_playgroud_aws_cred', region: '$REGION') {
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform plan -out terraform.plan -var="AWS_REGION=$REGION" -input=false'
                    archiveArtifacts artifacts: 'terraform.plan', fingerprint: true 
                    }
            }
        }        
        stage('apply') {
         /*    when {
                branch 'main'
            } */
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
                withAWS(credentials: 'cloud_playgroud_aws_cred', region: '$REGION') {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        input 'Deploy to Production'
                          sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                          sh 'terraform apply -input=false terraform.plan'
                    }
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
                withAWS(credentials: 'cloud_playgroud_aws_cred', region: '$REGION') {
                input 'Destroy!!!'
                    sh 'terraform init -input=false -backend-config="access_key=$TF_VAR_AWS_ACCESS_KEY_ID" -backend-config="secret_key=$TF_VAR_AWS_SECRET_ACCESS_KEY"'
                    sh 'terraform destroy --auto-approve'
                }
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
                withAWS(credentials: 'cloud_playgroud_aws_cred', region: 'us-east-1') {
                input 'Delete S3 Bucket!!!'
                    sh 'aws s3 rb s3://$S3_BUCKET_NAME --force --region us-east-1'
                }
            }
        }              
    }
}     
def getRegionName(branchName) {
    if("main".equals(branchName)) {
        return "us-east-1";
    } else if ("dev".equals(branchName)) {
        return "us-west-2";
    }
}        
