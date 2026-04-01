#!/bin/bash
# ============================================================================
# destroy.sh — Safe blueprint teardown
#
# Use this instead of `terraform destroy` directly if you already have DCF
# enabled on your Controller with policies outside this blueprint.
#
# Why: aviatrix_distributed_firewalling_config attempts to DISABLE DCF on
# destroy. If your Controller has other active DCF policies, the Controller
# will reject the request and terraform destroy will fail.
#
# This script removes aviatrix_distributed_firewalling_config from Terraform
# state before destroying so Terraform never attempts to disable DCF. Your
# Controller's existing DCF configuration is left untouched — only the
# blueprint's gateways, SmartGroups, policies, and AWS resources are removed.
# ============================================================================

set -e

echo "Removing DCF config from Terraform state to avoid destroy conflict..."
terraform state rm aviatrix_distributed_firewalling_config.main 2>/dev/null || true

echo "Running terraform destroy..."
terraform destroy "$@"
