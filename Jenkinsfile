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
                sh 'jar cf HelloWorld.jar HelloWorld.class'
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
                git add HelloWorld.jar
                git commit -m "Adding compiled artifact"
                git push https://${GITHUB_TOKEN}@github.com/yourusername/your-repo.git
                '''
            }
        }
    }
}
