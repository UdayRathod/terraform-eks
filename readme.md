# 🌍 Wanderlust Travel App on Amazon EKS

Wanderlust is a containerized Flask-based travel booking application deployed on an AWS Elastic Kubernetes Service (EKS) cluster using Terraform infrastructure-as-code. It showcases cloud-native best practices such as autoscaling, monitoring, and managed services.

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

---

## 📦 Tech Stack

- **Backend**: Flask (Python)
- **Containerization**: Docker (multi-stage, distroless)
- **Orchestration**: Kubernetes on Amazon EKS
- **Infrastructure**: Terraform (IaC)
- **Monitoring**: Prometheus + Grafana
- **Ingress**: AWS ALB Ingress Controller
- **Autoscaling**: HPA + Cluster Autoscaler

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

---

## 📁 Directory Structure


terraform-eks-cluster/
├── aws-ingress-controller.tf
├── cluster-autoscaler.tf
├── eks.tf
├── eks-metrics-server.tf
├── locals.tf
├── outputs.tf
├── provider.tf
├── security-grp.tf
├── variables.tf
├── vpc.tf
├── k8-manifests/
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── namespace.yaml
│   ├── secret.yaml
│   ├── resource-quota.yaml
│   └── service.yaml




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
terraform fmt & terraform validate

### 5.Run terraform plan to see the configuration it creates when executed: by command: 
terraform plan

### 6.Finally, Apply terraform configuation to create EKS cluster with VPC with command: 
terraform apply




## 🛠️ Deploy Kubernetes Manifests

### 1. Copy the manifests files to your k8 nodes by command:
git clone https://github.com/UdayRathod/terraform-eks/tree/eb770dd30bd5bc2838f1ebcaf0ed6962bc740d69/k8-manifests

### 2. Deploy the K8 resources:
kubectl apply -f k8-manifests/


## 📈 Monitor via Prometheus & Grafana
Access Grafana via LoadBalancer or Port Forward
Import Prometheus as a data source
Use pre-built Kubernetes dashboards or create custom ones

Grafana Dashboard URL:
http://<grafana-load-balancer>:3000
Default login: admin/admin


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