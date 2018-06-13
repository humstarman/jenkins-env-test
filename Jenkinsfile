pipeline {
    agent any 
    environment {
        PROJECT = "env-test"
        TAG = "v0"
        LOCAL_REGISTRY = "172.31.78.217:5000"
        NAMESPACE = "default"
        NUM = "4"
    }
    stages {
        stage('Build') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {   
                    retry(5) {
                        sh "docker build -t ${env.LOCAL_REGISTRY}/${env.PROJECT}:${env.TAG} ."
                    }
                }
                sh "docker push ${env.LOCAL_REGISTRY}/${env.PROJECT}:${env.TAG}"
            }
        }
        stage('Deploy - Staging') {
            steps {
                sh "sed -i s/\"{{.namespace}}\"/\"${env.NAMESPACE}\"/g ./manifest/controller.yaml"
                sh "sed -i s/\"{{.project}}\"/\"${env.PROJECT}\"/g ./manifest/controller.yaml"
                sh "sed -i s/\"{{.local.registry}}\"/\"${env.LOCAL_REGISTRY}\"/g ./manifest/controller.yaml"
                sh "sed -i s/\"{{.tag}}\"/\"${env.TAG}\"/g ./manifest/controller.yaml"
                sh "sed -i s/\"{{.num}}\"/\"${env.N}\"/g ./manifest/controller.yaml"
                sh "if kubectl -n ${env.NAMESPACE} get pod | grep ${env.PROJECT}; then kubectl delete -f ./manifest/controller.yaml; fi"
            }
        }
        stage('Sanity check') {
            steps {
                input "Does the staging environment look ok?"
            }
        }
        stage('Deploy - Production') {
            steps {
                sh 'kubectl create -f ./manifest/controller.yaml'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
