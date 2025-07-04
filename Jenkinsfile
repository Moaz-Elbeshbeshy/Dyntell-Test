pipeline {
    agent any

    environment {
        BACKEND_IMAGE = "ghcr.io/moaz-elbeshbeshy/dyntell-test/backend:latest"
        FRONTEND_IMAGE = "ghcr.io/moaz-elbeshbeshy/dyntell-test/frontend:latest"
        GITHUB_USER = 'Moaz-Elbeshbeshy' 
        DOCKER_BUILDKIT = "1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to GHCR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GITHUB_PAT', usernameVariable: 'GH_USER', passwordVariable: 'GH_PAT')]) {
                    sh '''
                        echo "$GH_PAT" | docker login ghcr.io -u "$GH_USER" --password-stdin
                    '''
                }

            }
        }
        
        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh """
                        docker buildx build --platform linux/amd64 \
                        --cache-from=type=registry,ref=$BACKEND_IMAGE-cache \
                        --cache-to=type=registry,ref=$BACKEND_IMAGE-cache,mode=max \
                        --tag $BACKEND_IMAGE --push .
                    """
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh """
                        docker buildx build --platform linux/amd64 \
                        --cache-from=type=registry,ref=$FRONTEND_IMAGE-cache \
                        --cache-to=type=registry,ref=$FRONTEND_IMAGE-cache,mode=max \
                        --tag $FRONTEND_IMAGE --push .
                    """
                }
            }
        }


        stage('Deploy') {
            steps {
                withCredentials([string(credentialsId: 'SQLALCHEMY_DB_URI', variable: 'DB_URI')]) {
                    sh """
                    docker pull $BACKEND_IMAGE
                    docker stop backend || true
                    docker rm backend || true
                    docker run -d --name backend -p 5000:5000 \
                        -e DATABASE_URI="$DB_URI" \
                        $BACKEND_IMAGE

                    docker pull $FRONTEND_IMAGE
                    docker stop frontend || true
                    docker rm frontend || true
                    docker run -d --name frontend -p 80:80 $FRONTEND_IMAGE
                    """
                }
            }
        }

    }
}
