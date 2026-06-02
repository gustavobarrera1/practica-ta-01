variable "db_host" {
  type        = string
  sensitive   = true 
}

variable "db_name" {
  type        = string
  sensitive   = true 
}


variable "db_password" {
  type        = string
  sensitive   = true 
}

variable "db_username" {
  type        = string
  sensitive   = true 
}

variable "github_deploy_key" {
  type        = string
  sensitive   = true
}

variable "env" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "app_name" {
  type = string
}