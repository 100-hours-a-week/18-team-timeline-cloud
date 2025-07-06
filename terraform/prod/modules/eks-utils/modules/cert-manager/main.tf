# cert-manager Add-on
resource "aws_eks_addon" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0

  cluster_name = var.cluster_name
  addon_name   = "cert-manager"
  # 버전을 명시하지 않으면 AWS가 호환 버전을 자동 선택
  preserve     = true

  tags = merge(
    var.default_tags,
    {
      Name = "${var.name}-cert-manager-addon"
    }
  )
} 