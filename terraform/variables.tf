variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "small_instance_type" {
  description = "Small EC2 instance type"
  type        = string
}

variable "large_instance_type" {
  description = "Large EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
