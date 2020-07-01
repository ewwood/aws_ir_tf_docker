# AWS Incident Response via Docker & Terraform
The purpose of this project is to deploy AWS Incident Response tools (AWS_IR & Margaritashotgun) with Docker and Terraform.
It will use AWS to launch a Debian Stretch EC2 instance with Docker installed along with a container running AWS_IR and Margaritashotgun. 
A security group with port 22 allowed inbound and outbound is created on terraform apply as well. This instance should be free for 12 months if done with AWS free tier.

### Notes
Terraform will drop this instance into your default AWS VPC and Subnet in us-east-1. For connectivity between instances make sure the launched instance is in the same region, availability zone and subnet as your compromised instance. 
 Region can be adjusted on line 2 of vars.tf, Availability Zone on line 9 of vars.tf and subnet on line 28 of main.tf. 

### Prerequisites
Install Terraform and Git. I suggest using chocolatey for Windows or homebrew for Mac. 

## Getting Started
1. Create AWS account
2. [Create IAM user](https://console.aws.amazon.com/iam/home)
   - Select Programmatic access for access type
   - Give the user 'AdministratorAccess' policy or create a Admin group with 'AdministratorAccess' and add that user to it.
   - After creating the user you will get the access key ID and secret access key. You will need these for our secret.tfvars file.
3. [Create a key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) called "ir-keys" and save subsequent ir-keys.pem to this project location. Possible restrictions creating key pair within EC2 dashboard for the first 24 hours of AWS account creation.

## Installation
1. Clone Repo and run terraform init.
   ```
   git clone https://github.com/ewwood/aws_ir_tf_docker.git
   cd ./aws_ir_tf_docker
   terraform init
   ```
2. Copy and edit secret.tfvars.example to secret.tfvars, input your IAM user key and secret and run the following:
   ```
   terraform plan -var-file='secret.tfvars'
   terraform apply -var-file='secret.tfvars' -auto-approve
   ```
3. Log into AWS by using the output value of 'aws_instance_public_dns'.
   ```
   ssh -i <key location> admin@<ec2 public dns entry>
   example:
   ssh -i ir-keys.pem admin@ec2-52-234-127-217.compute-1.amazonaws.com
   ```
4. Run docker ps to verify container is running. You should see a container with the name "ir" listed in the output.
   ```
   docker ps
   ```
5. Run docker attach to connect to the container.
   ```
   docker attach ir
   ```
6. Start using aws_ir / margaritashotgun
   ```
   margaritashotgun --<args>
   ``` 
   ```
   aws_ir --<args>
   ```

   
   
## Acknowledgments:
  - CushitRealGood (https://github.com/terraformed/terraform-docker)
