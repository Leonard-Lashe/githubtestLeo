resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_iam_role" "example" {
  name               = "ec2vpc_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Action": [
        "ec2:CreateVpc",
        "ec2:DeleteVpc"
    ],
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}
  
  inline_policy {
    name   = "policy-8675309"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions   = ["ec2:DescribeAccountAttributes"]
    resources = ["*"]
  }
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

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

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

