# Group5-ACS730-Final Project: Two-Tier web application automation with Terraform

The steps listed below can be used to use Terraform to deploy the project infrastructure.

Steps:
1. To Clone the github repo: "git clone https://github.com/OmGoswami-117/OmGoswami-117-ACS730-Web-App-Deployment.git"

2. Then we will create the key in .ssh folder in home/ec2-user (in show hidden files)
	ssh-keygen -t rsa -f group5-dev
	ssh-keygen -t rsa -f group5-staging
	ssh-keygen -t rsa -f group5-prod

3. In S3 Bucket:
   Create 3 Bucket: 
     a. group5-bucket-dev
	   b. group5-bucket-staging
	   c. group5-bucket-prod
   Create a New Bucket:
     images-bucket-group5
   And upload 2 images in it which we want on are webserver...

4. In terraform folder, we have to change the public and private ip of cloud9 instance in var file. 

In the AWS Management Console:
1. In dev environment:
terraform/network/dev-network
	terraform init
	terraform plan
	terraform apply --auto-approve

terraform/webservers/dev-webserver
	terraform init
	terraform plan
	terraform apply --auto-approve

  2. In staging environment:
terraform/network/staging-network
	terraform init
	terraform plan
	terraform apply --auto-approve

terraform/webservers/staging-webserver
	terraform init
	terraform plan
	terraform apply --auto-approve

   3. In prod environment
terraform/network/prod-network
	terraform init
	terraform plan
	terraform apply --auto-approve

terraform/webservers/prod-webserver
	terraform init
	terraform plan
	terraform apply --auto-approve

After this step, 
1. Check the EC2 Instances.
2. In the load balancer, take the public DNS and paste on the web browser, get the desired output.
3. Try to stop the on instance, instantly new instance will be created automatically. 
