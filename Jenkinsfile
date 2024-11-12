pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github-token') // Replace with your Jenkins credential ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone repository
                git url: 'https://github.com/yourusername/your-repo.git', branch: 'main'
            }
        }

        stage('Compile Java Code') {
            steps {
                // Compile the Java code
                sh 'javac HelloWorld.java'
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
                git config --global user.email "your.email@example.com"
                git config --global user.name "Your Name"
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
