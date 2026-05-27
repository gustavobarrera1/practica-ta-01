output "kms_key_id" {
  value = aws_kms_key.ssm.id
}

output "kms_key_arn" {
  value = aws_kms_key.ssm.arn
}

output "instance_profile" {
  value = aws_iam_instance_profile.profile.name
}