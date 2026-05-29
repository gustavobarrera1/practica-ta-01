module "security" {
  source = "./modules/security"
  env    = var.env
}

module "ssm" {
  source = "./modules/ssm"

  db_host     = var.db_host
  db_name     = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  env         = var.env
  github_deploy_key = var.github_deploy_key
  kms_key_id  = module.security.kms_key_id
}

module "sg" {
  source = "./modules/sg"
}

module "ec2" {
  source = "./modules/ec2"

  env = var.env

  security_group_id = module.sg.security_group_id

  instance_profile = module.security.instance_profile

  depends_on = [module.sg]
}

