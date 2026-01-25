# ArgoCD continuously reconciles desired state from Git (Helm chart) into the cluster.”

# Use a separate folder (or repo) that ArgoCD will watch, e.g.:
devops-lab/
└─ week4/
   └─ gitops/
      └─ week3-app/
         ├─ Chart.yaml
         ├─ values.yaml
         └─ templates/

# If your Helm chart currently lives at:
# ~/devops-lab/week4/helm/week3-app
# copy it into your GitOps path:

```bash
mkdir -p ~/devops-lab/week4/gitops
cp -r ~/devops-lab/week4/helm/week3-app ~/devops-lab/week4/gitops/week3-app
```

# Commit/push that folder to GitHub (ArgoCD needs a Git URL)

# 1) Install ArgoCD into Minikube
Create namespace + install:

```bash
kubectl create ns argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get pods -n argocd
```

# 2) Access ArgoCD UI + login

```bash
kubectl port-forward svc/argocd-server -n argocd 8085:443
```

# Get initial admin password

```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

# Login
username: admin
password: (from above)

# Create an ArgoCD Application to deploy your Helm chart

 ```bash
cat > ~/devops-lab/week4/gitops/week3-app-application.yaml <<'EOF'
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: week3-app
  namespace: argocd
spec:
  project: default # Ensure ArgoCD project default exists (check with argocd proj list)
  source:
    repoURL: https://github.com/techngi/devops-lab.git
    targetRevision: master
    path: week4/gitops/week3-app
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: devops-week5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF
```

# Apply it

```bash
kubectl apply -f ~/devops-lab/week4/gitops/week3-app-application.yaml
```

# Verify from ArgoCD CLI

```bash
kubectl get all -n devops-week5
kubectl get svc -n devops-week5
```

# Open the service using name from kubectl get svc

```bash
minikube service -n devops-week5 <service-name>
```

# Common ArgoCD commands

```bash
kubectl port-forward svc/argocd-server -n argocd 8085:443
argocd login localhost:8085
kubectl get secret argocd-initial-admin-secret -n argocd   -o jsonpath="{.data.password}" | base64 -d; echo
argocd account get-user-info
argocd account update-password
argocd login localhost:8085 --insecure

argocd app list
argocd app get week3-app

argocd proj create default \
  --description "Default ArgoCD project" \
  --dest https://kubernetes.default.svc,* \
  --src '*' \
  --upsert

argocd proj get default

argocd app get week3-app
argocd app refresh week3-app
argocd app sync week3-app
```
