pipeline {
    agent any
    environment {
        GITHUB_TOKEN = credentials('github-token')  // Replace with your actual GitHub token credentials ID
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Compile and Package Java Code') {
            steps {
                script {
                    sh 'javac HelloWorld.java'
                    sh 'jar cf HelloWorld.jar HelloWorld.class'
                    sh 'cp HelloWorld.jar java_artifacts/'
                }
            }
        }
        stage('Commit, Push Artifact, and Tag') {
            steps {
                script {
                    def latestTag = sh(script: "git describe --tags --abbrev=0", returnStdout: true).trim()  // Get the latest tag
                    def newTag = sh(script: "echo ${latestTag} | awk -F. -v OFS=. '{\$NF++; print \"v\"\$0}'", returnStdout: true).trim()
                    
                    echo "New tag to be created: ${newTag}"
                    
                    // Commit the artifact
                    sh 'git config --global user.email "tejas.y.durge@gmail.com"'
                    sh 'git config --global user.name "tejasdurge55"'
                    sh 'git add java_artifacts/HelloWorld.jar'
                    sh 'git commit -m "Adding compiled artifact"'
                    
                    // Push the artifact to a separate branch
                    sh 'git push https://****@github.com/tejasdurge55/b_project_submodule_repo.git HEAD:artifact-branch --force'
                    
                    // Create the new tag and push it
                    sh "git tag ${newTag}"
                    sh "git push origin ${newTag}"
                }
            }
        }
    }
}
