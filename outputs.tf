output "aws_instance_public_dns" {
    value = aws_instance.aws_ir_docker.public_dns
}