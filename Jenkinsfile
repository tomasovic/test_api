// Jenkinsfile (Poziva eksternu checkout skriptu)

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
        REPO_URL        = 'https://github.com/tomasovic/test_api.git' // URL tvog repoa
    }

    triggers { // <-- Trigger je sada aktivan
        GenericTrigger(
            genericVariables: [],
            token: 'sifraZaWebhook123!',  // <<< ZAMENI OVO TVOJIM PRAVIM TOKENOM
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        stage('Checkout Koda na PI3') { // <-- IZMENJEN STEPS BLOK
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    // Pozivamo bash skriptu koja se nalazi u repou
                    // Prosleđujemo argumente: $1=REPO_URL, $2=DEPLOY_DIR, $3=DEV_TAG
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'bash ${DEPLOY_DIR}/deploy/checkout_or_clone.sh ${REPO_URL} ${DEPLOY_DIR} ${DEV_TAG}'"
                }
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

    post { // <-- Ovo je radilo
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    } // Kraj post

} // Kraj pipeline