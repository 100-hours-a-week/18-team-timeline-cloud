#!/bin/bash
set -e

# Update system
yum update -y

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install kubectl 1.33.0 (EKS compatible)
curl -Lo kubectl "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Verify kubectl installation
/usr/local/bin/kubectl version --client

# Configure kubectl for ec2-user
sudo -u ec2-user mkdir -p /home/ec2-user/.kube

# Wait for AWS CLI to be available and configure kubeconfig
sleep 30
export AWS_DEFAULT_REGION=${region}

# Create kubeconfig with updated API version
sudo -u ec2-user /usr/local/bin/aws eks update-kubeconfig --name ${cluster_name} --region ${region} --kubeconfig /home/ec2-user/.kube/config

# Fix API version in kubeconfig (v1alpha1 -> v1beta1)
sudo -u ec2-user sed -i 's/client.authentication.k8s.io\/v1alpha1/client.authentication.k8s.io\/v1beta1/g' /home/ec2-user/.kube/config

# Set proper permissions
sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube

# Add kubectl to PATH for ec2-user
echo 'export PATH=/usr/local/bin:$PATH' | sudo -u ec2-user tee -a /home/ec2-user/.bashrc

# Test kubectl access
sleep 10
sudo -u ec2-user kubectl --kubeconfig /home/ec2-user/.kube/config get nodes || echo "kubectl 설정 완료. 몇 분 후 다시 시도해주세요."
