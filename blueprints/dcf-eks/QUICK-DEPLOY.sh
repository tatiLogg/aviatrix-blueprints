#!/bin/bash
# Quick Deploy Script for DCF-EKS Blueprint
# Total deployment time: ~45-60 minutes

set -e

echo "🚀 Starting DCF-EKS Blueprint Deployment"
echo "=========================================="

# Set credentials
export AVIATRIX_CONTROLLER_IP="44.214.60.253"
export AVIATRIX_USERNAME="admin"
export AVIATRIX_PASSWORD="Selina123!"
export AWS_REGION="us-east-2"

echo "✅ Credentials set"
echo ""

# Layer 1: Network (15-20 min)
echo "📡 Layer 1: Deploying Network Infrastructure..."
cd network
terraform init -upgrade
terraform apply -auto-approve
cd ..

# Layer 2: EKS Clusters (15-20 min)
echo "☸️  Layer 2: Deploying EKS Clusters..."
cd clusters/frontend
terraform init -upgrade
terraform apply -auto-approve
cd ../backend
terraform init -upgrade
terraform apply -auto-approve
cd ../..

# Layer 3: Node Groups (10-15 min)
echo "🖥️  Layer 3: Deploying Node Groups..."
cd nodes/frontend
terraform init -upgrade
terraform apply -auto-approve
cd ../backend
terraform init -upgrade
terraform apply -auto-approve
cd ../..

# Layer 4: K8s Apps (5-10 min)
echo "📦 Layer 4: Deploying Kubernetes Applications..."
cd k8s-apps/frontend
terraform init -upgrade
terraform apply -auto-approve
cd ../backend
terraform init -upgrade
terraform apply -auto-approve
cd ../..

echo ""
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "🌐 Access your resources:"
echo "  - CoPilot Topology: https://100.52.75.135/cloud-fabric/topology/overview"
echo "  - AWS Console (us-east-2): https://565569641641.signin.aws.amazon.com/console"
echo "  - CloudShop will be available at the ALB endpoint"
echo ""
echo "⏱️  Total deployment time: ~45-60 minutes"
