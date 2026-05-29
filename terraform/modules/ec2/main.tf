resource "aws_instance" "ec2" {
  ami             = "ami-0ebfd941bbafe70c6"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile = var.instance_profile

  tags = {
    Name = "tf-lab-01"
  }

  user_data = file("${path.module}/../../install_docker.sh")
}

resource "time_sleep" "wait_for_instance_setup" {
  depends_on      = [aws_instance.ec2]
  create_duration = "1m"
}

resource "aws_ssm_document" "deploy_app" {
  name          = "DeployApp"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy application"

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"

        inputs = {
          runCommand = [
            "set -e", 
            "mkdir -p /root/.ssh",
            "chmod 700 /root/.ssh",
            "aws ssm get-parameter --name /flaskapp/${var.env}/github/deploy_key --with-decryption --query Parameter.Value --output text > /root/.ssh/id_ed25519",
            "chmod 600 /root/.ssh/id_ed25519",
            "ssh-keyscan github.com >> /root/.ssh/known_hosts",
            "mkdir -p /opt/app",
            "cd /opt/app",
            
            "if [ ! -d /opt/app/.git ]; then git clone git@github.com:gustavobarrera1/practica-ta-01.git .; fi",
            "git pull origin main",
            
            "echo \"DB_HOST=$(aws ssm get-parameter --name /flaskapp/${var.env}/database/db_host --with-decryption --query Parameter.Value --output text)\" > .env",
            "echo \"DB_NAME=$(aws ssm get-parameter --name /flaskapp/${var.env}/database/db_name --with-decryption --query Parameter.Value --output text)\" >> .env",
            "echo \"DB_USERNAME=$(aws ssm get-parameter --name /flaskapp/${var.env}/database/db_username --with-decryption --query Parameter.Value --output text)\" >> .env",
            "echo \"DB_PASSWORD=$(aws ssm get-parameter --name /flaskapp/${var.env}/database/db_password --with-decryption --query Parameter.Value --output text)\" >> .env",
            
            "docker compose -f docker-compose-aws.yaml down || true",
            "docker compose -f docker-compose-aws.yaml up -d"
          ]
        }
      }
    ]
  })
  depends_on = [ aws_instance.ec2, time_sleep.wait_for_instance_setup ]
}

resource "aws_ssm_association" "deploy_app_assoc" {
  name = aws_ssm_document.deploy_app.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.ec2.id] 
  }

  
  depends_on = [ aws_ssm_document.deploy_app, time_sleep.wait_for_instance_setup ] 
}