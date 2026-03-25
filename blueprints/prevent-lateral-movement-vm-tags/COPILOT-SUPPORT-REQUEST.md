# Email to Aviatrix Technical Support

---

**Subject:** CoPilot Access Issue - Authentication Failed After Deployment (Account: sloggins-lab)

---

**Body:**

Hello Aviatrix Support Team,

I'm unable to access CoPilot after deploying a new instance. I believe the issue is related to an account audit failure blocking CoPilot initialization. I've tried multiple troubleshooting steps without success and need assistance.

---

## Environment Details

**Controller:**
- URL: https://44.214.60.253
- Version: 8.2.0-1000.2196
- Username: admin
- Status: Working properly

**AWS Account:**
- Account Name in Controller: **sloggins-lab**
- AWS Account ID: 240152784131
- Region: us-east-1
- **Account Audit Status: FAIL** ⚠️

**CoPilot Instance (Newly Deployed):**
- Public IP: **44.204.58.42**
- Private IP: 10.0.0.5
- Instance ID: i-0e7a0e8f1e36a51cf
- Instance Type: t3.2xlarge
- Region: us-east-1
- AMI: ami-09405b457df71e318 (avx-copilot-*)
- Status Checks: 2/2 passed (instance healthy)
- Security Group: sg-0888eba6f7e6d0dea

---

## Issue Summary

**Problem:** Cannot log into CoPilot at https://44.204.58.42 - all authentication attempts fail with "Authentication Failed: Failed to login. Please contact administrator."

**Suspected Root Cause:** Account audit failure for "sloggins-lab" is preventing Controller from initializing the CoPilot instance.

**Impact:** Unable to use CoPilot for Prevent Lateral Movement - VM Tags blueprint demonstration and validation.

---

## What I've Tried

### 1. CoPilot Login Attempts (All Failed)

**Attempt 1 - Default Credentials:**
- URL: https://44.204.58.42
- Username: `admin`
- Password: `10.0.0.5` (CoPilot's private IP - documented default)
- Result: ❌ "Authentication Failed"

**Attempt 2 - Controller Credentials:**
- URL: https://44.204.58.42
- Username: `admin`
- Password: `Selina123!` (Controller password)
- Result: ❌ "Authentication Failed"

**Note:** The CoPilot login page loads successfully (HTTPS works), but all credentials fail.

---

### 2. Controller Association Update

**What I Did:**
- Navigated to Controller → Settings → CoPilot
- Updated CoPilot Association:
  - Public IP/FQDN: Changed to `44.204.58.42`
  - IP Address/Hostname: Changed to `10.0.0.5`
  - Clicked "SAVE"

**Result:** Settings saved, but clicking "CoPilot" link in Controller sidebar still returns **"about:blank"** page (nothing loads).

---

### 3. IAM Policy Consolidation

**Issue Identified:**
The account audit error appeared to be caused by multiple IAM policies attached to `aviatrix-role-app`. Per Aviatrix documentation: *"The account auditing feature does not work if the IAM app role has more than one policy attached."*

**Original Configuration (Problem):**
- aviatrix-role-app had 3 policies attached:
  1. PowerUserAccess (AWS managed)
  2. IAMReadOnlyAccess (AWS managed)
  3. AviatrixIAMAccess (custom)

**Fix Applied:**
1. Created consolidated policy: `aviatrix-app-policy` (ARN: arn:aws:iam::240152784131:policy/aviatrix-app-policy)
   - Contains all permissions from PowerUserAccess, IAMReadOnlyAccess, and custom IAM write permissions
2. Detached all 3 old policies from aviatrix-role-app
3. Attached only the new `aviatrix-app-policy`

**Result:**
- ✅ IAM policy consolidation completed successfully
- ⏳ Account audit still showing "FAIL" status (may need time to propagate or re-run)
- ❌ CoPilot still not accessible

---

### 4. SSH Access Attempt (For Troubleshooting)

**Attempt:**
- Added SSH rule (port 22) to CoPilot security group from my IP
- Attempted: `ssh -i avxlabs admin@44.204.58.42`

**Result:** Unable to complete due to missing private key file locally

---

## Account Audit Error Details

**Error Message from Controller:**
```
ERROR 2026-02-18 02:00:02
Account Name: sloggins-lab
Timestamp: 2026-02-18 02:00:01.948213
Controller detected errors in the above accounts.
These errors impact operation and require your immediate attention.
Please visit: https://docs.aviatrix.com/HowTos/account_audit.html
Customer admin email: sloggins@aviatrix.com
Controller IP: 44.214.60.253
Controller Name: N/A
Controller Version: 8.2.0-1000.2196
Time Detected: 2026-02-18 02:00:02.137820
```

**Current Status:** Account "sloggins-lab" shows "FAIL" in Controller account status

---

## Current IAM Configuration

**aviatrix-role-app:**
- Role ARN: arn:aws:iam::240152784131:role/aviatrix-role-app
- Attached Policy: arn:aws:iam::240152784131:policy/aviatrix-app-policy (ONLY 1 policy)
- Trust Policy: Allows sts:AssumeRole from 565569641641 (Controller account)

**aviatrix-role-ec2:**
- Role ARN: arn:aws:iam::240152784131:role/aviatrix-role-ec2
- Attached Policy: AmazonS3ReadOnlyAccess (AWS managed - ONLY 1 policy)
- Trust Policy: Allows EC2 to assume role

---

## Questions for Support

1. **Account Audit:** Why is "sloggins-lab" account audit still failing after consolidating to a single IAM policy? How long does it take for the audit to re-run?

2. **CoPilot Initialization:** Does CoPilot require the Controller to initialize it on first boot? If so, could the account audit failure be preventing this initialization?

3. **Default Password:** Should the default CoPilot password be the private IP (10.0.0.5)? If not, what should it be for a Terraform-deployed instance?

4. **Manual Recovery:** Is there a way to manually initialize or reset the CoPilot admin password? Or do I need to destroy and redeploy?

5. **Account Audit:** Can you check the "sloggins-lab" account (240152784131) in Controller (44.214.60.253) and tell me specifically what's failing in the audit?

---

## What I Need Help With

1. **Primary Goal:** Get CoPilot at 44.204.58.42 accessible for login
2. **Secondary:** Resolve the "sloggins-lab" account audit failure
3. **Understanding:** Confirm whether account audit failure blocks CoPilot initialization

---

## Additional Context

**Use Case:** Deploying Prevent Lateral Movement - VM Tags blueprint for Aviatrix blueprints program (Community tier). CoPilot access needed for:
- Topology visualization
- SmartGroups verification
- DCF policy monitoring
- Demo screenshots and documentation

**Timeline:** Working on blueprint publication - would like to resolve in next 1-2 days if possible.

**Existing Infrastructure:**
- Successfully deployed: 1 transit gateway + 3 spoke gateways
- SmartGroups configured and working
- DCF policies validated (dev→db blocked, prod→db allowed)
- All infrastructure operational except CoPilot access

---

## Attempted Existing CoPilot (For Reference)

**Note:** There's an existing CoPilot shown in Controller settings, but it's also not accessible:
- Public IP: 100.52.75.135
- Private IP: 10.0.0.103
- Attempt Result: Connection timeout (ERR_CONNECTION_TIMED_OUT)
- Likely in different AWS account (aws_admin - 565569641641)

I proceeded to deploy a new CoPilot in my account (240152784131) instead.

---

## Summary

**What's Working:**
- ✅ Controller accessible and functional
- ✅ CoPilot EC2 instance healthy (status checks passing)
- ✅ CoPilot HTTPS accessible (login page loads)
- ✅ All Aviatrix gateways and infrastructure operational

**What's Not Working:**
- ❌ CoPilot authentication (all credentials fail)
- ❌ Controller → CoPilot link (returns about:blank)
- ❌ Account audit for sloggins-lab (showing FAIL)

**Next Step Needed:** Support guidance on resolving account audit and/or initializing CoPilot.

---

Thank you for your assistance!

**Contact Information:**
- Name: Selina Loggins
- Email: sloggins@aviatrix.com
- Controller: 44.214.60.253
- CoPilot Instance: i-0e7a0e8f1e36a51cf (44.204.58.42)

**Urgency:** Medium - Blueprint publication waiting on CoPilot verification

---

**Attachments/References:**
- IAM Policy (aviatrix-app-policy): Available if needed
- Terraform code for CoPilot deployment: Available if needed
- Full deployment logs: Available if needed
