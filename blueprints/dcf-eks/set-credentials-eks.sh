#!/bin/bash
# Set Aviatrix Controller credentials for dcf-eks deployment

echo "Setting Aviatrix Controller credentials..."

export AVIATRIX_CONTROLLER_IP="44.214.60.253"
export AVIATRIX_USERNAME="admin"  # Replace with your actual username
export AVIATRIX_PASSWORD="your-password-here"  # Replace with your actual password

export AWS_REGION="us-east-2"

echo "✅ Credentials set for this session"
echo ""
echo "Controller IP: $AVIATRIX_CONTROLLER_IP"
echo "Username: $AVIATRIX_USERNAME"
echo "Region: $AWS_REGION"
echo ""
echo "Run this command to apply these settings to your shell:"
echo "source ./set-credentials-eks.sh"
