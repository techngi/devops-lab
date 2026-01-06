A Helm chart is a packaged, templated, and versioned way to deploy applications to Kubernetes.
If Kubernetes YAML is raw instructions, Helm charts are reusable deployment blueprints.

Create helm chart

```bash
helm create week3-app
```

Modify:

values.yaml

templates/deployment.yaml (if required)

templates/service.yaml (if required)

values.yaml

```bash
image:
  repository: sanaqvi573/week3-app
  pullPolicy: IfNotPresent
  tag: "latest"


service:
    type: NodePort
  port: 5000
  nodeport: 30081
```

Install the chart

```bash
helm install week3-release ./week3-app -n devops-week4
```

Upgrade with

```bash
helm upgrade week3-release ./week3-app -n devops-week4
```

Rollback

```bash
helm rollback week3-release 1
```
