# Define the provider and region
provider "aws" {
  access_key = ""
  secret_key = ""
  # Replace with your desired AWS region
  region = "us-east-1"  
}

# Data source to retrieve an existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-01"  # Replace with the ID of your existing VPC
}

# Data source to retrieve an existing subnet
data "aws_subnet" "existing_subnet1" {
  # Replace with the ID of your existing subnet
  id = "subnet-0"  
}

# # Data source to retrieve an existing subnet
# data "aws_subnet" "existing_subnet2" {
#   # Replace with the ID of your existing subnet
#   id = "subnet-05"  
# }

# # Data source to retrieve an existing subnet
# data "aws_subnet" "existing_subnet3" {
#   # Replace with the ID of your existing subnet
#   id = "subnet-05"  
# }

# Data source to retrieve an existing security group
data "aws_security_group" "existing_sg" {
  # Replace with the name of your existing security group
  id = "sg-0"  
}

# Create the second EC2 instance in the existing subnet
resource "aws_instance" "instance1" {
  # Replace with your desired AMI ID
  ami           = "ami-0c"
  instance_type = "t2.micro"
  # Reference the existing subnet
  subnet_id     = data.aws_subnet.existing_subnet1.id  
  security_groups = [data.aws_security_group.existing_sg.id]
  # Replace with your SSH key pair name
  key_name      = ""
  # Specify the desired availability zone
  availability_zone = "us-east-1d"
  user_data = "${file("s_jenkins.sh")}"

  tags = {
    Name = "D7_Jenkins_EC2"
  }
}

# Create the second EC2 instance in the existing subnet
resource "aws_instance" "instance2" {
  # Replace with your desired AMI ID
  ami           = "ami-0c"
  instance_type = "t2.micro"
  # Reference the existing subnet
  subnet_id     = data.aws_subnet.existing_subnet1.id  
  security_groups = [data.aws_security_group.existing_sg.id]
  # Replace with your SSH key pair name
  key_name      = ""
  # Specify the desired availability zone
  availability_zone = "us-east-1d"
  user_data = "${file("s_docker.sh")}"

  tags = {
    Name = "D7_Docker_EC2"
  }
}

# Create the second EC2 instance in the existing subnet
resource "aws_instance" "instance3" {
  # Replace with your desired AMI ID
  ami           = "ami-0c"
  instance_type = "t2.micro"
  # Reference the existing subnet
  subnet_id     = data.aws_subnet.existing_subnet1.id  
  security_groups = [data.aws_security_group.existing_sg.id]
  # Replace with your SSH key pair name
  key_name      = ""
  # Specify the desired availability zone
  availability_zone = "us-east-1d"
  user_data = "${file("s_terraform.sh")}"

  tags = {
    Name = "D7_Agent_EC2"
  }
}