# module "vpc" {
#   source = "./vpc" # . means in the current project folder, there is a folder called 
#   # source = "C:\Users\TUNDE\Downloads\terraform-3-tier-infra\vpc"
# #   vpc_cidr_block = "172.0.0"  #You can change/overide the value
# #   tags = local.project_tags
# }

module "vpc" {
  source = "./vpc"
  tags   = local.project_tags #Calling the variable tags and overiding it with local tags
}

module "rds" {
  source          = "./rds"
  tags            = local.project_tags
  private_subnet1 = module.vpc.private_subnet1_id #Go to vpc module look for private subnet1 from output
  private_subnet2 = module.vpc.private_subnet2_id
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = "10.0.0.0/16" #Hard code this not in output

}

module "ec2" {
  source    = "./ec2"
  subnet_id = module.vpc.public_subnet1_id #passing public subnet 1 id from vpc module
  vpc_id    = module.vpc.vpc_id
  tags      = local.project_tags

}