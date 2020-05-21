# Acklen-DevOps-Challenge
AcklenAvenue devops challenge using Terraform and Ansible for infrastructure and software provisioning.

### Application Versions used in this Project
Application  | Version
----------   | ------ 
Terraform    | v0.12.25
AWS Provider | v2.62.0

### Infrastructure Diagram
![Infrastructure Diagram](/diagram.png)

### Setup to run project:
1. Set desired variables in the variables.tf file (make sure to add an existing key pair name if you want to ssh into your instances). Default region and availability zones are set in North Virginia (us-east-1).
2. Install Terraform: Version in this project is an executable file that has to be added to the $PATH to run from command line/terminal. See version in the beginning of this README.
3. Create an IAM user in AWS with the privilege of **AmazonEC2FullAccess**
   else the services used are: 
   * EC2
   * EBS
   * Load Balancing
   * Auto Scaling
   * VPC
   * Security Groups
   * Cloudwatch
4. Get the user **ACCESS_KEY_ID** and the **ACCESS_KEY_SECRET** and set them as environment variables with the following style for terraform to recognize them:
   
    Name                  | Value
    --------------------  | -----
    AWS_ACCESS_KEY        | Your access key id
    AWS_SECRET_ACCESS_KEY | Your access key secret

    Alternatively however **not recommended** you can attach them to the provider.tf file in the following way:
    ```
    provider "aws" {
    region     = var.REGION
    access_key = "my-access-key"
    secret_key = "my-secret-key"
    }

    ```

5. After downloading this repo, run the next commands: 
   ```
   terraform init
   terraform apply
   ```
   Type __*yes*__ when prompted to apply the plan generated by terraform
   so the backend can init
6. When terraform finishes it should output the public DNS of the Load Balancer created, which is where you can visit the Chat Application! Copy paste it into your browser to view the app running.

### Notes:
A level of *stickiness* is handled to keep the user in a single instance, meaning requests will go to the same machine for the duration of a session which is a day in this case (you can delete this cookie or enter the dns with incognito or another device to test the other running instance(s)).

   

   
   


  
