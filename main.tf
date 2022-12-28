provider "aws" {
  access_key = "XXXXXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXX"
  region  = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "Ajay_Devops" {
  cidr_block = "10.1.0.0/16"
}

# Create a Subnet
resource "aws_subnet" "Ajay_Subnet_01" {
  vpc_id     = aws_vpc.Ajay_Devops.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Ajay_Subnet_01"
  }
}
resource "aws_subnet" "Ajay_Subnet_02" {
  vpc_id     = aws_vpc.Ajay_Devops.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "Ajay_Subnet_02"
  }
}
resource "aws_subnet" "Ajay_Subnet_03" {
  vpc_id     = aws_vpc.Ajay_Devops.id
  cidr_block = "10.1.3.0/24"

  tags = {
    Name = "Ajay_Subnet_03"
  }
}

# Create a Internet Gateway
resource "aws_internet_gateway" "Ajay_IGW" {
  vpc_id = aws_vpc.Ajay_Devops.id

  tags = {
    Name = "Ajay_IGW"
  }
}

# Create a Route Table & Route Table Association witg IGW
resource "aws_route_table" "Ajay_RTB" {
  vpc_id = aws_vpc.Ajay_Devops.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Ajay_IGW.id
  }

   tags = {
    Name = "Ajay_RTB"
  }
}

# Route Table Association with Subnet
resource "aws_route_table_association" "RTB_Ajay_Subnet_01" {
  subnet_id      = aws_subnet.Ajay_Subnet_01.id
  route_table_id = aws_route_table.Ajay_RTB.id
}

resource "aws_route_table_association" "RTB_Ajay_Subnet_02" {
  subnet_id      = aws_subnet.Ajay_Subnet_02.id
  route_table_id = aws_route_table.Ajay_RTB.id
}

resource "aws_route_table_association" "RTB_Ajay_Subnet_03" {
  subnet_id      = aws_subnet.Ajay_Subnet_03.id
  route_table_id = aws_route_table.Ajay_RTB.id
}

# Create a Security Group
#ingress = Inbound Rules
#egress = Outbound rules
#We have to give Port that we want as from_port and to_port
#HTTP - Port - 80 - Protocol - TCP
#HTTPS - Port - 443 - Protocol - TCP
#SSH - Port - 22 - Protocol - TCP
#All traffic - Port - All - Protocol - All
#egress = Outbound rules
resource "aws_security_group" "Ajay_SG" {
  name        = "Ajay_SG"
  description = "Allow Inbound Rules"
  vpc_id = aws_vpc.Ajay_Devops.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.Ajay_Devops.cidr_block]
    
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.Ajay_Devops.cidr_block]
    
  }

 ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.Ajay_Devops.cidr_block]
    
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Ajay_SG"
  }
}

# Create a Key Pair
resource "aws_key_pair" "Ajay_Key_Pair" {
  key_name   = "Ajay_Key_Pair"
  public_key = tls_private_key.rsa.public_key_openssh 
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save Private Key in Local File
resource "local_file" "Ajay_Key_Pair" {
    content  =  tls_private_key.rsa.private_key_pem
    filename = "Ajay_Key_Pair"
}

resource "aws_instance" "Server" {
ami = "ami-0b0dcb5067f052a63"
#availability_zone = "us-east-1a"
instance_type = "t2.micro"
key_name = "Ajay_Key_Pair"
subnet_id = aws_subnet.Ajay_Subnet_01.id
vpc_security_group_ids = [aws_security_group.Ajay_SG.id]
associate_public_ip_address = true	
tags = {
Name = "Ansiable-Server"
Env = "Dev"
Owner = "Ajay"
}
}

resource "aws_instance" "Node-1" {
ami = "ami-0b0dcb5067f052a63"
#availability_zone = "us-east-1a"
instance_type = "t2.micro"
key_name = "Ajay_Key_Pair"
subnet_id = aws_subnet.Ajay_Subnet_02.id
vpc_security_group_ids = [aws_security_group.Ajay_SG.id]
associate_public_ip_address = true	
tags = {
Name = "Ansiable-Node-1"
Env = "Dev"
Owner = "Ajay"
}
}


resource "aws_instance" "Node-2" {
ami = "ami-0b0dcb5067f052a63"
#availability_zone = "us-east-1a"
instance_type = "t2.micro"
key_name = "Ajay_Key_Pair"
subnet_id = aws_subnet.Ajay_Subnet_03.id
vpc_security_group_ids = [aws_security_group.Ajay_SG.id]
associate_public_ip_address = true	
tags = {
Name = "Ansiable-Node-2"
Env = "Dev"
Owner = "Ajay"
}
}