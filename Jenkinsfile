pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github-token') // Replace with your Jenkins credential ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone repository
                git url: 'https://github.com/tejasdurge55/b_project_submodule_repo.git', branch: 'master'
            }
        }

        stage('Compile Java Code') {
            steps {
                // Compile the Java code
                sh 'cd java_files && javac HelloWorld.java'
            }
        }

        stage('Package Artifact') {
            steps {
                // Package compiled class into a JAR file
                sh 'cd java_files && jar cf HelloWorld.jar HelloWorld.class'
            }
        }

        stage('Run and move Artifact') {
            steps {
                // Package compiled class into a JAR file
                sh 'cd java_files && java -cp HelloWorld.jar HelloWorld && cd .. && cp java_files/HelloWorld.jar java_artifacts/ '
            }
        }


        stage('Commit and Push Artifact') {
            steps {
                // Configure Git user details
                sh '''
                git config --global user.email "tejas.y.durge@gmail.com"
                git config --global user.name "tejasdurge55"
                '''

                // Add, commit, and push the JAR file
                sh '''
                git add java_artifacts/HelloWorld.jar
                git commit -m "Adding compiled artifact"
                git push https://${GITHUB_TOKEN}@github.com/tejasdurge55/b_project_submodule_repo.git HEAD:artifact-branch
                '''
            }
        }
    }
    
    post {
        success {
            script {

                sh 'latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)'
                def tagName = "v$(echo $latestTag | awk -F. -v OFS=. '{$NF++; print}')"
                echo "Tagging repository with ${tagName}"

                // Configure Git user
                sh 'git config --global user.name "Jenkins CI"'
                sh 'git config --global user.email "jenkins@example.com"'

                // Create and push tag
                sh "git tag ${tagName}"
                sh "git push origin ${tagName}"
                
                // Optional: Create a GitHub release (if using GitHub)
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    sh """
                        curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
                        -d '{"tag_name": "${tagName}", "name": "${tagName}", "body": "Release created by Jenkins"}' \
                        https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/releases
                    """
                }
            }
        }

        failure {
            echo "Pipeline failed. No tag created."
        }
    }
}
