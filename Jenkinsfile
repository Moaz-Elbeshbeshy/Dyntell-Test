pipeline {
    agent any

    environment {
        BACKEND_IMAGE = "ghcr.io/moaz-elbeshbeshy/Dyntell-Test/backend:latest"
        FRONTEND_IMAGE = "ghcr.io/moaz-elbeshbeshy/Dyntell-Test/frontend:latest"
        GITHUB_PAT = credentials('GITHUB_PAT')
        GITHUB_USER = 'moaz-elbeshbeshy'
        DOCKER_BUILDKIT = "1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to GHCR'){
            steps {
                sh """
                echo $GITHUB_PAT | docker login ghcr.io -u $GITHUB_USER --password-stdin 
                """
                //what the fuck was that command?
            }
        }
        
        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh """
                        docker buildx build --progress=plain \
                        --cache-from=type=registry,ref=$BACKEND_IMAGE \
                        --cache-to=type=registry,ref=$BACKEND_IMAGE,mode=max \
                        --tag $BACKEND_IMAGE --push .
                    """
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh """
                        docker buildx build --progress=plain \
                        --cache-from=type=registry,ref=$FRONTEND_IMAGE \
                        --cache-to=type=registry,ref=$FRONTEND_IMAGE,mode=max \
                       --tag $FRONTEND_IMAGE --push .
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                docker pull $BACKEND_IMAGE
                docker stop backend || true
                docker rm backend || true
                docker run -d --name backend -p 5000:5000 $BACKEND_IMAGE

                docker pull $FRONTEND_IMAGE
                docker stop frontend || true
                docker rm frontend || true
                docker run -d --name frontend -p 80:80 $FRONTEND_IMAGE
                """
            }
        }
    }
}
