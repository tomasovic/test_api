// Jenkinsfile (FINALNA VERZIJA)

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
            token: 'sifraZaWebhook123!',  // <<< ZAMENI OVO TVOJIM PRAVIM TOKENOM
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        stage('Checkout Koda na PI3') { // <-- VRAĆAMO PRAVU LOGIKU OVDE
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh """
                       ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} ' \\
                         echo "Ensuring directory structure and code checkout..."; \\
                         mkdir -p ${DEPLOY_DIR%/*} && \\
                         if [ ! -d "${DEPLOY_DIR}/.git" ]; then \\
                           echo "Directory ${DEPLOY_DIR} not found or not a git repo. Cloning..."; \\
                           rm -rf ${DEPLOY_DIR}; \\
                           git clone https://github.com/tomasovic/test_api.git ${DEPLOY_DIR}; \\
                           cd ${DEPLOY_DIR} && echo "Checking out branch ${DEV_TAG}..." && git checkout ${DEV_TAG}; \\
                         else \\
                           echo "Repository found in ${DEPLOY_DIR}. Force resetting and pulling updates for branch ${DEV_TAG}..."; \\
                           cd ${DEPLOY_DIR} && \\
                           echo "Checking out branch ${DEV_TAG}..." && git checkout ${DEV_TAG} && \\
                           echo "Fetching latest changes from origin..." && git fetch origin && \\
                           echo "Resetting local state to match origin/${DEV_TAG}..." && git reset --hard origin/${DEV_TAG} && \\
                           echo "Pulling latest changes (should be up-to-date)..." && git pull origin ${DEV_TAG} && \\
                           echo "Cleaning untracked files..." && git clean -fdx; \\
                         fi; \\
                         echo "Checkout/Update complete." \\
                       '
                    """
                }
            }
        }

        stage('Build Docker Image na PI3') { // <-- Ovo već radi
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker build -t ${APP_IMAGE_NAME}:${DEV_TAG} .'"
                }
            }
        }

        stage('Deploy na PI3') { // <-- Ovo već radi
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} down'"
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} up -d'"
                }
            }
        }

        stage('Cleanup na PI3') { // <-- Ovo već radi
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                }
            }
        }
    } // Kraj stages

    post { // <-- Ovo već radi
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    } // Kraj post

} // Kraj pipeline