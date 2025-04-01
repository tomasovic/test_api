// Jenkinsfile (za tomasovic/test_api)

pipeline {
    agent none // Ne koristi globalnog agenta

    // Definišemo parametre koji se koriste u pipeline-u
    environment {
        // Putanja do direktorijuma na PI3 gde se nalazi kod i docker-compose.yml
        // Proveri da li je ovo tačna putanja koju koristiš na PI3
        DEPLOY_DIR      = '/home/admin/deploy/test_api'
        // Puno ime compose fajla na PI3
        COMPOSE_FILE    = "${DEPLOY_DIR}/docker-compose.yml"
        // Naziv Docker image-a koji ćemo buildati (bez taga)
        APP_IMAGE_NAME  = 'test-api'
        // Tag koji ćemo koristiti za dev granu
        DEV_TAG         = 'dev'
        // IP adresa ili hostname PI3 za SSH komande
        PI3_HOST        = '192.168.64.132' // Proveri IP adresu PI3
        // Korisnik na PI3 kao koji se izvršavaju komande
        PI3_USER        = 'admin'
        // ID Jenkins kredencijala za SSH ključ
        SSH_CRED_ID     = 'jenkins-pi3-ssh-key' // ID koji smo definisali u Jenkinsu
    }

    triggers {
        // Podešavanje za prijem webhooka sa GitHub-a
        // Token mora biti isti onaj koji ćeš podesiti u GitHub Webhook podešavanjima
        GenericTrigger(
            genericVariables: [
                // Opciono: Možemo izvući podatke iz GitHuba, npr. ime grane
                // [key: 'GIT_BRANCH', jsonPath: '$.ref', regexpFilter: 'refs/heads/(.*)']
            ],
            token: 'TVOJ_TAJNI_TOKEN', // <<< ZAMENI OVO SA SIGURNIM TOKENOM PO IZBORU
            printPostContent: true,
            printContributedVariables: true,
            causeString: 'Pokrenuto Webhook-om sa GitHub-a'
        )
    }

    stages {
        stage('Checkout Koda na PI3') {
            agent { label 'master' } // Ovaj korak može i na masteru, samo pokreće SSH
            steps {
                // Koristimo SSH Agent plugin za konekciju
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && git checkout ${DEV_TAG} && git pull origin ${DEV_TAG}'"
                }
            }
        }

        stage('Build Docker Image na PI3') {
            agent { label 'master' } // Ovaj korak može i na masteru
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    // Buildamo image na PI3 koristeći Dockerfile iz checkout-ovanog koda
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker build -t ${APP_IMAGE_NAME}:${DEV_TAG} .'"
                }
            }
        }

        stage('Deploy na PI3') {
            agent { label 'master' } // Ovaj korak može i na masteru
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    // Gasimo stari kontejner i podižemo novi sa sveže buildanim image-om
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} down'"
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'cd ${DEPLOY_DIR} && docker compose -f ${COMPOSE_FILE} up -d'"
                }
            }
        }

        stage('Cleanup na PI3') {
            agent { label 'master' } // Ovaj korak može i na masteru
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    // Brišemo stare (dangling) image-e
                    sh "ssh -o StrictHostKeyChecking=no ${PI3_USER}@${PI3_HOST} 'docker image prune -af'"
                }
            }
        }
    }

    post {
        // Opciono: Notifikacije
        success {
            echo 'CI/CD Pipeline zavrsen uspesno!'
        }
        failure {
            echo 'CI/CD Pipeline NEUSPESAN!'
        }
    }
}
