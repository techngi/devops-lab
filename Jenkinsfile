pipeline {
  agent any

  parameters {
    string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag to deploy (must exist on Docker Hub)')
  }

  stages {
    stage('Update GitOps values.yaml') {
      steps {
        withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
          sh """
            set -e
            BRANCH="master"
            VALUES_FILE="week4/gitops/week3-app/values.yaml"
            IMAGE_REPO="sanaqvi573/week3-app"

            rm -rf gitops
            git clone -b "\$BRANCH" https://github.com/techngi/devops-lab.git gitops
            cd gitops

            # Configure auth for push (token)
            git remote set-url origin "https://\${GITHUB_TOKEN}@github.com/techngi/devops-lab.git"

            # Configure commit identity
            git config user.email "jenkins@local"
            git config user.name "Jenkins CI"

            # Update tag properly -> tag: "17"
            sed -i "s/^  tag: .*/  tag: \\\"\${IMAGE_TAG}\\\"/" "\$VALUES_FILE"

            echo "Updated image section:"
            grep -n "image:" -A6 "\$VALUES_FILE"

            git add "\$VALUES_FILE"

            if git diff --cached --quiet; then
              echo "No changes to commit"
            else
              git commit -m "ci: deploy \${IMAGE_REPO}:\${IMAGE_TAG}"
              git push origin "\$BRANCH"
            fi
          """
        }
      }
    }
  }
}
