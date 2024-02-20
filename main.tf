provider "aws" {
  region="ap-south-1"
  access_key= var.A-key
  secret_key=var.S-key
}

resource "aws_vpc" "My-VPC" {
    cidr_block = var.vpc-cidr
        tags = {
            Name = "My-VPC"
            }
}

resource "aws_subnet" "subnetA-pub" {
    vpc_id = "${aws_vpc.My-VPC.id}"
    cidr_block = var.subA-cidr
    availability_zone= var.zoneA
        tags = {
             Name = "public-subnet"
             }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = "${aws_vpc.My-VPC.id}"
    tags = {
        Name = "IGW"
    }
}

resource "aws_route_table" "My-RT-Pub" {
  vpc_id = aws_vpc.My-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "My-RT-Pub"
  }
}

resource "aws_route_table_association" "My-RT-Assoc-Pub" {
  subnet_id      = aws_subnet.subnetA-pub.id
  route_table_id = aws_route_table.My-RT-Pub.id
}


resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = "${aws_vpc.My-VPC.id}"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "public_instance-A" {
ami= var.ami
instance_type= var.instance_type
key_name="mumbai"
subnet_id="${aws_subnet.subnetA-pub.id}"
tags = {
  Name = "pub-zoneA"
}
connection {
    type        = "ssh"
    user        = "root"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

 provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum install httpd -y",  
      "sudo service httpd start",  
      "sudo yum install git -y ",
      "mkdir /mnt/git && git init && git clone "  
    ]
  }
  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "index.html"  # Replace with the path to your local file
    destination = "/var/www/html/"  # Replace with the path on the remote instance
  }

 
}

