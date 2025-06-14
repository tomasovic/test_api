// Jenkinsfile - Ispravljena i pojednostavljena verzija
pipeline {
    agent any

    environment {
        DEPLOY_DIR      = '/home/admin/projects/test_api'
        APP_IMAGE_NAME  = 'test-api'
        DEV_TAG         = 'dev'
        PI3_HOST        = '192.168.64.132'
        PI3_USER        = 'admin'
        SSH_CRED_ID     = 'jenkins-pi3-ssh-key'
    }

    // Trigger ostaje isti, ne diraj ga.
    triggers {
        GenericTrigger(
            genericVariables: [],
            token: 'vmqX7pvx_YAxdx3UR*Tb',
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        // Svi koraci su sada spojeni u jedan logičan stejdž.
        stage('Deploy na PI3') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    script {
                        echo "1/4: Kreiranje direktorijuma na PI3..."
                        sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'mkdir -p ${DEPLOY_DIR}'"

                        echo "2/4: Kopiranje koda aplikacije na PI3..."
                        // Kopira SVE iz Jenkins workspace-a u DEPLOY_DIR na PI3
                        sh "scp -r -o StrictHostKeyChecking=no ./* ${PI3_USER}@${PI3_HOST}:${DEPLOY_DIR}/"

                        echo "3/4: Build Docker image-a na PI3..."
                        sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker build -t ${APP_IMAGE_NAME}:${DEV_TAG} .'"

                        echo "4/4: Pokretanje kontejnera na PI3..."
                        sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose down && docker compose up -d'"

                        echo "Dodatno: Čišćenje starih image-a..."
                        sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                    }
                }
            }
        }
    } // Kraj stages

    post {
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    } // Kraj post

} // Kraj pipeline