#!/bin/bash

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting cleanup process...${NC}"

# 현재 context 확인
CURRENT_CONTEXT=$(kubectl config current-context)
echo -e "${GREEN}Current kubectl context: ${CURRENT_CONTEXT}${NC}"
read -p "Continue with this context? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# ArgoCD 애플리케이션 및 프로젝트 삭제
echo -e "${YELLOW}Removing ArgoCD applications...${NC}"
kubectl delete application -n argocd --all --timeout=5m || true
kubectl delete appproject -n argocd --all --timeout=5m || true

# ALB 삭제 대기
echo -e "${YELLOW}Waiting for ALB deletion...${NC}"
sleep 30

# External-DNS가 생성한 Route53 레코드 정리
echo -e "${YELLOW}Cleaning up Route53 records created by External-DNS...${NC}"
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name "tam-nara.com" --query "HostedZones[0].Id" --output text)
if [ ! -z "$HOSTED_ZONE_ID" ]; then
    # tam-nara.com 도메인의 모든 레코드 가져오기
    aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID | \
    jq -c '.ResourceRecordSets[] | select(.Type != "NS" and .Type != "SOA")' | \
    while read -r record; do
        NAME=$(echo $record | jq -r .Name)
        TYPE=$(echo $record | jq -r .Type)
        echo -e "${YELLOW}Deleting Route53 record: ${NAME} (${TYPE})${NC}"
        
        # 변경 배치 생성
        CHANGE_BATCH=$(jq -n \
            --arg name "$NAME" \
            --arg type "$TYPE" \
            --argjson record "$record" \
            '{
                Changes: [{
                    Action: "DELETE",
                    ResourceRecordSet: $record
                }]
            }')
        
        # 레코드 삭제
        aws route53 change-resource-record-sets \
            --hosted-zone-id $HOSTED_ZONE_ID \
            --change-batch "$CHANGE_BATCH" || true
    done
fi

# EKS 클러스터가 생성한 보안 그룹 정리
echo -e "${YELLOW}Cleaning up EKS security groups...${NC}"
CLUSTER_NAME="${PROJECT}-${ENVIRONMENT}-cluster"
VPC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.resourcesVpcConfig.vpcId" --output text)

if [ ! -z "$VPC_ID" ]; then
    # 클러스터 관련 보안 그룹 찾기
    aws ec2 describe-security-groups \
        --filters "Name=vpc-id,Values=$VPC_ID" \
        --query "SecurityGroups[?contains(GroupName, 'eks') || contains(GroupName, 'cluster')].GroupId" \
        --output text | \
    while read -r sg_id; do
        echo -e "${YELLOW}Attempting to delete security group: ${sg_id}${NC}"
        # 보안 그룹의 모든 인바운드 규칙 제거
        aws ec2 revoke-security-group-ingress \
            --group-id $sg_id \
            --protocol all \
            --port all \
            --source-group $sg_id || true
        
        # 보안 그룹의 모든 아웃바운드 규칙 제거
        aws ec2 revoke-security-group-egress \
            --group-id $sg_id \
            --protocol all \
            --port all \
            --cidr 0.0.0.0/0 || true
        
        # 보안 그룹 삭제 시도
        aws ec2 delete-security-group --group-id $sg_id || true
    done
fi

# Terraform state 정리
echo -e "${YELLOW}Cleaning up Terraform state...${NC}"

# ArgoCD 관련 상태 제거
terraform state rm module.eks_utils.module.argocd || true

# Terraform Destroy 실행
echo -e "${YELLOW}Running terraform destroy...${NC}"
terraform destroy -auto-approve

echo -e "${GREEN}Cleanup completed!${NC}" 