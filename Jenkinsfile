node {
   try {
          eventible_backend()
          send_email()
       }catch (e) {
       currentBuild.result = "FAILED"
       send_email()
       throw e
   }
}


def eventible_backend(){

    stage('Cleanup'){
        echo "Running cleanup of dangling images and exited containers."
        sh label: '', script: '''docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null
             docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null
             docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null
             docker rm -v `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null
             docker rm -f -v `docker ps -a -q -f status=restarting -f name=run_` &> /dev/null || true &> /dev/null
             docker rm -f -v `docker ps -a -q -f status=running -f name=run_` &> /dev/null || true &> /dev/null
             docker rmi `docker images --filter 'dangling=true' -q --no-trunc` &> /dev/null || true &> /dev/null'''
    }

    stage('SCM Checkout'){
        checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '${sha1}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[name: 'origin', refspec: '+refs/pull/*:refs/remotes/origin/pr/*', url: 'git@github-eventible:eventible2021/eventible-backend.git']]]
    }

    stage('Copy database.yml'){
        sh label: '', script: 'cp .env.test .env'
        sh label: '', script: '''echo -e "default: &default\n  adapter: postgresql\n  encoding: unicode\n  host: postgres\n  username: postgres\n  password: password\n  pool: 5\n\ndevelopment:\n  <<: *default\n  database: eventible_backend_development\n\ntest:\n  <<: *default\n  database: eventible_backend_test" > config/database.yml '''
    }

    stage('Build Project') {
        sh label: '', script: "docker-compose -f docker-compose-jenkins.yml --project-name=${JOB_NAME} build"
    }

    stage('Prepare Test database') {
            def TestDBCmd = 'bundle exec rake db:drop db:create'
            echo "Preparing test DB using command : ${TestDBCmd}"
            sh label: '', script: "docker-compose -f docker-compose-jenkins.yml --project-name=${JOB_NAME} run -e RAILS_ENV=test backend $TestDBCmd"
    }

    stage('Set ENV') {
        def SetEnvCmd = 'bundle exec rails db:environment:set RAILS_ENV=test'
        echo "Preparing test DB using command : ${SetEnvCmd}"
        sh label: '', script: "docker-compose -f docker-compose-jenkins.yml --project-name=${JOB_NAME} run -e RAILS_ENV=test backend $SetEnvCmd"
    }

    stage('Migrate Test database') {
        def TestDBCmd = 'bundle exec rake db:migrate'
        echo "Preparing test DB using command : ${TestDBCmd}"
        sh label: '', script: "docker-compose -f docker-compose-jenkins.yml --project-name=${JOB_NAME} run -e RAILS_ENV=test backend $TestDBCmd"
    }

    stage('Run Tests and Push Report through Simplecov') {
        sh label: '', script: 'docker-compose -f docker-compose-jenkins.yml --project-name=${JOB_NAME} run -e RAILS_ENV=test backend sh -c "bundle exec gem list && bundle exec rspec spec && export CC_TEST_REPORTER_ID=174502a90a91bb9ef276f687b467e5c8c11d07ac9117b1fe941dbcc4688e062d && curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter && chmod +x ./cc-test-reporter && ./cc-test-reporter before-build && ./cc-test-reporter after-build -t simplecov --exit-code $? || echo \"Skipping Code Climate coverage upload\""'
    }

}

def send_email() {
    stage('Send-Email') {
       emailext attachLog: true,
       body: '$DEFAULT_CONTENT',
       postsendScript: '$DEFAULT_POSTSEND_SCRIPT',
       presendScript: '$DEFAULT_PRESEND_SCRIPT',
       subject: '$DEFAULT_SUBJECT',
       to: 'apardeshi@eventible.in, anshita@eventible.in, mshaikh@eventible.in'
    }
}
