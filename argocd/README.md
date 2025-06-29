# ArgoCD 설정

이 디렉토리는 ArgoCD를 통해 EKS 클러스터에 애플리케이션을 배포하기 위한 설정들을 포함합니다.

## 디렉토리 구조

```
argocd/
├── README.md
├── applications/          # ArgoCD Application 정의
│   ├── app-of-apps.yaml  # Root Application (App of Apps 패턴)
│   ├── frontend-app.yaml
│   ├── backend-app.yaml
│   └── infra-apps.yaml
└── manifests/            # 실제 Kubernetes 매니페스트
    ├── frontend/
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   └── ingress.yaml
    ├── backend/
    │   ├── deployment.yaml
    │   └── service.yaml
    └── infrastructure/
        └── external-dns/
            └── test-service.yaml
```

## ArgoCD 접속 정보

ArgoCD UI 접속: `terraform output argocd_server_url`
초기 admin 비밀번호: `terraform output argocd_initial_admin_password` 