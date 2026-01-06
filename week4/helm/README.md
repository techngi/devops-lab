A Helm chart is a packaged, templated, and versioned way to deploy applications to Kubernetes.
If Kubernetes YAML is raw instructions, Helm charts are reusable deployment blueprints.

Create helm chart

```bash
helm create week3-app
```

Modify:
values.yaml
templates/deployment.yaml
templates/service.yaml

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
