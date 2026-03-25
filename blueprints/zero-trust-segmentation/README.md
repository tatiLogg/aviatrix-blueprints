# Zero Trust Network Segmentation with Aviatrix DCF

Deploy **Zero Trust Network Segmentation** in 15 minutes using Aviatrix Distributed Cloud Firewall (DCF) with SmartGroups. This blueprint achieves microsegmentation across AWS VPCs—**preventing lateral movement, accelerating compliance, and eliminating security group sprawl**—with tag-based automation that scales.

## Customer Outcomes

✅ **80% faster Zero Trust implementation** - 15 minutes vs. weeks of security group configuration
✅ **Zero lateral movement risk** - Breaches contained to single workload, preventing ransomware spread
✅ **Compliance-ready** - Meet PCI-DSS, HIPAA, SOC 2 microsegmentation requirements with audit trail
✅ **90% reduction in policy overhead** - Tag-based SmartGroups eliminate manual security rule management
✅ **Multi-cloud consistency** - Same Zero Trust policies across AWS, Azure, GCP

> [!TIP]
> **🤖 Optimized for Claude Code** — Run `/deploy-blueprint zero-trust-segmentation` for AI-guided deployment with prerequisite checks, or `/analyze-blueprint zero-trust-segmentation` for resource and cost details. [Get Claude Code](https://claude.ai/code)

---

## Architecture

![Architecture Diagram](architecture.svg)

This blueprint deploys:
- **1 Aviatrix Transit Gateway** - Central hub for all spoke connectivity
- **3 Aviatrix Spoke Gateways** - One for each environment (Dev, Prod, DB)
- **3 AWS VPCs** - Isolated network segments for each environment
- **3 EC2 Test Instances** - One per environment for connectivity validation
- **3 DCF SmartGroups** - Dynamic groups based on environment tags
- **5 DCF Policies** - Zero Trust rules enforcing segmentation

**Zero Trust Segmentation Policies:**
- ✅ **Prod → DB**: PERMIT (legitimate business need - explicit allow)
- ✅ **Dev → Prod**: PERMIT ICMP only (monitoring access - protocol-level granularity)
- ❌ **Dev → DB**: **DENY** (blocks lateral movement from dev to production data)
- ❌ **Prod → Dev**: **DENY** (prevents compromised production from affecting dev)
- ❌ **Default**: **DENY ALL** (Zero Trust default-deny - no implicit trust)

**Zero Trust Benefit:** Even if an attacker compromises the dev environment, Zero Trust Network Segmentation prevents access to production databases—containing the breach and stopping ransomware lateral movement.

## Prerequisites

### Required Tools

- [Aviatrix Control Plane](../../docs/prerequisites/aviatrix-controller.md) (v7.1+) - Controller and CoPilot
- [Terraform](../../docs/prerequisites/terraform.md) (v1.5+)
- [AWS CLI](../../docs/prerequisites/aws-cli.md)

### Required Access

- AWS account with permissions to create VPCs, EC2 instances, and networking resources
- Aviatrix Control Plane with AWS account onboarded
- AWS EC2 key pair for SSH access to test VMs

### Blueprint-Specific Requirements

- At least 3 available Elastic IPs in the target AWS region
- AWS Systems Manager (SSM) permissions if using automated test script

## Resources Created

| Resource | Description | Quantity | Estimated Cost/Hour |
|----------|-------------|----------|---------------------|
| **Aviatrix Transit Gateway** | Central hub gateway (t3.small) | 1 | $0.05 |
| **Aviatrix Spoke Gateways** | Spoke gateways for each environment (t3.small) | 3 | $0.15 |
| **AWS VPCs** | Virtual Private Clouds | 4 | Free |
| **AWS Subnets** | Public and private subnets | 8 | Free |
| **AWS Internet Gateways** | Internet connectivity | 4 | Free |
| **AWS Route Tables** | Routing configuration | 8 | Free |
| **AWS Security Groups** | Firewall rules for test VMs | 3 | Free |
| **EC2 Instances** | Test VMs (t3.micro) | 3 | $0.03 |
| **Elastic IPs** | Public IPs for gateways | 4 | $0.02 |
| **DCF SmartGroups** | Dynamic network segments | 3 | Free |
| **DCF Policies** | Zero Trust firewall rules | 5 | Free |

**Total Estimated Cost**: ~$0.25/hour (~$6/day or ~$180/month)

> **Note:** Costs are estimates for us-east-1 and may vary by region. Remember to destroy resources after testing.

## Deployment

### Step 1: Clone and Navigate

```bash
git clone https://github.com/AviatrixSystems/aviatrix-blueprints.git
cd aviatrix-blueprints/blueprints/zero-trust-segmentation
```

### Step 2: Configure Environment Variables

```bash
# Set Aviatrix Controller credentials
export AVIATRIX_CONTROLLER_IP="<your-controller-ip>"
export AVIATRIX_USERNAME="admin"
export AVIATRIX_PASSWORD="<your-password>"

# Set AWS credentials (if not using AWS CLI profile)
export AWS_ACCESS_KEY_ID="<your-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key>"
export AWS_REGION="us-east-1"
```

### Step 3: Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
aws_account_name      = "my-aws-account"  # As configured in Aviatrix Controller
aws_region            = "us-east-1"
name_prefix           = "zt-seg"
test_vm_key_name      = "my-keypair"      # Must exist in your AWS account
test_vm_instance_type = "t3.micro"
```

### Step 4: Deploy

```bash
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted to confirm.

**Deployment takes approximately 10-15 minutes.**

### Step 5: Verify Deployment

After deployment completes:

```bash
# View outputs
terraform output

# You should see:
# - Transit and spoke gateway names
# - Test VM private IPs
# - SmartGroup UUIDs
# - Test scenarios to run
```

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `name_prefix` | Prefix for all resource names | `string` | `"zt-seg"` | no |
| `aws_region` | AWS region for deployment | `string` | `"us-east-1"` | no |
| `aws_account_name` | Aviatrix Access Account name for AWS | `string` | - | **yes** |
| `test_vm_key_name` | EC2 key pair name for SSH access | `string` | - | **yes** |
| `test_vm_instance_type` | EC2 instance type for test VMs | `string` | `"t3.micro"` | no |
| `transit_gateway` | Transit gateway configuration | `object` | See below | no |
| `spokes` | Spoke gateway configurations | `map(object)` | See below | no |

**Default `transit_gateway` value:**
```hcl
{
  cidr       = "10.0.0.0/23"
  asn        = 64512
  ha_enabled = false
}
```

**Default `spokes` value:**
```hcl
{
  dev = {
    cidr        = "10.1.0.0/24"
    environment = "development"
  }
  prod = {
    cidr        = "10.2.0.0/24"
    environment = "production"
  }
  db = {
    cidr        = "10.3.0.0/24"
    environment = "database"
  }
}
```

## Outputs

| Output | Description |
|--------|-------------|
| `transit_gateway_name` | Name of the Aviatrix Transit Gateway |
| `spoke_gateways` | Map of spoke gateway names |
| `test_vm_private_ips` | Private IP addresses of test VMs |
| `smartgroup_uuids` | UUIDs of created SmartGroups |
| `test_scenarios` | Detailed test scenarios with expected results |
| `copilot_verification_steps` | Steps to verify deployment in CoPilot |

## Test Scenarios

### Manual Testing

#### Scenario 1: Dev Attempting to Access DB (SHOULD BE BLOCKED)

This tests the most critical security control - preventing development environments from accessing production databases.

**Steps:**
```bash
# Get the test VM IPs
terraform output test_vm_private_ips

# SSH to Dev VM (use AWS Session Manager or SSH via bastion)
aws ssm start-session --target <dev-vm-instance-id>

# Try to ping DB VM
ping <db-vm-private-ip>
```

**Expected Result:** ❌ Ping fails - **Zero Trust Network Segmentation prevents dev from accessing production database**

**What You'd See in CoPilot:**
- **Navigation:** Security → Distributed Cloud Firewall → Monitor
- **Expected Entry:** Red "DENIED" status with:
  - Source: dev-smartgroup (10.1.0.x)
  - Destination: db-smartgroup (10.3.0.x)
  - Protocol: ICMP
  - Policy: "deny-dev-to-db"
  - Timestamp of blocked attempt
- **Talking Point:** "This proves Zero Trust Network Segmentation is actively blocking lateral movement from dev to production data—exactly what compliance frameworks require"

---

#### Scenario 2: Prod Accessing DB (SHOULD BE ALLOWED)

This validates that legitimate production-to-database traffic is permitted.

**Steps:**
```bash
# SSH to Prod VM
aws ssm start-session --target <prod-vm-instance-id>

# Ping DB VM
ping <db-vm-private-ip>
```

**Expected Result:** ✅ Ping succeeds - **Zero Trust explicit allow for legitimate business traffic**

**What You'd See in CoPilot:**
- **Navigation:** Security → Distributed Cloud Firewall → Monitor
- **Expected Entry:** Green "PERMITTED" status with:
  - Source: prod-smartgroup (10.2.0.x)
  - Destination: db-smartgroup (10.3.0.x)
  - Protocol: ALL
  - Policy: "allow-prod-to-db" (priority 100)
- **Talking Point:** "Zero Trust Network Segmentation allows authorized traffic while blocking everything else—this is least-privilege access in action"

---

#### Scenario 3: Dev Accessing Prod (SHOULD BE ALLOWED - ICMP Only)

This demonstrates fine-grained control - allowing diagnostics while blocking other protocols.

**Steps:**
```bash
# SSH to Dev VM
aws ssm start-session --target <dev-vm-instance-id>

# Ping Prod VM (ICMP should work)
ping <prod-vm-private-ip>

# Try TCP connection (should fail)
nc -zv <prod-vm-private-ip> 80
```

**Expected Result:**
- ✅ Ping succeeds (ICMP allowed)
- ❌ TCP connection fails (only ICMP allowed)

---

#### Scenario 4: Prod Attempting to Access Dev (SHOULD BE BLOCKED)

This enforces production isolation from less secure development environments.

**Steps:**
```bash
# SSH to Prod VM
aws ssm start-session --target <prod-vm-instance-id>

# Try to ping Dev VM
ping <dev-vm-private-ip>
```

**Expected Result:** ❌ Ping fails - traffic is blocked by DCF policy "deny-prod-to-dev"

---

### Automated Testing

Run the included test script:

```bash
# Make sure you have AWS CLI configured and jq installed
chmod +x test-scenarios.sh
./test-scenarios.sh
```

The script will:
1. Retrieve all VM IPs from Terraform state
2. Run connectivity tests using AWS Systems Manager
3. Report PASS/FAIL for each scenario
4. Provide CoPilot verification instructions

## Demo Walkthrough: Proving Zero Trust Network Segmentation

Use this sequence to demonstrate **customer outcomes** achieved through Zero Trust:

### 1. The Problem: Why Zero Trust Network Segmentation (2 minutes)

**Talking Points:**
- "Traditional security groups create flat networks—once connected, everything can talk to everything"
- "83% of ransomware attacks succeed through lateral movement across unSegmented networks"
- "Compliance frameworks (PCI-DSS, HIPAA) require Zero Trust Network Segmentation to protect sensitive data"

**Show:** CoPilot > Topology - hub-and-spoke architecture connecting dev, prod, and database VPCs

### 2. SmartGroups: Automated Zero Trust Boundaries (3 minutes)

**Objective:** Show how Zero Trust scales through tag-based automation

**What to Show:**
- Navigate to **Security > Distributed Cloud Firewall > SmartGroups**
- Click into **dev-smartgroup** → show `Environment=development` selector
- **Key message:** "New workloads tagged `Environment=production` instantly inherit Zero Trust policies—no manual security group updates"

**Customer Outcome:** 90% reduction in security policy management overhead

### 3. Zero Trust Policies: Default-Deny + Explicit Allow (3 minutes)

**Objective:** Prove Zero Trust principle - deny by default, allow only what's needed

**What to Show:**
- Navigate to **Security > Distributed Cloud Firewall > Rules**
- Walk through policies emphasizing **Zero Trust enforcement**:
  - **Priority 100** (allow-prod-to-db): "Explicit allow for legitimate business need"
  - **Priority 200** (deny-dev-to-db): "**Zero Trust blocks dev from production data**—prevents lateral movement"
  - **Priority 1000** (default-deny-all): "Zero Trust default—no implicit trust"
  - **Watch Mode** on deny-dev-to-db: "Test Zero Trust policies safely before enforcement"

**Customer Outcome:** Breaches contained to single workload—no lateral movement

### 4. Live Testing: Zero Trust Blocking Lateral Movement (5 minutes)

**Objective:** Demonstrate Zero Trust Network Segmentation actively preventing attacks

**Test Sequence:**
1. **Dev → DB (BLOCKED)**: "This simulates an attacker who compromised dev trying to reach production data"
   - Run ping test, show TIMEOUT
   - Show **DCF Monitor** with red DENIED entry
   - **Message:** "Zero Trust Network Segmentation stopped the lateral movement"

2. **Prod → DB (ALLOWED)**: "Legitimate business traffic flows freely"
   - Show green PERMITTED entry
   - **Message:** "Zero Trust allows authorized access while blocking everything else"

**Customer Outcome:** Zero lateral movement risk after breach

### 5. The Business Value of Zero Trust (2 minutes)

**Emphasize Outcomes:**
- ✅ **Speed:** "Deployed Zero Trust Network Segmentation in 15 minutes with Terraform"
- ✅ **Security:** "Lateral movement blocked—ransomware can't spread"
- ✅ **Compliance:** "Complete audit trail proves microsegmentation for PCI/HIPAA/SOC 2"
- ✅ **Operations:** "No security group sprawl—tag once, secured forever"
- ✅ **Scale:** "Same Zero Trust policies work across AWS, Azure, GCP"

**Total Demo Time:** ~15 minutes

**Closing:** "This is Zero Trust Network Segmentation at scale—faster, more secure, and with less overhead than native cloud security groups."

## Cleanup

### Standard Destroy

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

**Destroy takes approximately 8-10 minutes.**

### Manual Cleanup (if destroy fails)

If Terraform destroy fails, manually delete resources in this order:

1. **DCF Policies** - In CoPilot: Security > DCF > Rules > Delete all policies
2. **SmartGroups** - In CoPilot: Security > DCF > SmartGroups > Delete all groups
3. **Spoke Gateways** - In CoPilot: Cloud Fabric > Gateways > Delete each spoke
4. **Transit Gateway** - In CoPilot: Cloud Fabric > Gateways > Delete transit
5. **EC2 Instances** - In AWS Console: EC2 > Instances > Terminate all test VMs
6. **VPCs** - In AWS Console: VPC > Your VPCs > Delete all VPCs (this also deletes subnets, route tables, IGWs)

### Verify Cleanup

Confirm no resources remain:

```bash
# Check for remaining VPCs
aws ec2 describe-vpcs \
  --filters "Name=tag:Blueprint,Values=zero-trust-segmentation" \
  --query 'Vpcs[].VpcId'

# Check for remaining instances
aws ec2 describe-instances \
  --filters "Name=tag:Blueprint,Values=zero-trust-segmentation" \
  --query 'Reservations[].Instances[].InstanceId'
```

Both commands should return empty arrays `[]`.

## Troubleshooting

### Issue: Gateway creation times out

**Symptom:** Aviatrix gateway creation fails with timeout error

**Solution:**
1. Verify AWS account is onboarded in the Aviatrix Control Plane
2. Check that the Controller can reach AWS API endpoints
3. Verify sufficient EIP quota in the target region (need 4 EIPs)
4. Check IAM permissions for the Aviatrix IAM roles

### Issue: DCF policies not working

**Symptom:** Traffic is allowed when it should be blocked (or vice versa)

**Solution:**
1. Verify DCF is enabled: **Security > DCF > Configuration** should show "Enabled"
2. Check SmartGroup membership: **Security > DCF > SmartGroups** > click group > verify instances are listed
3. Verify policy priority order - lower numbers are evaluated first
4. Check that test VM instances have correct Environment tags
5. Wait 1-2 minutes for policy changes to propagate

### Issue: Can't SSH to test VMs

**Symptom:** Unable to connect to test VMs for testing

**Solution:**
1. Verify security group allows SSH (port 22) - it should by default
2. Use AWS Systems Manager Session Manager instead of SSH:
   ```bash
   aws ssm start-session --target <instance-id>
   ```
3. Verify the EC2 key pair exists in your AWS account
4. Check that test VMs have private IPs in the correct subnets

### Issue: Test script fails

**Symptom:** `./test-scenarios.sh` returns errors

**Solution:**
1. Install required tools:
   ```bash
   # macOS
   brew install jq awscli

   # Linux
   sudo apt-get install jq awscli  # Debian/Ubuntu
   sudo yum install jq awscli      # RHEL/CentOS
   ```
2. Configure AWS CLI:
   ```bash
   aws configure
   ```
3. Verify SSM agent is running on test VMs (it's installed by default on Amazon Linux 2)
4. Check IAM permissions for SSM:SendCommand

### Issue: High costs

**Symptom:** AWS bill higher than expected

**Solution:**
1. This blueprint costs ~$6/day when running - destroy after testing
2. Check for orphaned Elastic IPs (charged when not attached)
3. Verify NAT Gateways weren't created (they're expensive)
4. Use t3.micro instead of larger instance types

## Tested With

This blueprint is currently tested with:

| Component | Version |
|-----------|---------|
| Aviatrix Controller | 7.2.x |
| Aviatrix Terraform Provider | 3.1.5 |
| Terraform | 1.9.x |
| AWS Provider | 5.80.x |

> **Note**: The blueprint may work with other versions, but these are the versions used for validation.

## Customer Use Cases: Zero Trust Network Segmentation Outcomes

### 1. PCI-DSS Compliance: Cardholder Data Environment Segmentation

**Requirement:** PCI-DSS 1.2.1 mandates network segmentation between CDE and non-CDE systems

**Zero Trust Solution:**
- SmartGroups: `Compliance=PCI-CDE` for cardholder data workloads
- DCF Policy: **DENY** all non-CDE → CDE traffic (blocks lateral movement)
- Audit trail via DCF Monitor proves segmentation for compliance assessors

**Customer Outcome:** Pass PCI audit with documented Zero Trust Network Segmentation

---

### 2. Ransomware Defense: Stop Lateral Movement After Breach

**Scenario:** Attacker compromises a development workload via phishing

**Zero Trust Solution:**
- SmartGroups segment by `Environment=dev/prod/database`
- DCF Policy: **DENY dev → prod/database** (breach contained)
- Default-deny prevents lateral movement to high-value targets

**Customer Outcome:** Ransomware contained to single dev workload—production and databases unaffected

---

### 3. HIPAA Compliance: PHI Data Segmentation

**Requirement:** HIPAA §164.312 requires access controls for electronic protected health information

**Zero Trust Solution:**
- SmartGroups: `DataClassification=PHI` for healthcare systems
- DCF Policy: Explicit allow **ONLY** for authorized medical applications
- Default-deny blocks all unauthorized PHI access

**Customer Outcome:** Meet HIPAA audit requirements with Zero Trust Network Segmentation audit trail

---

### 4. DevSecOps Velocity: Deploy Secure Workloads in Minutes

**Challenge:** Security teams bottleneck deployments with manual security group approvals

**Zero Trust Solution:**
- Developers tag workloads: `Environment=production`, `Application=web-api`
- SmartGroups auto-apply Zero Trust policies based on tags
- No security team approval needed—policies enforce automatically

**Customer Outcome:** 80% faster secure deployment with Zero Trust automation

## Contributing

See the [Contributing Guide](../../CONTRIBUTING.md) for information on how to contribute to this blueprint.

## License

Apache 2.0 - See [LICENSE](../../LICENSE)

---

## Ready to Deploy Zero Trust Network Segmentation?

### Quick Start

```bash
git clone https://github.com/AviatrixSystems/aviatrix-blueprints.git
cd aviatrix-blueprints/blueprints/zero-trust-segmentation
terraform apply
```

**In 15 minutes, you'll have:**
- ✅ Zero Trust Network Segmentation across 3 VPCs
- ✅ Lateral movement protection (dev → database blocked)
- ✅ Compliance audit trail (every denied connection logged)
- ✅ Tag-based automation (zero security group sprawl)

### What You'll Achieve

| Outcome | Traditional Security Groups | Aviatrix Zero Trust |
|---------|----------------------------|---------------------|
| **Deployment Time** | 2-4 weeks (manual SG rules) | ⚡ **15 minutes (Terraform)** |
| **Lateral Movement Prevention** | ❌ Flat network after connection | ✅ **Zero lateral movement** |
| **Policy Management** | Manual per-workload rules | ✅ **Tag-based automation** |
| **Compliance Audit Trail** | ⚠️ VPC Flow Logs (delayed) | ✅ **Real-time DCF Monitor** |
| **Multi-Cloud Consistency** | ❌ Per-cloud silos | ✅ **Unified Zero Trust** |

---

**Questions?** Open an [issue](https://github.com/AviatrixSystems/aviatrix-blueprints/issues) or visit [Aviatrix Community](https://community.aviatrix.com)

**Author:** @tatiLogg
**Status:** ✅ Community Tier - Tested and validated
**Last Updated:** February 2026
**Blueprint Tier:** Community (targeting Verified Q2 2026)
