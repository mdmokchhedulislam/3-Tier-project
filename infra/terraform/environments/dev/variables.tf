variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "env" {
  type = string
}
variable "aws_region" {
  type = string
}



variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}


variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}
