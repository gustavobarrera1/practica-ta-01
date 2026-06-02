resource "aws_kms_key" "ssm" {
  description         = "SSM key"
  enable_key_rotation = true

  tags = {
    Service = "${var.app_name}"
    Env     = "${var.env}"
  }
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/${var.app_name}-${var.env}"
  target_key_id = aws_kms_key.ssm.key_id
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.app_name}-${var.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ssm_policy" {
  name = "${var.app_name}-${var.env}-ssm-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",          
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:us-east-1:058222268637:parameter/${var.app_name}/${var.env}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}