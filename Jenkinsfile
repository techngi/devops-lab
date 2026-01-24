pipeline {
  agent any

  parameters {
    string(
      name: 'IMAGE_TAG',
      defaultValue: 'latest',
      description: 'Docker image tag to deploy (must exist on Docker Hub)'
    )
  }

  environment {
    BRANCH      = "master"
    VALUES_FILE = "week4/gitops/week3-app/values.yaml"
  }

  stages {
    stage('Update GitOps values.yaml') {
      steps {
        withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
         sh '''
          rm -rf gitops
          git clone -b master https://'"$GITHUB_TOKEN"'@github.com/techngi/devops-lab.git gitops
        '''
          }
            cd gitops
            git config user.email "jenkins@local"
            git config user.name "Jenkins CI"

            sed -i 's/^  tag: .*/  tag: "'${IMAGE_TAG}'"/' ${VALUES_FILE}

            echo "Updated image section:"
            grep -n "image:" -A6 ${VALUES_FILE}

            git add ${VALUES_FILE}
            git diff --cached --quiet && echo "No changes to commit" || git commit -m "ci: deploy ..."
            git push origin ${BRANCH}
          """
        }
      }
    }
  }
}
