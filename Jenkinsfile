// Jenkinsfile (Test: Aktivni Trigger, Jednostavan Checkout)

pipeline {
    agent any

    environment {
        DEPLOY_DIR      = '/home/admin/projects/test_api' // Proveri putanju
        COMPOSE_FILE    = "${DEPLOY_DIR}/docker-compose.yml"
        APP_IMAGE_NAME  = 'test-api'
        DEV_TAG         = 'dev'
        PI3_HOST        = '192.168.64.132'     // Proveri IP
        PI3_USER        = 'admin'
        SSH_CRED_ID     = 'jenkins-pi3-ssh-key'  // Proveri ID Kredencijala
    }

    triggers { // <-- Trigger je sada aktivan
        GenericTrigger(
            genericVariables: [],
            // VRLO VAŽNO: Unesi isti token koji si podesio u Jenkins Job konfiguraciji!
            token: 'vmqX7pvx_YAxdx3UR*Tb',  // <<< ZAMENI OVO TVOJIM PRAVIM TOKENOM
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        stage('Checkout Koda na PI3') { // <-- VRAĆAMO NA ECHO
            steps {
                echo "Simulacija: Checkout Koda na PI3"
            }
        }

        stage('Build Docker Image na PI3') { // <-- Ovo je radilo
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker build -t ${APP_IMAGE_NAME}:${DEV_TAG} .'"
                }
            }
        }

        stage('Deploy na PI3') { // <-- Ovo je radilo
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} down'"
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} up -d'"
                }
            }
        }

        stage('Cleanup na PI3') { // <-- Ovo je radilo
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                }
            }
        }
    } // Kraj stages

    post {
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!' // Izmenjeno radi jasnoće testa
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    } // Kraj post

} // Kraj pipeline