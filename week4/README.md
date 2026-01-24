In this phase, I deployed a containerised application into a Kubernetes cluster using Minikube.
I created Kubernetes Deployments and Services to manage application replicas and expose the application internally.
The application was first deployed using raw Kubernetes manifests and later packaged using Helm to introduce templating and versioned deployments.
This setup establishes the foundation for GitOps-based delivery in later stages.
