# ─────────────────────────────────────────────────────────────
# Route 53 A 레코드 - 프론트엔드 ALB 연결 (조건부)
# ─────────────────────────────────────────────────────────────
resource "aws_route53_record" "frontend_alb_record" {
  count = var.frontend_dns_name != null && var.frontend_zone_id != null ? 1 : 0
  
  # 호스팅 존 ID (예: tam-nara.com 도메인에 대한 호스팅 존)
  zone_id = var.hosted_zone_id

  # 설정할 도메인 이름 (예: tam-nara.com)
  name    = "${var.domain_name}"

  # A 레코드로 설정
  type    = "A"

  # ALIAS: ALB로 직접 연결
  alias {
    # 대상 ALB의 DNS 이름 (예: alb-frontend-xxxx.elb.amazonaws.com)
    name                   = var.frontend_dns_name

    # 대상 ALB의 호스팅 존 ID (AWS에서 제공)
    zone_id                = var.frontend_zone_id

    # ALB 상태를 기반으로 헬스체크 활성화 여부
    evaluate_target_health = true
  }
}

# ─────────────────────────────────────────────────────────────
# Route 53 A 레코드 - 백엔드 ALB 연결 (api 서브도메인, 조건부)
# ─────────────────────────────────────────────────────────────
resource "aws_route53_record" "backend_alb_record" {
  count = var.backend_dns_name != null && var.backend_zone_id != null ? 1 : 0
  
  # 동일한 호스팅 존 ID 사용
  zone_id = var.hosted_zone_id

  # api 서브도메인에 대한 A 레코드 설정 (예: api.tam-nara.com)
  name    = "api.${var.domain_name}"

  # A 레코드로 설정
  type    = "A"

  alias {
    # 백엔드 ALB의 DNS 이름
    name                   = var.backend_dns_name

    # 백엔드 ALB의 호스팅 존 ID
    zone_id                = var.backend_zone_id

    # ALB 상태 기반 헬스체크 활성화
    evaluate_target_health = true
  }
}

# ─────────────────────────────────────────────────────────────
# Route 53 A 레코드 - Dev 환경 프록시 EC2 연결
# ─────────────────────────────────────────────────────────────
resource "aws_route53_record" "frontend_proxy_record" {
  zone_id = var.hosted_zone_id
  name    = "dev.${var.domain_name}" # dev.tam-nara.com
  type    = "A"

  records = [var.proxy_ec2_ip] # 퍼블릭 프록시 EC2의 퍼블릭 IP
  ttl     = 300
}

resource "aws_route53_record" "backend_proxy_record" {
  zone_id = var.hosted_zone_id
  name    = "dev.api.${var.domain_name}" # dev.api.tam-nara.com
  type    = "A"

  records = [var.back_ec2_ip] # 백엔드 EC2의 프라이빗 IP
  ttl     = 300
}
