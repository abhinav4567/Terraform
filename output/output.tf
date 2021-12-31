output "instance-ami" {
  value = aws_instance.Cloudnative.ami
}

output "instance-arn" {
  value = aws_instance.Cloudnative.arn
  sensitive = true
}

output "instance-all" {
  value = aws_instance.Cloudnative

}
