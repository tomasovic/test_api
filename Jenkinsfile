// Jenkinsfile (Test: Struktura Stages i Post)
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
        // TOKEN           = 'sifraZaWebhook123!' // Token nam još ne treba
    }

    // Bez triggers bloka za sada

    stages {
        stage('Checkout Koda na PI3') {
            steps {
                echo "Simulacija: Checkout Koda na PI3"
                // Ovde bi inače išao sshagent i sh komanda
            }
        }

        stage('Build Docker Image na PI3') {
            steps {
                echo "Simulacija: Build Docker Image na PI3"
                // Ovde bi inače išao sshagent i sh komanda
            }
        }

        stage('Deploy na PI3') {
            steps {
                echo "Simulacija: Deploy na PI3"
                // Ovde bi inače išao sshagent i sh komanda
            }
        }

        stage('Cleanup na PI3') {
            steps {
                echo "Simulacija: Cleanup na PI3"
                // Ovde bi inače išao sshagent i sh komanda
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