variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-2" # Sydney
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "devops-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "Availability Zone for public subnet"
  type        = string
  default     = "ap-southeast-2a"
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to SSH into instance"
  type        = string
  default     = "0.0.0.0/0" # lab only, not for prod
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}
