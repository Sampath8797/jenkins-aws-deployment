output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1" {
  value = aws_subnet.public[0].id
}

output "public_subnet_2" {
  value = aws_subnet.public[1].id
}

output "private_subnet_1" {
  value = aws_subnet.private[0].id
}

output "private_subnet_2" {
  value = aws_subnet.private[1].id
}

output "db_subnet_1" {
  value = aws_subnet.db[0].id
}

output "db_subnet_2" {
  value = aws_subnet.db[1].id
}

output "internet_gateway" {
  value = aws_internet_gateway.gw.id
}

output "eip" {
  value = aws_eip.gw.id
}

output "nat_gateway" {
  value = aws_nat_gateway.gw.id
}

output "public_route_table_1" {
  value = aws_route_table.public[0].id
}

output "public_route_table_2" {
  value = aws_route_table.public[1].id
}

output "private_route_table_1" {
  value = aws_route_table.private[0].id
}

output "private_route_table_2" {
  value = aws_route_table.private[1].id
}

output "db_route_table_1" {
  value = aws_route_table.db[0].id
}

output "db_route_table_2" {
  value = aws_route_table.db[1].id
}
