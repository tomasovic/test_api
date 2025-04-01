// Jenkinsfile (korigovano za agent)

pipeline {
    // Definišemo da se SVI stage-evi izvršavaju na bilo kom dostupnom agentu
    agent any

    // Definišemo parametre koji se koriste u pipeline-u
    environment {
        DEPLOY_DIR      = '/home/admin/projects/test_api'
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
            token: 'vmqX7pvx_YAxdx3UR*Tb', // <<< STAVI SVOJ PRAVI TOKEN OVDE
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        stage('Checkout Koda na PI3') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && git checkout ${DEV_TAG} && git pull origin ${DEV_TAG}'"
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
    }

    post {
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    }
}