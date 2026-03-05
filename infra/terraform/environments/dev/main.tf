


module "vpc" {
  source          = "../../modules/vpc"
  project_name    = var.project_name
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  vpc_cidr        = var.vpc_cidr

}
# module "security" {
#   source       = "../../modules/security"
#   project_name = var.project_name
#   vpc_id       = module.vpc.vpc_id
#   my_ip        = module.ec2.app_server_ip

# }
module "ec2" {
  source            = "../../modules/ec2"
  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  subnet_id_private = module.vpc.subnet_id_private
  key_name          = var.key_name
  vpc_id = module.vpc.vpc_id

}

module "s3" {
    source = "../../modules/s3"
  
}
