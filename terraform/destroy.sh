#!/bin/bash

# namespace와 리소스 state 제거
terraform state rm module.prod.module.eks_config.module.irsa.kubernetes_namespace.app_namespace[0]
terraform state rm module.prod.module.eks_utils.module.argocd[0].helm_release.argocd
terraform state rm module.prod.module.eks_utils.module.argocd[0].kubernetes_namespace.argocd

# terraform destroy 실행
terraform destroy -auto-approve
