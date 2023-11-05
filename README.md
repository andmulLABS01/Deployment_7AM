<h1 align="center">Deploy ECS infrastructure using Terraform and Jenkins agents<h1> 


# Deployment 
November 5th, 2023

By: Andrew Mullen

## Purpose:

Purpose:
Demonstrate our ability to deploy ECS infrastructure using Terraform.  First, deploy a Jenkins infrastructure with a Main, Docker, and 
Agent server.  Also, utilize Jenkins agents to use Terraform and Docker to deploy the Banking Flask application to ECS.


## Steps:

### 1. Create a dockerfile of the Banking App and place it into your repository (Make sure you use the banking app connected to the RDS database) Docker [file](https://github.com/andmulLABS01/Deployment_7AM/blob/main/dockerfile)
- You will need to modify the database.py, app.py, and load_data.py files to point them to the RDS database.
- If you are using an existing RDS database that has the data loaded from load_data.py, you will not need to run load_data.py in your dockerfile.

### 2. Change the following resources' name tags or name values below: (these changes can be done in step 3d)
```
main.tf:
- #Cluster name: Bank007-cluster
- #Task Definition:
    - Family:Bank007-task
- container_definitions:
    - name: Bank007-container
    - image: mullencsllc/bankapp007:latest
    - containerPort: 8000
- execution_role_arn: arn::/ecs_task
- task_role_arn: arn::/ecs_task
- #ECS Service
    - name: Bank007-ecs-service
-#Load_Balnancer
    - container_name: Bank007-container"
    - container_port: 8000

ALB.tf
- #Traget Group
   - name: Bank007-app
   - port: 8000
- #Application Load Balancer
   - name: Bank007-lb
```

### 3. Use Terraform to create 3 instances in your default VPC for a Jenkins manager and agents architecture (see below for more information) Terraform [file](https://github.com/andmulLABS01/Deployment_7AM/blob/main/jenkins_main.tf)
Instance 1:
- Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_7AM/blob/main/s_jenkins.sh)
- Create the Jenkins Agents
  - awsDeploy
  - awsDeploy2
- Configure AWS credentials in Jenkins.
- Configure DockerHub credentials in Jenkins.
  - You will need to go into DockerHub and generate an Access Token to put into Jenkins global credentials
  - When you enter in your username and password, in the ID section, enter {your-username}-dockerhub EXAMPLE: MRanderson-dockerhub
- Install the Docker Pipeline plugin on Jenkins
Instance 2:
- Docker, default-jre, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_7AM/blob/main/s_docker.sh)
Instance 3:
- Terraform and default-jre
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_7AM/blob/main/s_terraform.sh)

#### 3a. Clone the Kura repository to our Jenkins instance and push it to the new repository
	- Create a new repository on GitHub
	- Clone the Kura Deployment 7 repository to the local instance
		- Clone using `git clone` command and the URL of the repository
			- This will copy the files to the local instance 
		- Enter the following to gain access to GitHub repository
			- `git config --global user.name username`
			- `git config --global user.email email@address`
		- Next, you will push the files from the local instance to the new repository (Done from the local instance via the command line)
			- `git push`
			- enter GitHub username
			- enter personal token (GitHub requires this as it is more secure)
			
#### 3b. Create the Jenkins agents on the second and third instances. Follow the steps in this link to create a Jenkins agent: [link](https://scribehow.com/shared/Step-by-step_Guide_Creating_an_Agent_in_Jenkins__xeyUT01pSAiWXC3qN42q5w)
- This is the step where we will configure and later utilize Jenkins Agents to deploy the infrastructure and ECS.
- Repeat to configure the second agent.

#### 3c. Follow the steps in this link to configure AWS and DockerHub credentials in Jenkins: [link](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)  
- This is the step where we will configure our AWS secret keys in Jenkins to later be utilized by our Jenkins Agent to deploy the Banking application.
- Repeat to configure DockerHub credentials and replace the ASW steps with username and password.
					

#### 3d. Branch, update, and merge the following: MySQL endpoints, if [creating](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw) a new RDS database, changes to the endpoints for the database.py, load_data.py, app.py, and edits to the main.tf, ALB.tf, and the jenkinsfile in your repository.   	![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/format.png)  

	- Create a new branch in your repository
		- `git branch newbranchName`
	- Switch to the new branch and edit the database.py, load_data.py, app.py, and Jenkinsfile files.
		- `git switch newbranchName`
		- The red, blue, and green areas of the DATABASE_URL you'll need to edit
  		- Jenkinsfile DockerHub username on line 4.
    		- Jenkinsfile lines 31 and 42 with your image name.
      		- main.tf changes from step 2
		- ALB.tf changes from step 2
	- After modifying the files commit the changes
		- `git add "filename"`
		- `git commit -m "message"`
	- Merge the changes into the main branch
		- `git switch main`
		- `git merge second main`
	- Push the updates to your repository
		- `git push`

		
### 4. Observe the VPC.tf file and make sure the below resources are being created: 
    - 2 AZ's
    - 2 Public Subnets
    - 2 Private Subnets
    - 1 NAT Gateway
    - 2 Route Table
    - Security Group Ports: 8000
    - Security Group Ports: 80   
- We are observing to see how to draw our system diagram, gaining an understanding of how our infrastructure is created and how network traffic is routed from the User to the ECS hosting our banking application.

### 5. Observe the Terraform resources in the main.tf and ALB.tf:
```
- aws_ecs_cluster
  - Creates our cluster which is a logical grouping of tasks or services.
- aws_cloudwatch_log_group
  - Monitors our ECS bank app logs
- aws_ecs_task_definition
  - Defines our container and pull our image from DockerHub
- aws_ecs_service
  - Runs and maintains 2 instances of our task definitions.
- aws_lb_target_group
  - The tasks created in our ECS to run our bank app image
- aws_alb
  - In security group HTTP, created in VPC.tf
  - Balancing traffic between both Public Subnets a & b
- aws_alb_listener
  - Listening on port 80 for traffic
  - Forwarding traffic to our target group (our ECS container)
``` 
   
	
### 6. Create a Jenkins multibranch pipeline and run the Jenkinsfile
- Jenkins is the main tool used in this deployment for pulling the program from the GitHub repository, and then building and testing the files to be deployed to instances.
- Creating a multibranch pipeline gives the ability to implement different Jenkinsfiles for different branches of the same project.
- A Jenkinsfile is used by Jenkins to list out the steps to be taken in the deployment pipeline.
- A Jenkins agent is a machine or container that connects to a Jenkins controller and executes tasks when directed by the controller. 
- Agents utilize labels to know what commands to execute in the jenkinsfile. 
- The Build, Test, Login, and Push stages are using agent awsDeploy2 (Docker), while Init, Plan, and Apply are using agent awsDeploy (Terraform).
  
- Steps in the Jenkinsfile are as follows:
  - Build
    - Uses the dockerfile to build the image.
  - Test
    - Unit test is performed to test specific functions in the application.
  - Login
    - Uses credentials to log into DockerHub.
  - Push
    - Pushes the image to DockerHub.
  - Init
    - Runs the Init command to activate the Terraform process.
  - Plan
    - Runs the Plan command in Terraform to map out the main.tf, ALB.tf, vpc.tf, and variables.tf requirements. 	
  - Apply
    - Runs the Apply command in Terraform to deploy the AWS infrastructure.
  - Destroy
    - Runs the Destroy command in Terraform to delete the AWS infrastructure.  


### 7. Check your infrastructures and applications
- Here are the screenshot of the application. 
  - [App](https://github.com/andmulLABS01/Deployment_7AM/blob/main/DP7-app_running.PNG)

- Here are the screenshot of the infrastructure. 
  - [Infra](https://github.com/andmulLABS01/Deployment_7AM/blob/main/DP7-infrastructure.PNG)
	
### 8. Is your infrastructure secure? if yes or no, why?. 
- Yes our infrastructure is secure because we have our application cluster in a private subnet, a security group around our cluster, and a security group applied to our load balancer. 


### 9. What happens when you terminate 1 instance? Is this infrastructure fault-tolerant?

- When we terminate one instance our ecs_service spins up another instance.  Yes, this infrastructure is fault-tolerant to an extent. While we have ecs_service configured, if the entire region were to fail so would our clusters.

### 10. Which subnet were the containers deployed in?
- The containers were deployed in the private subnet of [subnet a and b](https://github.com/andmulLABS01/Deployment_7AM/blob/main/DP7-cont_subnets.PNG)

## System Diagram:

To view the diagram of the system design/deployment pipeline, click [HERE](https://github.com/andmulLABS01/Deployment_7AM/blob/main/Deployment_7.drawio.png)

## Issues/Troubleshooting:

Jenkinsfile unexpected character #.

Resolution Steps:
- I used the wrong comment out character.  Changes from `#` to `//` and resolved the issue. 

Build Stage Failed: Permission denied cannot connect to docker daemonTesting deployment of the application using the user data script not working.

Resolution Steps:
- Configured the wrong credentials in Jenkis for DockerHub.  Entered the correct credentials.
- Added Ubuntu user to the Docker user group.

Waiting for the next available executioner on Jenkins (agent awsDeploy2).

Resolution Steps:
- Reviewed the settings for the jenkins agent, and realized that I configured the wrong label ID.
- Changed the label id from `awsDeploy` to `awsDeploy2`.

Module Not Found error: No module named 'MySQLdb' when building the docker image.

Resolution Steps:
- Reviewed the docker file and needed to add `pip install mysqlclinet` to resolve the issue. 


## Conclusion:

As stated in previous documentation this deployment was improved by automating the setup of infrastructure by using Terraform, utilizing docker and implementing ECS for our applications, and adding an application load balancer.  However, additional improvements can be made by adding Route 53 and an API Gateway.
