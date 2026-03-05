output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}
output "subnet_id_private" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}