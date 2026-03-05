variable "project_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {
    type = list(string)
}
variable "key_name" {}

variable "vpc_id" {
    type = string
  
}
variable "subnet_id_private" {
  type = list(string)
  description = "List of private subnet IDs for ASG"
}