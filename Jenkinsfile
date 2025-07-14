// pipeline {
//     agent any

//     stages {
//         stage('Checkout') {
//             steps {
//                 git branch:'main', url: 'https://github.com/DuVanSang/QLTV.git'
//             }
//         }

//         stage('Build') {
//             steps {
//                 bat 'cd backend && mvn clean compile'
//             }
//         }

//         stage('Test') {
//             steps {
//                 bat 'cd backend && mvn test'
//             }
//         }

//         stage('Package') {
//             steps {
//                 bat 'cd backend && mvn package'
//             }
//         }

//        stage('Deploy') {
//             steps {
//                 bat '''
//                     cd backend\\target
//                     taskkill /F /IM java.exe || echo No java process found
//                     start /B java -jar library-management-backend-0.0.1-SNAPSHOT.jar --server.port=9999
//                 '''
//             }
//         }
//     }
// }

pipeline {
    agent any

    environment {
        NODE_ENV = "production"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/DuVanSang/QLTV.git'
            }
        }

        stage('Install Node.js dependencies') {
            steps {
                bat 'npm install --legacy-peer-deps'
                bat 'npm install typescript vite' // Fix lỗi thiếu tsc + vite
            }
        }

        stage('Build React App') {
            steps {
                bat 'npx tsc && npx vite build' // Dùng npx nếu chưa global
            }
        }

        stage('Build Spring Boot') {
            steps {
                bat 'cd backend && mvn clean package -DskipTests'
            }
        }

        stage('Run Backend') {
            steps {
                bat '''
                    cd backend\\target
                    for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /v ^| findstr "library-management-backend-0.0.1-SNAPSHOT.jar"') do taskkill /PID %%a /F
                    start java -jar library-management-backend-0.0.1-SNAPSHOT.jar --server.port=8081
                '''
            }
        }

        stage('Run Frontend') {
            steps {
                bat 'npx serve -s dist -l 5173'
            }
        }
    }
}
