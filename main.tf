resource "aws_vpc" "leo-vpc" {
  cidr_block = "10.0.0.0/16"
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
