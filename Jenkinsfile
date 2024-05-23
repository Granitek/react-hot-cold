pipeline {
agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('39ff0642-d9e7-4f01-8ec9-71f7e9f0ecbc')
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Pull'){
            steps{
                echo "Pulling..."
                git branch: 'main', credentialsId: '889afa24-9d1f-4fac-b539-7d541df8cf41', url: 'https://github.com/Granitek/react-hot-cold'
            }
        }

        stage('Build') {
            steps {
                echo "Building..."
                sh '''
                docker build -t react-hot-cold -f ./Dockerfile .
                docker run --name rhc-build react-hot-cold
                docker cp rhc-build:/react-hot-cold/build ./artifacts
                docker logs rhc-build > build_logs.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Testing..."
                sh '''
                docker build -t react-hot-cold-test -f ./Dockerfile1 .
                docker run --name rhc-test react-hot-cold-test
                docker logs rhc-test > test_logs.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying..."
                sh '''
                
                docker build -t react-hot-cold-deploy -f ./Dockerfile2 .
                docker run -p 3000:3000 -d --rm --name rhc-deploy react-hot-cold-deploy
                '''
            }
        }

        stage('Publish') {
            steps {
                echo "Publishing..."
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz build_logs.txt test_logs.txt artifacts
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                NUMBER='''+ env.BUILD_NUMBER +'''
                docker tag react-hot-cold-deploy abdialan/react-hot-cold:1.1
                docker push abdialan/react-hot-cold:1.1
                docker logout

                '''
            } 
        }
    }
}