# Acklen-DevOps-Challenge
AcklenAvenue devops challenge using Terraform and Ansible for infrastructure and software provisioning.
The application used in the project is the following: [Chat application using socket.io](https://github.com/RGaldamez/Chat-App-using-Socket.io)

### Application Versions used in this Project
Application  | Version
----------   | ------ 
Terraform    | v0.12.25
AWS Provider | v2.62.0


### Setup to run project:
1. Download this repository.
2. Set desired variables in the variables.tf file (make sure to add an existing key pair name if you want to ssh into your instances). Default region and availability zones are set in North Virginia (us-east-1).
3. Install Terraform: Version in this project is an executable file that has to be added to the $PATH to run from command line/terminal. See version in the beginning of this README. In Ubuntu the executable file was added to the /bin folder.
4. Create an IAM user in AWS with the privilege of **AmazonEC2FullAccess**
   ...or you can set the individual services: 
   * EC2
   * EBS
   * Load Balancing
   * Auto Scaling
   * VPC
   * Security Groups
   * Cloudwatch
5. Get the user **ACCESS_KEY_ID** and the **ACCESS_KEY_SECRET** and set them as environment variables with the following style for terraform to recognize them:
   
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

6. After downloading this repo, run the next commands: 
   ```
   terraform init
   terraform apply
   ```
   Type __*yes*__ when prompted to apply the plan generated by terraform, this will start generating the infrastructure in AWS.
7. When terraform finishes it should output the public DNS of the Load Balancer created, which is where you can visit the Chat Application! Copy paste it into your browser to view the app running.
8. Once you are done testing the application, you can let terraform destroy the infrastructure by using the next command and writing __*yes*__ when prompted:
   ```
   terraform destroy
   ```

### Notes:
* You should wait about 5-10 minutes before trying the DNS as **Ansible** is still setting up the application in the remote EC2 instances after Terraform finishes.
* A level of *stickiness* is handled to keep the user in a single instance, meaning requests will go to the same machine for the duration of a session which is **1 day** in this case (you can delete this cookie, enter the DNS with incognito or use another device to test the other running instance(s)).
* All the services used in this project fall under the [AWS Free Tier](https://aws.amazon.com/free/).


### Steps in the making

1. >Prepare the networking. With Terraform, you will do this.
Create a VPC with 2 public subnets in two different availability zones. If this is new to you, take some time to search for this, as you will need to understand this to continue with the challenge.

    ![Infrastructure Diagram](/diagram.png)
    * This Diagram was made to plan and structure the code to be written in ansible. You can check the creation of the VPC in the network.tf.
  
1. >Challenge
In case you want to show you rock with Terraform, instead of using EC2, create an autoscaling group. So we can have dynamic instances.

    * An autoscaling group was chosen over creating EC2 instances directly to learn a more practical use for Terraform.
    * Cloudwatch alarms were set up to monitor the CPU usage of all the instances, they will decide if to trigger the application load balancer policies which will start a new instance or terminate an instance.
    * The rules are the following: 
       * When the **average** CPU is greater or equal to 35%, a new instance will be launched if there are less than 4 instances running.
       * When the **average** CPU is lower or equal to 15% an instance will be terminated if there are more than 2 instances running.
    * The chosen metric to either scale instances up or down was the average CPU usage, the main purpose was to stress an instance to see the scaling group in action: 
    After using ssh to log into a random instance, the package **stress-ng** was installed to simulate CPU usage, a command used was the following:
        ```
        stress-ng -c 1 -l 80
        ```
        -c for number of CPUs and -l for load, in this case 80% of CPU available 
        you can learn more at [Ubuntu wiki: stress-ng](https://wiki.ubuntu.com/Kernel/Reference/stress-ng)
    
3. >You will need to create an application load balancer for this. The idea is that for accessing the application it has to be using the load balancer. For doing this you will need to use terraform

    * A load balancer was specially necessary here because the original application listens in the port 5000. Which means that to access the app in an instance you would need to use the IP or DNS plus ":5000", which is an undesirable scenario for the end user.
    *  No changes were made to the node application code to mantain consistency as DevOps and not a Developer.
    * The load balancer listens in the port 80 (HTTP) and forwards traffic to the port 5000 of the instances.

4. >When you have the infrastructure, you will need to install the application. You will need to install node in the EC2 you created in step 2 and configure the application. Remember the application will need to be up always. For doing this, you will need to run ansible for configuring everything.
   * An autoscaling group was used in this project, which would dynamically create instances depending on the launch configuration. Since the instaces are created dynamically, and there is no peering between the subnets, the localhost of each instance was used to run ansible.
   * _user_data_ in the launch configuration are commands that run **ONCE** after an instance is launched. A bash script was provided which internally holds the ansible playbook. The script outputs the internal ansible commands into a file, installs ansible and finally runs the ansible playbook which will handle the chat application installation and start it.

   
   


  
