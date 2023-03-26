variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.micro"
}

variable "subnet_cidr" {
  description = "cidr block of subnet"
  type        = list
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}
