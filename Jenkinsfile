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

        stage('Determine New Version') {
            steps {
                script {
                    // Get the latest tag from GitHub
                    def latestTag = sh(script: "git describe --tags --abbrev=0", returnStdout: true).trim()
                    echo "Latest tag: ${latestTag}"
                    
                    // Extract version components (e.g., 1.2.3 -> major=1, minor=2, patch=3)
                    def (major, minor, patch) = latestTag.replace('v', '').tokenize('.').collect { it.toInteger() }

                    // Determine the version increment
                    switch ('patch') {
                        case 'major':
                            major++
                            minor = 0
                            patch = 0
                            break
                        case 'minor':
                            minor++
                            patch = 0
                            break
                        case 'patch':
                            patch++
                            break
                        default:
                            error "Invalid VERSION_INCREMENT: ${params.VERSION_INCREMENT}"
                    }

                    // Construct the new version
                    def newTag = "v${major}.${minor}.${patch}"
                    echo "New tag: ${newTag}"
                    
                    // Set this as an environment variable for later stages
                    env.NEW_TAG = newTag

                    // Commit the artifact
                    sh 'git config --global user.email "tejas.y.durge@gmail.com"'
                    sh 'git config --global user.name "tejasdurge55"'
                    sh 'git add java_artifacts/HelloWorld.jar'
                    sh 'git commit -m "Adding compiled artifact"'
                    
                    // Push the artifact to a separate branch
                    sh 'git push https://${GITHUB_TOKEN}@github.com/tejasdurge55/b_project_submodule_repo.git HEAD:artifact-branch --force'
                    
                    // Tag the repository with the new version
                    // sh 'git tag $NEW_TAG'
                    // sh 'git push https://${GITHUB_TOKEN}@github.com/tejasdurge55/b_project_submodule_repo.git $NEW_TAG'
                    sh """
                        curl -X POST \
                        -H "Authorization: token ${GITHUB_TOKEN}" \
                        -H "Content-Type: application/json" \
                        -d '{
                              "tag_name": "$NEW_TAG",
                              "name": "$NEW_TAG",
                              "body": "Release for version $NEW_TAG",
                              "draft": false,
                              "prerelease": false
                            }' \
                        https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/releases
                    """

                }
            }
        }
    }
}
