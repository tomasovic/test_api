// Jenkinsfile (Test: Vraćen Cleanup i Deploy Stage)
pipeline {
    agent any

    environment {
        DEPLOY_DIR      = '/home/admin/projects/test_api'
        COMPOSE_FILE    = "${DEPLOY_DIR}/docker-compose.yml"
        APP_IMAGE_NAME  = 'test-api'
        DEV_TAG         = 'dev'
        PI3_HOST        = '192.168.64.132'
        PI3_USER        = 'admin'
        SSH_CRED_ID     = 'jenkins-pi3-ssh-key'
        // TOKEN           = 'sifraZaWebhook123!'
    }

    // Bez triggers bloka za sada

    stages {
        stage('Checkout Koda na PI3') {
            steps {
                echo "Simulacija: Checkout Koda na PI3"
            }
        }

        stage('Build Docker Image na PI3') {
            steps {
                echo "Simulacija: Build Docker Image na PI3"
            }
        }

        stage('Deploy na PI3') { // <-- VRAĆAMO PRAVU LOGIKU OVDE
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} down'"
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} up -d'"
                }
            }
        }

        stage('Cleanup na PI3') { // <-- OVAJ JE VEĆ VRAĆEN
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                }
            }
        }
    } // Kraj stages

    post {
        success {
            echo 'CI/CD Pipeline (Simulacija) zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline (Simulacija) NEUSPESAN!'
        }
    } // Kraj post

} // Kraj pipeline