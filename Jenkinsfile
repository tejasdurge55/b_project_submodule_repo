pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github-token') // Replace with your Jenkins credential ID
        GIT_USER_EMAIL = "tejas.y.durge@gmail.com"
        GIT_USER_NAME = "tejasdurge55"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/tejasdurge55/b_project_submodule_repo.git', branch: 'master'
            }
        }

        stage('Compile and Package Java Code') {
            steps {
                sh '''
                    cd java_files
                    javac HelloWorld.java
                    jar cf HelloWorld.jar HelloWorld.class
                    cd ..
                    cp java_files/HelloWorld.jar java_artifacts/
                '''
            }
        }

        stage('Commit, Push Artifact, and Tag') {
            steps {
                script {
                    // Configure Git
                    sh """
                        git config --global user.email "${GIT_USER_EMAIL}"
                        git config --global user.name "${GIT_USER_NAME}"
                    """

                    // Commit and push artifact
                    sh '''
                        git add java_artifacts/HelloWorld.jar
                        git commit -m "Adding compiled artifact"
                        git push https://${GITHUB_TOKEN}@github.com/tejasdurge55/b_project_submodule_repo.git HEAD:artifact-branch
                    '''

                    // Tagging and pushing
                    def latestTag = sh(script: "git describe --tags `git rev-list --tags --max-count=1`", returnStdout: true).trim()
                    def newTag = sh(script: "echo ${latestTag} | awk -F. -v OFS=. '{\$NF++; print \"v\"\$0}'", returnStdout: true).trim()
                    echo "Tagging repository with ${newTag}"

                    sh """
                        git tag ${newTag}
                        git push https://${GITHUB_TOKEN}@github.com/tejasdurge55/b_project_submodule_repo.git ${newTag}
                    """

                    // Optional: Create a GitHub release
                    sh """
                        curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
                        -d '{"tag_name": "${newTag}", "name": "${newTag}", "body": "Release created by Jenkins"}' \
                        https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/releases
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
