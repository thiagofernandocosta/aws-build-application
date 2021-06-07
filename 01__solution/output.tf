output "instance_private_ip_addr" {
  value       = aws_instance.web.private_ip
  description = "The private IP address of the main server instance."
}

output "instance_public_dns_addr" {
  value       = aws_instance.web.*.public_dns
  description = "The public DNS address of the main server instance."
}