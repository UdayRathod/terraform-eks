# 🌍 Wanderlust Travel App on Amazon EKS

Wanderlust is a containerized Flask-based travel booking application deployed on an AWS Elastic Kubernetes Service (EKS) cluster using Terraform infrastructure-as-code. It showcases cloud-native best practices such as autoscaling, GitOps, observability, and secure image management.

---

## 🚀 Features

- 🎯 Deployed on Amazon EKS using Terraform
- 🐳 Containerized with multi-stage Docker builds (distroless for minimal size)
- ⚖️ Horizontal Pod Autoscaler (HPA)
- 📈 Metrics Server for resource metrics
- 🔁 Cluster Autoscaler for dynamic node provisioning
- 🌐 ALB Ingress Controller for traffic routing
- 🔐 Secrets and ConfigMaps for sensitive configuration
- 🧾 Resource Quotas and Limit Ranges per namespace
- 📊 Monitoring with Prometheus and Grafana
- 🚀 Argo CD for GitOps-based deployment
- 🔄 GitHub Actions CI/CD for Docker image builds and deployment automation

---

## 📦 Tech Stack

- **Backend**: Flask (Python)
- **Containerization**: Docker (multi-stage, distroless)
- **Orchestration**: Kubernetes on Amazon EKS
- **Infrastructure**: Terraform (IaC)
- **Monitoring**: Prometheus + Grafana
- **Ingress**: AWS ALB Ingress Controller
- **Autoscaling**: HPA + Cluster Autoscaler
- **Gitops** : Argo-CD
- **CI/CD** : GitHub Actions
- **Image Registry** : DockerHub

---

## 🏗️ Infrastructure Overview

- **Namespace**: `wanderlust-namespace`
- **Deployment**: `wanderlust-deployment`
- **Replicas**: Defined in `Deployment`, autoscaled by HPA
- **HPA**: Scales based on CPU utilization
- **Cluster Autoscaler**: Scales EKS Managed Node Groups
- **Ingress**: AWS Application Load Balancer via Ingress Manifest
- **Monitoring**: 
- **Prometheus**: Scrapes metrics
- **Grafana**: Visualizes metrics
- **Argo-CD** : As a single source truth to deliver our applications & infrastructure.
---

## 📁 Directory Structure

```
terraform-eks-cluster/
├── aws-ingress-controller.tf
├── cluster-autoscaler.tf
├── eks.tf
├── eks-metrics-server.tf
├── prometheus-grafana.tf
├── argo-cd.tf
├── locals.tf
├── outputs.tf
├── provider.tf
├── security-grp.tf
├── variables.tf
├── vpc.tf
├── docker
│   ├── Dockerfile
│   ├── static
│   ├── templates
│   ├── app.py
│   ├── requirements.txt
├── .github/workflows
│   ├── main.yml
├── k8-manifests/
│   ├── deployment.yml
│   ├── hpa.yml
│   ├── ingress.yml
│   ├── namespace.yml
│   ├── secret.yml
│   ├── resource-quota.yml
│   ├── argo-cd.yml
    └── service.yml
```



## 🛠️ EKS Cluster Setup Instructions

1) Install AWS CLI:
   As the first step, you need to install AWS CLI as we will use the AWS CLI (aws configure) command to connect Terraform with AWS in the next steps.
   Follow the below link to Install AWS CLI.
  
   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


2) Install Terraform:
   Next, Install Terraform using the below link.

   https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

3) Connect Terraform with AWS:
   Its very easy to connect Terraform with AWS. Run aws configure command and provide the AWS Security credentials.



### 1. Clone the Repository

```bash
git clone https://github.com/UdayRathod/terraform-eks.git
cd terraform-eks
```

### 2.Update with your IAM role/user arn
Just update the Access entry paramter in EKS code with your IAM user/role arn which need cluster admin access.

### 3. Initialize Terraform by command: terraform init
Clone the repository and Run terraform init. This will intialize the terraform environment for you and download the modules, providers and other configuration required.

### 4.Review the Terraform configuration by command: 
```bash
terraform fmt & terraform validate
```

### 5.Run terraform plan to see the configuration it creates when executed: by command: 
```bash
terraform plan
```

### 6.Finally, Apply terraform configuation to create EKS cluster with VPC with command: 
```bash
terraform apply
```


## 🛠️ CI/CD Pipeline (GitHub Actions)
This repo uses GitHub Actions to automate CI/CD. On every push to the main branch:

A Docker image is built using the codebase.
The image is pushed to DockerHub.
The deployment.yaml in k8-manifests/ is updated with the new image tag.
The updated manifest is committed back to main.

Argo CD automatically syncs the updated manifest to EKS.

## 🔐 Create your GitHub Secrets as below:
DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

## Update the below fields in main.yml for github actions:
EKS_CLUSTER_NAME

AWS_REGION

DOCKERHUB_REPO

💡 Note: Argo CD monitors the repo and applies updated manifests automatically (GitOps).

## 📈 Monitor via Prometheus & Grafana
Access Grafana via Ingress ALB

Promethues Dashboard URL:
http://<ALB-DNS>/prometheus:80


Grafana Dashboard URL:
http://<ALB-DNS>/grafana:80

Default login: admin
Password: I have variablized the grafana_admin_password and stored the value in terraform.tfvars which not committed to Git. 
You can create a terraform.tfvars file and the store the grafana password value.

Import Prometheus as a data source
Use pre-built Kubernetes dashboards(3662) or create custom ones.

Gitops Dashboard URL:
http://<ALB-DNS>/argocd:80

Default login: admin
Password: I have variablized the argocd_admin_password and stored the value in terraform.tfvars which not committed to Git. 
You can create a terraform.tfvars file and the store the argocd admin password value.
Note: The Argo CD admin password is securely set using a `bcrypt` hashed value, as Argo CD expects the argocdServerAdminPassword value to be a bcrypt-hashed password (not plaintext).
This is the command we used to generate the bcrypt hash: htpasswd -nbBC 10 "" "your-password" | tr -d ':\n'

## 👨‍💻 Author
Uday Rathod
GitHub: @UdayRathod


# Contributing
Contributions are welcome!
To contribute, please fork the repository, create a new branch for your feature or bugfix, and submit a pull request.
For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

# License
This project is licensed under the MIT License.