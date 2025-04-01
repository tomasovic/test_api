// Jenkinsfile (korigovano za checkout, agent i bez komentara na kraju)

pipeline { // ZAGRADA 1 OTVORENA
    agent any

    environment {
        DEPLOY_DIR      = '/home/admin/projects/test_api' // <<< PROVERI DA LI JE OVO TAČNA PUTANJA SADA
        COMPOSE_FILE    = "${DEPLOY_DIR}/docker-compose.yml"
        APP_IMAGE_NAME  = 'test-api'
        DEV_TAG         = 'dev'
        PI3_HOST        = '192.168.64.132'
        PI3_USER        = 'admin'
        SSH_CRED_ID     = 'jenkins-pi3-ssh-key'
    }

    triggers {
        GenericTrigger(
            genericVariables: [],
            token: 'sifraZaWebhook123!', // <<< STAVI SVOJ PRAVI TOKEN OVDE
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages { // ZAGRADA 2 OTVORENA
        stage('Checkout Koda na PI3') {
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

        stage('Build Docker Image na PI3') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker build -t ${APP_IMAGE_NAME}:${DEV_TAG} .'"
                }
            }
        }

        stage('Deploy na PI3') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} down'"
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} up -d'"
                }
            }
        }

        stage('Cleanup na PI3') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                }
            }
        }
    } // ZAGRADA 2 ZATVORENA

    post { // ZAGRADA 3 OTVORENA
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    } // ZAGRADA 3 ZATVORENA

} // ZAGRADA 1 ZATVORENA