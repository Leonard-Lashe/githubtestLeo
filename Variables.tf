variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "subnet_prefix" {
  description = "cidr block of subnet"
  default     = "10.0.1.0/24"
}
