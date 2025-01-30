output "vpc_id" {
  value       = concat(aws_vpc.app-vpc.*.id, [""])[0]
  description = "VPC id"
}

output "aws_public_subnet_id_1" {
  value       = aws_subnet.public[0].id
  description = "Public subnet id"
}

output "aws_public_subnet_id_2" {
  value       = aws_subnet.public[1].id
  description = "Public subnet id"
}