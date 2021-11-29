pipeline {
    agent {
	label 'ssh-agent'
	}
    stages {
        stage('Build') {
            steps {
                sh '''
                  echo This > app.sh
                  echo That >> app.sh
                '''
            }
        }
        stage('Test') {
            when {
                expression {
			return params.TestChoice =='YES' // && params.TestBool =='true'
                }
            }
		steps {
                sh '''
                  grep This app.sh >> ${BUILD_ID}.cov
                  grep That app.sh >> ${BUILD_ID}.cov
                '''
            }
        }
	stage('Environment') {
		steps {
			echo " The environment is ${params.Env}"
		}
	}
        stage('Coverage'){
            steps {
                sh '''
                  app_lines=`cat app.sh | wc -l`
                  cov_lines=`cat ${BUILD_ID}.cov | wc -l`
                  echo The app has `expr $app_lines - $cov_lines` lines uncovered > ${BUILD_ID}.rpt
                  cat ${BUILD_ID}.rpt
			cd ${SOURCE_DIR}; ls -a
                '''
                archiveArtifacts "${env.BUILD_ID}.rpt"
            }
        }
	stage('speak') {
		steps{
    slackSend channel: "#ishiwata-jenkins", message: "The Build Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}"}}
    }
}
