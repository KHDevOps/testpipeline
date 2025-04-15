# EKS Scalable DevOps Platform

This project provides a scalable DevOps platform deployed on Amazon EKS. The platform includes Kubernetes cluster provisioning with Terraform, CI/CD pipeline setup with Jenkins, and monitoring with Prometheus and Grafana.

**Note: This project is still under active development. The README and documentation may not reflect the most current state of the project.**

## Project Overview

This DevOps platform allows:

1. Automated infrastructure deployment using Terraform
2. Container orchestration with Kubernetes
3. Continuous integration and deployment using Jenkins
4. Monitoring with Prometheus and Grafana

## Architecture Overview

A high-level overview of the architecture:

- **Amazon EKS** hosts the Kubernetes cluster
- **Terraform** manages the AWS infrastructure
- **ArgoCD** handles GitOps-style deployments
- **Jenkins** provides CI/CD pipeline capabilities
- **Prometheus & Grafana** enable monitoring and visualization

## Project Structure

```bash
.
├── ansible
│   ├── group_vars
│   │   └── dev
│   ├── inventory
│   │   ├── dev
│   │   ├── prod
│   │   └── staging
│   ├── playbooks
│   └── roles
│       └── argocd
│           ├── defaults
│           ├── tasks
│           └── templates
├── ci-cd
│   └── argocd
│       └── applications
│           ├── dev
│           ├── prod
│           └── staging
├── demo-app
│   └── src
├── helm-charts
│   ├── base
│   │   ├── jenkins
│   │   │   └── templates
│   │   │       └── tests
│   │   └── prometheus
│   │       ├── charts
│   │       │   ├── crds
│   │       │   │   ├── crds
│   │       │   │   ├── files
│   │       │   │   └── templates
│   │       │   │       └── upgrade
│   │       │   ├── grafana
│   │       │   │   ├── ci
│   │       │   │   ├── dashboards
│   │       │   │   └── templates
│   │       │   │       └── tests
│   │       │   ├── kube-state-metrics
│   │       │   │   └── templates
│   │       │   ├── prometheus-node-exporter
│   │       │   │   └── templates
│   │       │   └── prometheus-windows-exporter
│   │       │       └── templates
│   │       └── templates
│   │           ├── alertmanager
│   │           ├── exporters
│   │           │   ├── core-dns
│   │           │   ├── kube-api-server
│   │           │   ├── kube-controller-manager
│   │           │   ├── kube-dns
│   │           │   ├── kube-etcd
│   │           │   ├── kube-proxy
│   │           │   ├── kube-scheduler
│   │           │   └── kubelet
│   │           ├── grafana
│   │           │   └── dashboards-1.14
│   │           ├── prometheus
│   │           │   └── rules-1.14
│   │           ├── prometheus-operator
│   │           │   └── admission-webhooks
│   │           │       ├── deployment
│   │           │       └── job-patch
│   │           └── thanos-ruler
│   ├── demo-app
│   │   ├── templates
│   │   └── values
│   │       ├── dev
│   │       ├── prod
│   │       └── staging
│   └── overlays
│       ├── dev
│       │   ├── grafana
│       │   ├── jenkins
│       │   └── prometheus
│       ├── prod
│       └── staging
├── kubernetes
│   ├── base
│   │   ├── monitoring
│   │   │   ├── grafana
│   │   │   └── prometheus
│   │   ├── networking
│   │   └── security
│   └── overlays
│       ├── dev
│       │   └── monitoring
│       │       └── prometheus
│       ├── prod
│       └── staging
└── terraform
    ├── environnements
    │   ├── dev
    │   ├── prod
    │   └── staging
    └── modules
        ├── compute
        ├── eks
        ├── iam
        ├── network
        └── security
```

## Prerequisites

- **Amazon Web Services**** account with billing enabled
- **AWS CLI** installed and configured
- **Terraform** installed on your machine
- **Kubernetes** CLI (kubectl) installed
- **Helm** installed for managing Kubernetes applications
- **Ansible** installed for configuration management
- **minikube** for local development (optional)

## Setup Instructions

### Step 1: Clone the repository

```bash
git clone git@github.com:Leomendoza13/eks-scalable-devops-platform.git
cd eks-scalable-devops-platform
```

### Step 2: Configure AWS CLI

1. Install AWS CLI if it's not already installed.
2. Authenticate with AWS:

```bash
aws configure
```

Enter your AWS credentials when prompted.

### Step 3: Deploy Infrastructure with Terraform

1. Navigate to the development environment directory:

```bash
cd terraform/environnements/dev
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the deployment plan:

```bash
terraform plan
```

4. Apply the configuration:

```bash
terraform apply
```

5. Confirm by typing yes when prompted.

The EKS cluster deployment will take approximately 10-15 minutes.

### Step 4: Configure Kubernetes Access

After the EKS cluster is deployed, configure kubectl to connect to it:

```bash
aws eks update-kubeconfig --region eu-west-3 --name eks-cluster-dev
```

Verify the connection:

```bash
kubectl get nodes
```

### Step 5: Install ArgoCD

Use Ansible to install ArgoCD:

```bash
cd ansible
ansible-playbook playbooks/env-setup.yml -e environment=dev
ansible-playbook playbooks/install-argocd.yml
```

It will install all we need in the cluster.

### Step 6: Deploy Jenkins and Prometheus

The ArgoCD applications for Jenkins and Prometheus are automatically deployed by ArgoCD.
To check their status:

```bash
kubectl get applications -n argocd
```

### Clean Up

When you're done, you can destroy the infrastructure to avoid unnecessary costs:

```bash
cd terraform/environnements/dev
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Author

Developed by Léo Mendoza. Feel free to reach out for questions, contributions, or feedback at leo.mendoza.pro@gmail.com