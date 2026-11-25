pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        

    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        COMPOSE_PROJECT_NAME = 'backend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validar') {
            steps {
                sh 'docker compose config -q'
            }
        }

        stage('Build') {
            steps {
                sh 'docker compose build backend'
            }
        }

        stage('Verificar') {
            steps {
                sh 'docker compose run --rm --no-deps -T backend node --check src/index.js'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d --remove-orphans'
            }
        }

        stage('Smoke test') {
            steps {
                retry(10) {
                    sleep(time: 3, unit: 'SECONDS')
                    sh 'docker compose exec -T nginx wget -qO- http://localhost/productos'
                }
            }
        }
    }


    post{
        failure {
            sh 'docker compose logs --tail=100 || true'
        }
    }
}
