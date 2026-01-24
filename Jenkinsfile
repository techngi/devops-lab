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
          sh """
            rm -rf gitops
            git clone -b ${BRANCH} https://${GITHUB_TOKEN}@github.com/techngi/devops-lab.git gitops
            cd gitops

            sed -i 's/^  tag: .*/  tag: "'${IMAGE_TAG}'"/' ${VALUES_FILE}

            echo "Updated image section:"
            grep -n "image:" -A6 ${VALUES_FILE}

            git add ${VALUES_FILE}
            git commit -m "ci: deploy sanaqvi573/week3-app:${IMAGE_TAG}" || echo "No changes to commit"
            git push origin ${BRANCH}
          """
        }
      }
    }
  }
}
