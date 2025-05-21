# VPC 설정
vpc_cidr_block = "10.0.0.0/16"

# 가용 영역
az_a = "ap-northeast-2a"
az_c = "ap-northeast-2c"

# 서브넷 설정
public_subnet_a_cidr  = "10.0.1.0/24"
public_subnet_c_cidr  = "10.0.2.0/24"
private_subnet_a_cidr = "10.0.11.0/24"
private_subnet_c_cidr = "10.0.12.0/24"

# EC2 공통 설정
instance_type = "t3.micro"
ami_id        = "ami-0fa1ca9559f1892ec" # 서울 리전의 최신 Ubuntu AMI 등으로 교체 필요

# 공통 정보
project     = "tamnara"
environment = "prod"



# ALB 설정
alb_idle_timeout = 60

# # 태그 공통
# project = "3tier-web-app"
# environment = "production"

# RDS 정보
db_name              = "tamnara"
db_username          = "temnara18spring"
db_password          = "temnara1818!"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20

key_pair_name = "mvp-key-v1"
