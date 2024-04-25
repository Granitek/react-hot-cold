pipeline {
agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Clean up') {
            steps {
                echo "Cleaning..."
                sh '''
                docker image rm -f react-hot-cold
                docker image rm -f react-hot-cold-test
                docker image rm -f react-hot-cold-deploy
                '''
            }
        }

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
                
                docker build -t react-hot-cold-deploy -f .Dockerfile2 .
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
                docker tag react-hot-cold-deploy Granitek/react-hot-cold
                docker push Granitek/react-hot-cold
                docker logout

                '''
            } 
        }
    }
}