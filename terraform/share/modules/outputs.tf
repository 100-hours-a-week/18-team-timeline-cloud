# VPC 관련 outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_cidr" {
  description = "VPC CIDR 블록"
  value       = var.vpc_cidr
}

output "igw_id" {
  description = "인터넷 게이트웨이 ID"
  value       = module.vpc.igw_id
}

output "public_route_table_id" {
  description = "퍼블릭 라우팅 테이블 ID"
  value       = module.vpc.public_route_table_id
}

# Subnet 관련 outputs
output "public_subnet_a_id" {
  description = "Public Subnet A ID"
  value       = module.subnet.public_subnet_a_id
}

output "public_subnet_c_id" {
  description = "Public Subnet C ID"
  value       = module.subnet.public_subnet_c_id
}

output "private_subnet_a_front_id" {
  description = "Private Subnet A Front ID"
  value       = module.subnet.private_subnet_a_front_id
}

output "private_subnet_c_front_id" {
  description = "Private Subnet C Front ID"
  value       = module.subnet.private_subnet_c_front_id
}

output "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  value       = module.subnet.private_subnet_a_back_id
}

output "private_subnet_c_back_id" {
  description = "Private Subnet C Back ID"
  value       = module.subnet.private_subnet_c_back_id
}

output "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  value       = module.subnet.private_subnet_a_db_id
}

output "private_subnet_c_db_id" {
  description = "Private Subnet C DB ID"
  value       = module.subnet.private_subnet_c_db_id
}

# NAT Gateway 관련 outputs
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.nat_gateway.nat_gateway_id
}

output "private_route_table_id" {
  description = "프라이빗 서브넷용 라우팅 테이블 ID"
  value       = module.nat_gateway.private_route_table_id
}

# Peering 관련 outputs
output "vpc_peering_id" {
  description = "VPC Peering Connection ID"
  value       = module.vpc_peering.vpc_peering_connection_id
} 