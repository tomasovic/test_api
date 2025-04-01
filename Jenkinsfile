// Jenkinsfile (Test: Minimal + Environment)
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
        // Token nam sada ne treba jer nema triggers bloka
        // TOKEN           = 'sifraZaWebhook123!'
    }

    stages {
        stage('Placeholder') { // Samo da stages blok ne bude prazan
            steps {
                echo "Environment block parsed successfully."
            }
        }
    } // Kraj stages

    // Bez post bloka za sada
} // Kraj pipeline