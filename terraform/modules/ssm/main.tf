resource "aws_ssm_parameter" "secure_db_host" {
  name        = "/${var.app_name}/${var.env}/database/db_host"
  description = "Host de la base de datos"
  type        = "SecureString"
  value       = var.db_host         
  tier        = "Standard"

  key_id = var.kms_key_id

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_ssm_parameter" "secure_db_name" {
  name        = "/${var.app_name}/${var.env}/database/db_name"
  description = "Nombre de la base de datos"
  type        = "SecureString"
  value       = var.db_name         
  tier        = "Standard"

  key_id = var.kms_key_id

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_ssm_parameter" "secure_db_pass" {
  name        = "/${var.app_name}/${var.env}/database/db_password"
  description = "Contraseña cifrada de la base de datos"
  type        = "SecureString"
  value       = var.db_password         
  tier        = "Standard"

  key_id = var.kms_key_id

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_ssm_parameter" "secure_db_user" {
  name        = "/${var.app_name}/${var.env}/database/db_username"
  description = "Nombre de usuario cifrado de la base de datos"
  type        = "SecureString"
  value       = var.db_username         
  tier        = "Standard"

  key_id = var.kms_key_id
  
  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_ssm_parameter" "github_deploy_key" {
  name        = "/${var.app_name}/${var.env}/github/deploy_key"
  description = "SSH private deploy key"
  type        = "SecureString"
  #value       = file("${path.module}../../../keys/deploy_key")
  value       = var.github_deploy_key

  key_id = var.kms_key_id

  tags = {
    Environment = "${var.env}"
  }
}

