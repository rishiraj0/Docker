# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "web" {
  ami            = "ami-03a6eaae9938c858c" #for linux
  instance_type  = "t2.micro"
  security_groups = [aws_security_group.TF_SG.id]
  subnet_id = aws_subnet.PublicSubnet.id

  tags = {
    Name = "HelloWorld"
  }

  user_data = file("script.sh")
}

resource "aws_security_group" "TF_SG" {
  name        = "security group using terraform"
  description = "security group using terraform"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    description      = "CUSTOM"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "TF_SG"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyTerraformVPC"
  }
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id  = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "PublicRTassociation" {
   subnet_id = aws_subnet.PublicSubnet.id
   route_table_id = aws_route_table.PublicRT.id
}

output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}