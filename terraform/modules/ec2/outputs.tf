output "instancia_id" {
  value = aws_instance.ec2.id
}

output "instancia_ip" {
  value = aws_instance.ec2.public_ip
}