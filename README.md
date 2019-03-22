SSHPass Docker image
====================
This image is used for deployment and utility purposes. Both sshpass and openssh are installed.

Another option would be to get the credentials from environment variables if you don't really like the idea of storing them in your CI platform.

## Where it can be useful:
The idea is to have a clean alpine image with sshpass so certain stages of a CI pipeline can run make use of the utility.

Use this container anywhere you need to ssh into a remote host and run ssh/scp commands in an automated process where you dont want to enter the password explicitly in a interactive mode.

## How to use it inside a Jenkins pipeline
```
stage('get the code and build assets to send to remote') {
    agent {
        docker {
            image 'any-image-needed-to-do-this'
            reuseNode true
        }
    }
    steps {
        ...
        // checkout code from git?
        // build assets
        // unit tests?
    }
}
stage('Deployment to REMOTE') {
    agent {
        docker {
            image 'javieraviles/sshpass'
            reuseNode true
        }
    }
    steps {
        echo "[INFO] Deploying to REMOTE"
        withCredentials([usernamePassword(credentialsId: 'remote-credentials', passwordVariable: 'REMOTE_PASSWORD', usernameVariable: 'REMOTE_USER')]) {
            sh "sshpass -p '${REMOTE_PASSWORD}' scp -o StrictHostKeyChecking=no <asset-name-to-be-copied> ${REMOTE_USER}@$<remote-server-ip>:/path/where/to/copy/assets/in/remote/asset-name-to-be-pasted"
        }
        echo "[INFO] Cleaning workspace"
        cleanWs()
    }
}
```