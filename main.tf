resource "aws_vpc" "leo-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_vpc" "leoprivate-vpc" {
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
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
subnet_id = aws_subnet.main.id
  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : main.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "leo"
  password             = "openme"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
 
}
