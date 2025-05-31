A repository to create EKS on AWS using Terraform.

Install AWS CLI
As the first step, you need to install AWS CLI as we will use the AWS CLI (aws configure) command to connect Terraform with AWS in the next steps.

Follow the below link to Install AWS CLI.

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
Install Terraform
Next, Install Terraform using the below link.

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
Connect Terraform with AWS
Its very easy to connect Terraform with AWS. Run aws configure command and provide the AWS Security credentials.

Just update the Access entry paramter in EKS code with your IAM user/role arn which need cluster admin access.

Initialize Terraform by command: terraform init
Clone the repository and Run terraform init. This will intialize the terraform environment for you and download the modules, providers and other configuration required.

Review the Terraform configuration by command: terraform fmt & terraform validate

Run terraform plan to see the configuration it creates when executed: by command: terraform plan

Finally, Apply terraform configuation to create EKS cluster with VPC with command: terraform apply