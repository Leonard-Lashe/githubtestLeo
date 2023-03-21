resource "aws_vpc" "leovpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_vpc" "leoprivatevpc" {
  cidr_block = "172.168.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.leo-vpc.id
  cidr_block = var.subnet_cidr[0]

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "boris" {
  vpc_id     = aws_vpc.leo-vpc.id
  cidr_block = var.subnet_cidr[1]

  tags = {
    Name = "boris"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.leo-vpc.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.leo-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 443
    to_port   = 443
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
subnet_id = aws_subnet.main.id
  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_instance" "web2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
subnet_id = aws_subnet.main.id
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_s3_bucket" "Leo12bucket" {
  bucket = "my-tf-leo12-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
