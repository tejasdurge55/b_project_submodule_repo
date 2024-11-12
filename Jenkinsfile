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
                git push https://${GITHUB_TOKEN}@github.com/yourusername/your-repo.git
                '''
            }
        }
    }
}
