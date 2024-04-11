pipeline {
agent any

    triggers {
        pollSCM('* * * * *')
    }
    stages {

        stage('Pull'){
            steps{
                git branch: 'main', credentialsId: '889afa24-9d1f-4fac-b539-7d541df8cf41', url: 'https://github.com/Granitek/react-hot-cold'
            }
        }

        stage('Build') {
            steps {
                echo "Building..."
                sh '''
                docker build -t react-hot-cold -f ./Dockerfile .
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Testing..."
                sh '''
                docker build -t react-hot-cold-test -f ./Dockerfile1 .
                '''
            }
        }
    }
}