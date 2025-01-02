pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github') // Replace with your Jenkins credential ID dev
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



                    

                    // Fetch the latest merged PR number targeting master
                    // def prBody = sh(script: """
                    //     curl -s -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/pulls?state=closed&sort=updated&direction=desc&per_page=1" | jq -r '.[0].body'
                    // """, returnStdout: true).trim()


                    // echo "PR Body: ${prBody}"
                    
                    // Determine the version increment
                    def incrementType = 'patch' // Default increment
                    // if (prBody.contains("[X] **Major**") || prBody.contains("[x] **Major**") ) {
                    //     incrementType = 'major'
                    // } else if (prBody.contains("[X] **Minor**") || prBody.contains("[x] **Minor**") ) {
                    //     incrementType = 'minor'
                    // } else if (prBody.contains("[X] **Patch**") || prBody.contains("[x] **Patch**") ) {
                    //     incrementType = 'patch'
                    // } else {
                    //     error "No valid version increment type specified in the PR body."
                    // }
                    
                    echo "Version increment type: ${incrementType}"
                    
                    // Fetch the latest tag
                    def latestTag = sh(script: "git describe --tags --abbrev=0", returnStdout: true).trim()
                    echo "Latest tag: ${latestTag}"
                    
                    // Calculate the new version based on the increment type
                    def (major, minor, patch) = latestTag.replace('v', '').tokenize('.').collect { it.toInteger() }
                    switch (incrementType) {
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
                    }
                    
                    def newTag = "v${major}.${minor}.${patch}"
                    echo "New tag: ${newTag}"
                    env.NEW_TAG = newTag
                    
                    // Output the new tag for verification
                    echo "Pipeline completed successfully. New version tag is: ${newTag}"
                    

                    
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
                              "body": "Release for version '${NEW_TAG}'\\n\\n[Release link](https://github.com/tejasdurge55/b_project_submodule_repo/releases/download/${NEW_TAG}/HelloWorld.jar)",
                              "draft": false,
                              "prerelease": false
                            }' \
                        https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/releases
                    """

                    
                    // sh """
                    //     response=\$(curl -X POST \
                    //       -H "Authorization: token ${GITHUB_TOKEN}" \
                    //       -H "Content-Type: application/json" \
                    //       -d '{
                    //             "tag_name": "${NEW_TAG}",
                    //             "name": "${NEW_TAG}",
                    //             "body": "Release for version '${NEW_TAG}'\\n\\n[Release link](https://github.com/tejasdurge55/b_project_submodule_repo/releases/download/${NEW_TAG}/HelloWorld.jar)",
                    //             "draft": false,
                    //             "prerelease": false
                    //           }' \
                    //       https://api.github.com/repos/tejasdurge55/b_project_submodule_repo/releases)
                        
                    //     # Extract the upload URL from the response
                    //     upload_url=\$(echo "\$response" | jq -r '.upload_url' | sed -e "s/{?name,label}//")
                        

                        
                    //     # Specify the file to upload
                    //     file_path="java_artifacts/HelloWorld.jar"
                    //     file_name=\$(basename "\$file_path")
                        
                    //     # Upload the asset
                    //     curl -X POST \
                    //       -H "Authorization: token ${GITHUB_TOKEN}" \
                    //       -H "Content-Type: application/octet-stream" \
                    //       --data-binary @"\$file_path" \
                    //       "\${upload_url}?name=\${file_name}"
                        
                    //     echo "Release created and asset uploaded successfully!"
                    // """

                }
            }
        }
    }
}
