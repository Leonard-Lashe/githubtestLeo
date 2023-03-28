resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
}
 
resource "aws_subnet" "leo" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr[0]

  tags = {
    Name = "leo"
  }
}

resource "aws_subnet" "boris" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr[1]

  tags = {
    Name = "boris"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

module "websg-group" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "4.17.1"
  name      = "websg_new"
  
   vpc_id = aws_vpc.main.id
  
  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
  
  
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
subnet_id = aws_subnet.leo.id
  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_instance" "web2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
subnet_id = aws_subnet.leo.id
  tags = {
    Name = "HelloWorld"
  }
}

