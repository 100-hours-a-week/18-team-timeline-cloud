# resource "aws_subnet" "private_a" {
#     vpc_id            = var.vpc_id
#     cidr_block        = var.private_subnet_cidr
#     availability_zone = var.az
    
#     tags = {
#         Name = "private-subnet_a"
#     }
  
# }