<h1 align="center">Deploy ECS infrastructure using Terraform and Jenkins agents<h1> 


# Deployment 
November 5th, 2023

By: Andrew Mullen

## Purpose:

Purpose:
Demonstrate our ability to deploy ECS infrastructure using Terraform.  First, deploy a Jenkins infrastructure with a Main, Docker, and 
Agent server.  Also, utilize Jenkins agents, to use Terraform and Docker to deploy the Banking Flask application to ECS.


## Steps:

### 1. Follow the naming convention below for all resources created in AWS:
```
VPC:
- deplpoyment#-vpc-region: 
	- deployment6-vpc-east
	- deployment6-vpc-west
Instances:
- Function#-region: 
	- applicationServer01-east
	- applicationServer02-east
	- applicationServer01-west
	- applicationServer02-west
Security Groups:
- purposeSG: 
	- US_East_1_HttpAcessSG
	- US_West_2_HttpAcessSG
Subnets:
- purposeSubnet#:
	- publicSubnet01
	- publicSubnet02
Load Balancer:
- purpose-region: 
	- ALB-east
	- ALB-west
```

### 2. Use Terraform to create 2 instances in your default VPC for a Jenkins manager and agent architecture with the following installed:  Terraform file [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
```
Instance 1: 
- Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
- Create the Jenkins Agent
- Configure AWS credentials in Jenkins.
  - [Instructions here](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)
- Place your Terraform files and user data script in the initTerraform directory.

Instance 2: 
- Terraform and default-jre
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
```

#### 2a. Clone the Kura repository to our Jenkins instance and push to new repository
	- Create new repository on GitHub
	- Clone the Kura Deployment 6 repository to the local instance
		- Clone using `git clone` command and the URL of the repository
			- This will copy the files to the local instance 
		- Enter the following to gain access into GitHub repository
			- `git config --global user.name username`
			- `git config --global user.email email@address`
		- Next you will push the files from the local instance to the new repository (Done from local instance via command line)
			- `git push`
			- enter GitHub username
			- enter perosnal token (GitHub requires this as it is more secure)
			
#### 2b. Create the Jenkins agent on the second instance
	- This is the step were we will configure and later utilize a Jenkins Agent to deploy the applicaiton infrastructe and the Banking applicaiton.
		- Follow the steps in this link to create a Jenkins agent: [link](https://scribehow.com/shared/Step-by-step_Guide_Creating_an_Agent_in_Jenkins__xeyUT01pSAiWXC3qN42q5w)

#### 2c. Configure your AWS credentials in Jenkins
	- This is the step were we will configure our AWS secret keys in Jenkins to be used in ourand later utilize a Jenkins Agent to deploy the Banking applicaiton.
		- Follow the steps in this link to create a Jenkins agent: [link](https://scribehow.com/shared/Step-by-step_Guide_Creating_an_Agent_in_Jenkins__xeyUT01pSAiWXC3qN42q5w)  			

#### 2d. Place your Terraform files and user data script in the initTerraform directory.
	- This is the location where your main.tf, variables.tf and user data script need to be in order for the jenkinsfile to access them to test the applicaiton and deploy the applicaiton infrastructe.
		- The link to the main.tf file [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)	
		- The link to the variables.tf file [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)		
		- The link to the deploy2.sh file [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)		
		
### 3. Create a two VPCs with Terraform, using the Jenkins agent, 1 VPC in US-east-1 and the other VPC in US-west-2. The following components MUST be in each VPC - 2 AZ's, 2 Public Subnets, 2 EC2's, 1 Route Table, Security Group Ports: 8000, 22
   - This process is to give us practice in using Terraform to create our AWS infrastructe.  
   - Also we will utilize Git to continue gaining experience in day-to-day operations of a DevOps engineer.
   - We will use Jenkins Agents to deploy our AWS applicaiton infrastructe and the Banking Flask applicaiton with the jenkinsfile on to the application instances. 

#### 3a. Create an RDS database
	- We are creating a RDS database to link our applicaiton databases together and create our 2nd tier.
		- Instructions to create the RDS database is [here](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw).
   
#### 3b. Branch, update, and merge the following MySQL endpoints changes to the endpoints for the database.py, load_data.py, and app.py in your repository.
	- Create a new branch in your repository
		- `git branch newbranchName`
	- Switch to the new branch and edit the database.py, load_data.py, and app.py files.
		- `git switch newbranchName`
		- The red, blue, and green areas of the DATABASE_URL you'll need to edit:
   ![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/format.png)Update 
	- After modifing the files commit the changes
		- `git add "filename"`
		- `git commit -m "message"`
	- Merge the changes into the main branch
		- `git switch main`
		- `git merge second main`
	- Push the updates to your repository
		- `git push`
		
### 6. Create a Jenkins multibranch pipeline and run the Jenkinsfile

- Jenkins is the main tool used in this deployment for pulling the program from the GitHub repository, then building and testing the files to be deployed to instances.
- Creating a multibranch pipeline gives the ability to implement different Jenkinsfiles for different branches of the same project.
- A Jenkinsfile is used by Jenkins to list out the steps to be taken in the deployment pipeline.
- A Jenkins agent is a machine or container that connects to a Jenkins controller and executes tasks when directed by the controller. 
- Agents utilize lables to know what commands to execute in the jenkinsfile. 

- Steps in the Jenkinsfile are as follows:
  - Build
    - The environment is built to see if the application can run.
  - Test
    - Unit test is performed to test specific functions in the application.
  - Init
	- Uses the Jenkins Agent to run the Init command activate the Terraform process.
  - Plan
    - Uses the Jenkins Agent to run the Plan command in Terraform to map out the main.tf requirements. 	
  - Apply
    - Uses the Jenkins Agent to run the Apply command in Terraform to deploy the AWS applicaiton infrastructe. 


### 7. Check your infrastructures and applications
	- Here are the screen shots of the applications. 
		-[East](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
		-[West](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)

	- Here are the screen shots of the infrastructes. 
		-[East](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
		-[West](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)
	
### 8. Create an application load balancer for US-east-1 and US-west-2. 
- Application load balancers ensure that application traffic is distribuited between our two instances so that one is not overly utilize and more available to users.
	-[Instructions here](https://scribehow.com/shared/Creating_Load_Balancer_with_Target_Groups_for_EC2_Instances__WjPUNqE4SLCpkcYRouPjjA)	

### 9. With both infrastructures deployed, is there anything else we should add to our infrastructure?

- I believe that we cauld add the following to to our infrastructes:
	- Reverse web porxy such as nginx.  
		- This will allow us to not have internet traffic directly access our applicaiton servers. 
		- Have an additional layer of protection from our database.
	- Private subnets
		- The will allow for us to place our applicaiton servers in a subnet that does not have direct access to the internet and allows foradditional network segmentation increace security.
	- NAT Gateway
		- Will allow our applications to reply back to users as they will be in a private subnet that does not have access to the internet.
	- API Gateway
		- To increase security of who/what can access our applicaiton
	- Network Load Balancer
		- To balance the network traffic recieved from the API Gateway to our Aapplicaiton servers. load balancer to balance traffic between the two application servers to make the application more available to users.


## System Diagram:

To view the diagram of the system design/deployment pipeline, click [HERE](https://github.com/andmulLABS01/Deployment_3AM/blob/main/Depoyment3.drawio.png)

## Issues/Troubleshooting:

AMI and Key Pair not working in Terraform when creating West-2 infrastructure.

Resolution Steps:
- AMI needed to be from the US West region, was using the AMI for the US East retion in my Terraform file.
- Needed to create a key pair for the US West region and use that in my Terraform file.


Testing deployment of applicaiton using the user data script not working.

Resolution Steps:
- Going through the user data script needed to add `source test/bin/activate` as the last line of the script to create reestablish the environment. If not, once the script is done running it will go back to the home shell.


Test phase not passing in the Jenkins build, Error unknown database.

Resolution Steps:
- Going through the documentation the error is associated to the wrong database name in the DATABASE_URL.  Looked at the name portion of the URL and fund the confiruration error `mydatabase` instead of `banking`.
- Changed the name and the Jenkins build completed.


Application load balancer test did not work.

Resolution Steps:
- Reviewed the documentation and found that I confgiured the new security group in the wrong VPC.
- Made the changes to the ALB, selecting the correct VPC, and added the security group and the test completed successfully.


## Conclusion:

As stated in previous documentation this deployment was improved by automating the setup of infrastructure by using Terraform.  
However, additional improvements can be made by changing how we utilize the Jenkins Agents.  For example we could have created two agents and modified the Jenkinsfile
to utilze one for testing and one for deployment of the applicaiton.  We can also utilize ChatGPT to assist with error messages and ask to explain options in Jenkinsfile. Utilizing prompts such as:

- You are a Jenkins pipeline expert
- Check the Jenkinsfile for errors
- Please explain the error, including the method to fix the error, and provide a link to documentation. 
