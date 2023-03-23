output "id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_network.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_network.*.id
  description = "List of private subnet IDs"
}

output "cidr_block" {
  value       = var.cidr_block
  description = "The CIDR block associated with the VPC"
}

output "nat_gateway_ips" {
  value       = aws_eip.eip.*.public_ip
  description = "List of Elastic IPs associated with NAT gateways"
}