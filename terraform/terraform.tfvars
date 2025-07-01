# VPC 설정
vpc_cidr_block = "10.0.0.0/16"

# 가용 영역
az_a = "ap-northeast-2a"
az_c = "ap-northeast-2c"

# 서브넷 설정
public_subnet_a_cidr  = "10.0.0.0/24"
public_subnet_c_cidr  = "10.0.1.0/24"

// 프론트 서브넷 CIDR
private_subnet_a_front_cidr = "10.0.10.0/24"
private_subnet_c_front_cidr = "10.0.11.0/24"

// 백엔드 서브넷 CIDR
private_subnet_a_back_cidr = "10.0.20.0/24"
private_subnet_c_back_cidr = "10.0.21.0/24"

# DB 서브넷 CIDR
private_subnet_a_db_cidr = "10.0.30.0/24"
private_subnet_c_db_cidr = "10.0.31.0/24"

# EC2 공통 설정
instance_type = "t3.micro"
instance_type_be = "t3.small"
#ami_id        = "ami-0fa1ca9559f1892ec" # 서울 리전의 최신 Ubuntu AMI 등으로 교체 필요
ami_id = "ami-08943a151bd468f4e" # 서울 리전의 최신 Ubuntu AMI amd


# 공통 정보
project     = "tamnara"
environment = "prod"


# ALB 설정
alb_idle_timeout = 300

# # 태그 공통
# project = "3tier-web-app"
# environment = "production"

# RDS 정보
db_name              = "tamnara"
db_username          = "temnara18spring"
db_password          = "temnara1818!"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_snapshot_identifier = "prod-rds-0618"  # 기존 스냅샷 사용. 새 DB 생성시 null 또는 주석처리

key_pair_name = "mvp-key-v1"

# route53 설정
domain_name = "tam-nara.com"
dns_zone_id = "Z03219133C1AINV5FK5KW"

# peering vpc id
peering_vpc_id = "vpc-0293cca3cb29f35f1"

# ArgoCD 설정
enable_argocd        = true
argocd_safe_destroy  = false  # destroy 전에 true로 변경하여 ArgoCD 먼저 제거
argocd_chart_version = "7.7.8"
enable_app_of_apps   = false  # 첫 배포시 false로 설정
repo_url             = "https://github.com/100-hours-a-week/18-team-timeline-cloud.git"
target_revision      = "main"
applications_path    = "argocd/applications"

# External-DNS 설정
enable_external_dns = true
domain_filters      = ["tam-nara.com"]