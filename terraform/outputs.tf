output "small_instance_ip" {
  description = "Public IP of small EC2"
  value       = aws_instance.small_instance.public_ip
}

output "large_instance_ip" {
  description = "Public IP of large EC2"
  value       = aws_instance.large_instance.public_ip
}
