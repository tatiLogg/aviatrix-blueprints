Prevent Lateral Movement - VM Tags with Claude Code
Demo Presentation Script (30 Minutes)

Audience: Solutions Engineers, Directors, C-Suite Management  
Presenter: Selina Loggins  
Date: March 2026  
Recording: Yes (for future use)

---

Presentation Overview

What You'll Show:

- Claude Code setup and access (5 min)
- Working with the Aviatrix Blueprint repository (5 min)
- Terraform deployment with Claude Code assistance (10 min)
- Live Zero Trust demonstration in Aviatrix CoPilot (8 min)
- Q&A and wrap-up (2 min)

Key Message: "How AI-assisted development accelerated Zero Trust deployment from weeks to hours—and what I learned along the way."

---

Act 1: Introduction & Claude Code Setup (5 minutes)

Screen: Terminal (macOS)

What to Say:

> "Good morning everyone. Today I'm going to walk you through how I used Claude Code—Anthropic's agentic CLI tool—to deploy a Zero Trust network segmentation blueprint. This isn't a polished demo; it's a real-world walkthrough of what worked, what didn't, and how AI-assisted development changed my workflow."

> "First, let me explain the difference between Claude and Claude Code, as outlined in George Lam's guidance."

Slide 1: Claude vs Claude Code

| Tool                      | Use Case                                                         | Cost Profile                                       |
| ------------------------- | ---------------------------------------------------------------- | -------------------------------------------------- |
| Claude (Conversational)   | Q&A, brainstorming, documentation, small code snippets           | Standard token usage                               |
| Claude Code (Agentic CLI) | Active development, multi-file edits, deployments, Git workflows | High token usage (reads entire project structures) |

What to Say:

> "Claude Code operates autonomously in your local environment and consumes significantly more tokens. We use it only for active development work—not for simple Q&A or documentation."

---

Step 1: Installing Claude Code

Screen to Show: macOS Terminal

What to Say:

> "Let's start with the installation. I'm going to show you the exact commands I ran."

Commands:

```bash
# Step 1: Install Claude Code from terminal
curl -fsSL https://claude.ai/install.sh | bash
```

Screenshot 1: Terminal showing installation progress

What Happened:

- Downloaded and installed Claude Code CLI
- Took ~30 seconds
- Installed to `/usr/local/bin/claude`

What to Say:

> "The installation was straightforward. The script automatically adds Claude to your PATH."

---

Step 2: Creating an API Key

Screen to Show: Web browser at https://console.anthropic.com/dashboard

What to Say:

> "Next, I needed to create an API key. This is critical—you need this to authenticate."

Navigation Path:

1. Go to https://console.anthropic.com/dashboard
2. Click "API keys" in left sidebar
3. Click "Create Key"
4. Label: "selina-loggins-zero-trust-demo"
5. Copy the key (starts with `sk-ant-`)

Screenshot 2: Anthropic Console showing API key creation

CHALLENGE 1: API Key Management

What to Say:

> "Pro tip: Save this key immediately. You can't view it again after closing the dialog. I initially forgot to copy it and had to regenerate a new one."

---

Step 3: Configuring the API Key

Screen to Show: Terminal

What to Say:

> "Now we add the API key to our shell configuration so Claude Code can authenticate."

Commands:

```bash
# Add to zsh config (macOS default shell)
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc

# Apply changes without restarting terminal
source ~/.zshrc

# Verify it's set
echo $ANTHROPIC_API_KEY
```

Screenshot 3: Terminal showing successful environment variable configuration

What to Say:

> "You should see your API key printed out. If it's blank, the export didn't work."

---

Step 4: Launching Claude Code

Screen to Show: Terminal

What to Say:

> "Now we're ready to launch Claude Code. This opens an interactive AI session that can read your entire project directory."

Commands:

```bash
# Navigate to your workspace
cd ~/Downloads/aviatrix-blueprints

# Launch Claude Code
claude
```

Screenshot 4: Claude Code welcome screen in terminal

What to Say:

> "Claude Code starts up and scans the directory. It reads file structures, Git history, and understands the context of your project. This is why it's so powerful—and why token usage is high."

---

Act 2: Working with the Blueprint Repository (5 minutes)

Screen: GitHub + VS Code

What to Say:

> "Before I started, I forked the Aviatrix blueprints repository. I wanted to experiment without affecting the main codebase."

---

Step 5: Forking the Repository

Screen to Show: Web browser at https://github.com/tatiLogg/aviatrix-blueprints

What to Say:

> "Here's the original Aviatrix blueprints repository. It contains production-tested Terraform modules for various architectures."

Navigation Path:

1. Go to https://github.com/AviatrixSystems/aviatrix-blueprints (original repo)
2. Click "Fork" button (top right)
3. Create fork under your account: `tatiLogg/aviatrix-blueprints`
4. Clone to local machine

Screenshot 5: GitHub showing forked repository

Commands:

```bash
# Clone your fork
cd ~/Downloads
git clone https://github.com/tatiLogg/aviatrix-blueprints.git
cd aviatrix-blueprints

# Create a feature branch
git checkout -b feat/prevent-lateral-movement-vm-tags
```

What to Say:

> "I created a feature branch called `feat/prevent-lateral-movement-vm-tags` to isolate my changes. This is standard Git workflow—keeps the main branch clean."

---

Step 6: Understanding the Blueprint Structure

Screen to Show: VS Code with project structure

What to Say:

> "Let me show you the directory structure. This is what Claude Code sees when it scans the project."

Screenshot 6: VS Code showing directory tree

```
aviatrix-blueprints/
├── blueprints/
│   ├── prevent-lateral-movement-vm-tags/  ← Our target
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── dcf.tf              (DCF policies)
│   │   ├── terraform.tfvars.example
│   │   └── README.md
│   ├── dcf-eks/
│   └── _template/
├── modules/
├── docs/
└── README.md
```

What to Say:

> "The `prevent-lateral-movement-vm-tags` blueprint is what we're deploying. It includes Terraform configs for VPCs, gateways, SmartGroups, and DCF policies."

---

Step 7: Initial Prompt to Claude Code

Screen to Show: Terminal with Claude Code running

What to Say:

> "Here's where Claude Code really shines. Instead of manually reading through dozens of Terraform files, I gave it a natural language prompt."

Screenshot 7: Terminal showing Claude Code prompt

My Prompt:

```
I want to deploy the prevent-lateral-movement-vm-tags blueprint from this repository.
I need to:
1. Understand what infrastructure will be created
2. Configure terraform.tfvars with my AWS account details
3. Identify any prerequisites (like Aviatrix Controller access)
4. Run terraform plan and apply safely

Can you help me walk through this step by step?
```

What Claude Code Did:

- Read all files in `blueprints/prevent-lateral-movement-vm-tags/`
- Analyzed `main.tf`, `variables.tf`, `dcf.tf`
- Generated a deployment checklist
- Created a customized `terraform.tfvars` template

Screenshot 8: Claude Code's response showing infrastructure analysis

What to Say:

> "Claude Code analyzed the entire blueprint in seconds and gave me a structured deployment plan. It identified that I needed Aviatrix Controller credentials, AWS access keys, and specific VPC configurations."

---

CHALLENGE 2: Terraform Variables Configuration

What to Say:

> "Here's where I hit my first real challenge. The example tfvars file had placeholder values, and I wasn't sure what some of them meant."

Screenshot 9: VS Code showing `terraform.tfvars.example`

The Problem:

```hcl
# terraform.tfvars.example
aviatrix_controller_ip   = "CHANGE_ME"
aviatrix_username        = "admin"
aviatrix_password        = "CHANGE_ME"
aws_account_name         = "CHANGE_ME"
```

What to Say:

> "I asked Claude Code: 'What are the exact values I need for these variables, and where do I find them?'"

Claude Code's Response:

```
I'll help you configure these step by step:

aviatrix_controller_ip:
   - Log into your Aviatrix Controller web UI
   - This is the IP or DNS name you use to access it
   - Example: "controller.aviatrix.example.com"

aviatrix_password:
   - Your Controller admin password
   - Store this securely—don't commit to Git

aws_account_name:
   - The name of your AWS account in Aviatrix Controller
   - Go to: Controller UI > Accounts > Access Accounts
   - Use the exact name shown there

Would you like me to create a .gitignore entry for terraform.tfvars?
```

What to Say:

> "Claude Code not only explained each variable but proactively suggested security best practices like git-ignoring sensitive files."

---

Act 3: Terraform Deployment with Claude Code (10 minutes)

Screen: Terminal + Claude Code

What to Say:

> "Now let's get into the actual deployment. This is where Claude Code went from helpful to transformative."

---

Step 8: Creating terraform.tfvars

Screen to Show: Terminal with Claude Code

What to Say:

> "I asked Claude Code to create my actual tfvars file with my specific values."

My Prompt:

```
Create terraform.tfvars with these values:
- Controller IP: 100.52.75.135
- AWS Account: tl-aws-dev
- Region: us-east-1
- Use default VPC CIDRs from the example

Make sure to add terraform.tfvars to .gitignore
```

Screenshot 10: Terminal showing Claude Code executing commands

What Claude Code Did:

- Created `terraform.tfvars` with my values
- Added `terraform.tfvars` to `.gitignore`
- Validated CIDR ranges didn't overlap
- Suggested running `terraform fmt` to format files

Commands Run by Claude Code:

```bash
# Claude Code executed these automatically
cat > blueprints/prevent-lateral-movement-vm-tags/terraform.tfvars << 'EOF'
aviatrix_controller_ip = "100.52.75.135"
aviatrix_username      = "admin"
aviatrix_password      = "YOUR_PASSWORD_HERE"
aws_account_name       = "sloggins-lab"
aws_region             = "us-east-1"

# Network configuration
dev_vpc_cidr  = "10.1.0.0/16"
prod_vpc_cidr = "10.2.0.0/16"
db_vpc_cidr   = "10.3.0.0/16"
transit_cidr  = "10.0.0.0/23"
EOF

# Add to .gitignore
echo "terraform.tfvars" >> .gitignore
```

What to Say:

> "Notice how Claude Code used a heredoc to create the file—clean, readable, and automated. It also immediately secured the file by adding it to .gitignore."

Screenshot 10b: VS Code showing the completed terraform.tfvars file

What to Say:

> "And here's proof that it worked—the completed terraform.tfvars file with all my actual values filled in. Compare this to the example file we saw earlier with all the 'CHANGE_ME' placeholders."

Point Out on Screenshot 10b:

- `aws_account_name = "sloggins-lab"` (your actual account)
- `test_vm_key_name = "avxlabs"` (your actual key pair)
- Network CIDR blocks properly configured
- File shows in VS Code with proper syntax highlighting

---

Step 9: Terraform Init

Screen to Show: Terminal

What to Say:

> "Before deploying, we need to initialize Terraform. Claude Code can do this, but I wanted to show the output."

Commands:

```bash
cd blueprints/prevent-lateral-movement-vm-tags
terraform init
```

Screenshot 11: Terminal showing terraform init output

What Happened:

- Downloaded Aviatrix provider (version 3.1.x)
- Downloaded AWS provider (version 5.x)
- Created `.terraform/` directory
- Created `.terraform.lock.hcl`

What to Say:

> "Terraform init downloads provider plugins. This took about 30 seconds."

---

Step 10: Terraform Plan

Screen to Show: Terminal

What to Say:

> "Now let's see what infrastructure will be created. I ran terraform plan to preview changes."

Commands:

```bash
terraform plan -out=tfplan
```

Screenshot 12: Terminal showing terraform plan output (first 20 lines)

What the Plan Showed:

```
Terraform will perform the following actions:

  # aviatrix_transit_gateway.main will be created
  + resource "aviatrix_transit_gateway" "main" {
      + cloud_type   = 1
      + gw_name      = "zt-seg-transit-gw"
      + gw_size      = "t3.medium"
      + vpc_id       = (known after apply)
    }

  # aviatrix_spoke_gateway.dev will be created
  + resource "aviatrix_spoke_gateway" "dev" {
      + gw_name = "zt-seg-dev-spoke-gw"
      + vpc_id  = (known after apply)
    }

  # aviatrix_spoke_gateway.prod will be created
  # aviatrix_spoke_gateway.db will be created

  # aviatrix_distributed_cloud_firewall_rule.deny_dev_to_db will be created
  + resource "aviatrix_distributed_cloud_firewall_rule" "deny_dev_to_db" {
      + name     = "deny-dev-to-db"
      + priority = 200
      + action   = "DENY"
    }

Plan: 45 to add, 0 to change, 0 to destroy.
```

What to Say:

> "The plan showed 45 resources to create: 4 VPCs, 4 gateways, 3 SmartGroups, 5 DCF policies, and test VMs. This gave me confidence before applying."

---

CHALLENGE 3: Controller vs CoPilot Confusion

Screen to Show: Terminal showing error

What to Say:

> "Here's where I hit a critical issue that taught me an important architectural lesson. When I ran terraform plan, I got a cryptic error."

Screenshot 13: Terminal showing authentication error

Error Message:

```
Error: invalid character '<' looking for beginning of value

  on main.tf line 10, in provider "aviatrix":
  10: provider "aviatrix" {

Failed to authenticate with Aviatrix Controller
```

What to Say:

> "This error was confusing at first. The message 'invalid character <' suggested the API was returning HTML instead of JSON. But why?"

How I Diagnosed It:

My Prompt to Claude Code:

```
I'm getting an authentication error with the Aviatrix provider. The error says
"invalid character '<' looking for beginning of value". My controller IP is
100.52.75.135. Can you help debug this?
```

What to Say:

> "Claude Code suggested I test the API endpoint directly using curl. Here's what I found:"

Commands:

```bash
# Test the supposed Controller API
curl -k https://100.52.75.135/v1/api

# Output showed HTML, not JSON:
# <!DOCTYPE html><html><head><title>Aviatrix CoPilot</title>...
```

What to Say:

> "Aha! The curl response returned HTML with 'Aviatrix CoPilot' in the title. I had been using the **CoPilot IP** instead of the **Controller IP**. These are two different systems in the Aviatrix architecture."

The Fix:

What to Say:

> "I checked my browser URL when logged into the Controller and found the correct IP: **44.214.60.253**. Here's the key distinction:"

| System         | IP Address    | Purpose                           | Terraform Use             |
| -------------- | ------------- | --------------------------------- | ------------------------- |
| **Controller** | 44.214.60.253 | Management plane, API operations  | ✅ Required for Terraform |
| **CoPilot**    | 100.52.75.135 | Monitoring, visibility, analytics | ❌ Not for Terraform      |

Commands:

```bash
# Set the correct Controller IP
export AVIATRIX_CONTROLLER_IP="44.214.60.253"
export AVIATRIX_USERNAME="admin"
export AVIATRIX_PASSWORD="Selina123!"

# Now terraform plan works
terraform plan -out=tfplan
```

What to Say:

> "Once I corrected the IP to point to the Controller instead of CoPilot, authentication succeeded immediately. This is a common mistake when you have both systems deployed—the CoPilot UI is often what you interact with daily, but Terraform needs the Controller API."

Key Lesson:

> "**Controller** = Management plane (Terraform talks here)  
> **CoPilot** = Data/visibility plane (humans look here)  
> Don't mix them up!"

---

Step 11: Terraform Apply

Screen to Show: Terminal

What to Say:

> "Now for the moment of truth—deploying the infrastructure."

Commands:

```bash
terraform apply tfplan
```

Screenshot 14: Terminal showing terraform apply in progress

What to Say:

> "Terraform apply runs through all 45 resources. This took about 15 minutes because it's creating VPCs, gateways, and configuring routing."

Live Status Updates Shown:

```
aviatrix_vpc.dev: Creating...
aviatrix_vpc.dev: Creation complete after 45s
aviatrix_vpc.prod: Creating...
aviatrix_vpc.prod: Creation complete after 42s
aviatrix_transit_gateway.main: Creating...
aviatrix_transit_gateway.main: Still creating... [5m0s elapsed]
aviatrix_transit_gateway.main: Creation complete after 8m15s
```

What to Say:

> "You can see some resources create quickly (VPCs in under a minute) while gateways take 8-10 minutes. This is normal for Aviatrix deployments."

---

CHALLENGE 4: AWS IAM Permissions Error

Screen to Show: Terminal showing error mid-apply

What to Say:

> "About 5 minutes into the apply, I hit an IAM permissions error."

Screenshot 15: Error message in terminal

Error Message:

```
Error: error creating test VM instance: UnauthorizedOperation:
You are not authorized to perform this operation.
```

What to Say:

> "The Terraform was trying to create EC2 test VMs, but my IAM role didn't have ec2:RunInstances permission."

How I Fixed It:

- Opened AWS Console
- Navigated to IAM > Roles > (my Aviatrix Controller role)
- Added `AmazonEC2FullAccess` managed policy
- Waited 30 seconds for propagation
- Re-ran `terraform apply`

What to Say:

> "This is a common gotcha. The Aviatrix Controller IAM role needs EC2 permissions if you're deploying test instances. I had to manually fix this in the AWS Console."

Screenshot 16: AWS IAM Console showing updated permissions

---

Step 12: Successful Deployment

Screen to Show: Terminal

What to Say:

> "After fixing permissions, the apply completed successfully."

Screenshot 17: Terminal showing successful completion

Final Output:

```
Apply complete! Resources: 45 added, 0 changed, 0 destroyed.

Outputs:

controller_url = "https://100.52.75.135"
dev_test_vm_id = "i-06d8521a74dbdda2a"
prod_test_vm_id = "i-016d5ddf58669c588"
db_test_vm_id = "i-0c5e20af298c6cbfe"
transit_gateway_name = "zt-seg-transit-gw"
```

What to Say:

> "Terraform outputs give us the info we need for testing: VM instance IDs and the Controller URL. Now let's see it in action."

---

Act 4: Live Zero Trust Demonstration (8 minutes)

Screen: Aviatrix CoPilot Web UI

What to Say:

> "Now let's log into Aviatrix CoPilot and see what we deployed. This is where Zero Trust comes to life."

---

Step 13: CoPilot Topology View

Screen to Show: Web browser at CoPilot

Navigation: Cloud Fabric > Topology

Screenshot 18: Topology view showing 4 gateways connected

What to Say:

> "Here's our hub-and-spoke topology: one transit gateway connected to three spoke gateways (dev, prod, database). This is the foundation for Zero Trust segmentation."

Point Out:

- Transit Gateway (green) in the center
- Three spoke gateways (blue) connected
- VPC names labeled

---

Step 14: SmartGroups Overview

Screen to Show: CoPilot

Navigation: Security > Distributed Cloud Firewall > SmartGroups

Screenshot 19: SmartGroups list showing 3 groups

What to Say:

> "SmartGroups are how we define 'who' in our policies. They're tag-based logical groupings that automatically include resources."

Show the 3 SmartGroups:

| SmartGroup             | Tag Match               | Members      |
| ---------------------- | ----------------------- | ------------ |
| zt-seg-dev-smartgroup  | Environment=development | dev-test-vm  |
| zt-seg-prod-smartgroup | Environment=production  | prod-test-vm |
| zt-seg-db-smartgroup   | Environment=database    | db-test-vm   |

What to Say:

> "Each SmartGroup matches on an AWS tag. When I tag a new EC2 with 'Environment=development', it automatically joins the dev SmartGroup. No manual updates needed."

---

Step 15: DCF Policies

Screen to Show: CoPilot

Navigation: Security > Distributed Cloud Firewall > Rules

Screenshot 20: Rules list showing 5 policies with priorities

What to Say:

> "Here are our Zero Trust policies. Notice the priority numbers—they matter. DCF evaluates policies top to bottom until it finds a match."

Policy List:

| Priority | Policy            | Source | Destination | Action             | Purpose                |
| -------- | ----------------- | ------ | ----------- | ------------------ | ---------------------- |
| 100      | allow-prod-to-db  | Prod   | DB          | PERMIT             | Business need          |
| 110      | allow-dev-to-prod | Dev    | Prod        | PERMIT (ICMP only) | Health checks          |
| 200      | deny-dev-to-db    | Dev    | DB          | DENY               | Block lateral movement |
| 210      | deny-prod-to-dev  | Prod   | Dev         | DENY               | Prevent contamination  |
| 1000     | default-deny-all  | ANY    | ANY         | DENY               | Zero Trust default     |

What to Say:

> "Policy 200 is the critical one: it blocks dev from reaching the database, even though they're in the same network. This prevents lateral movement if dev gets compromised."

---

Step 16: Live Traffic Testing

Screen to Show: Split screen (Terminal + CoPilot)

What to Say:

> "Now let's prove this works with live traffic tests. I'm going to SSH into the test VMs and try to reach each other."

---

Test 1: Prod → DB (SHOULD SUCCEED)

Screen to Show: Terminal

Commands:

```bash
# SSH to prod-test-vm
aws ec2-instance-connect ssh --region us-east-1 --instance-id i-016d5ddf58669c588

# From inside prod VM
ping -c 5 10.3.0.126
```

Screenshot 21: Terminal showing successful ping (0% packet loss)

Output:

```
PING 10.3.0.126 (10.3.0.126) 56(84) bytes of data.
64 bytes from 10.3.0.126: icmp_seq=1 ttl=252 time=1.52 ms
64 bytes from 10.3.0.126: icmp_seq=2 ttl=252 time=1.47 ms
--- 10.3.0.126 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss
```

What to Say:

> "Success! Prod can reach the database because Policy 100 permits it. This is legitimate business traffic."

---

Test 2: Dev → DB (SHOULD BE BLOCKED)

Screen to Show: Terminal

Commands:

```bash
# SSH to dev-test-vm
aws ec2-instance-connect ssh --region us-east-1 --instance-id i-06d8521a74dbdda2a

# From inside dev VM
ping -c 5 10.3.0.126
```

Screenshot 22: Terminal showing blocked ping (100% packet loss)

Output:

```
PING 10.3.0.126 (10.3.0.126) 56(84) bytes of data.
--- 10.3.0.126 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4099ms
```

What to Say:

> "Blocked! Dev cannot reach the database. Policy 200 denies this traffic. Even if an attacker compromises the dev environment, they're stopped here. This is Zero Trust in action."

---

Step 17: FlowIQ Traffic Visibility

Screen to Show: CoPilot

Navigation: Monitor > FlowIQ

Screenshot 23: FlowIQ dashboard showing traffic flows

What to Say:

> "FlowIQ shows us real-time traffic analytics. Here's what's flowing through our network over the last 7 days."

Point Out:

- Total traffic: 32.3 kB, 384 packets
- Source/destination IPs
- Flow locality (inter-VPC traffic)
- No dev→database flows visible (because they're blocked)

---

Act 5: Key Takeaways & Lessons Learned (2 minutes)

Screen: Slide deck summary

What to Say:

> "Let me wrap up with what I learned from this experience."

---

Slide 2: Challenges & Solutions

| Challenge                          | Solution                                                           | Time Saved |
| ---------------------------------- | ------------------------------------------------------------------ | ---------- |
| API Key Setup                      | Saved key immediately; used env var correctly                      | 5 min      |
| Terraform Variables                | Claude Code explained each variable + security practices           | 30 min     |
| Controller vs CoPilot IP Confusion | Used curl to diagnose; found correct Controller IP (44.214.60.253) | 15 min     |
| IAM Permissions                    | Manual fix in AWS Console (added EC2 permissions)                  | 10 min     |

What to Say:

> "Total troubleshooting time: under 1 hour. Without Claude Code, I estimate this would have taken me 4-6 hours of reading docs and trial-and-error. The Controller vs CoPilot confusion is especially common—that curl diagnostic trick saved me from going down rabbit holes."

---

Slide 3: What Worked Well

Claude Code Benefits:

- Instant codebase understanding (scanned entire project in seconds)
- Automated file creation with best practices (heredocs, .gitignore)
- Proactive security suggestions (don't commit secrets)
- Multi-file edits without manual navigation

Blueprint Quality:

- Well-structured Terraform modules
- Clear variable naming
- Comprehensive README documentation

Zero Trust Validation:

- Live traffic tests proved policy enforcement
- FlowIQ provided visibility into all traffic flows

What to Say:

> "Claude Code didn't just write code—it taught me best practices as I worked. It's like pair programming with an expert who never gets tired."

---

Slide 4: What I'd Do Differently

Improvements for Next Time:

Pre-check IAM permissions before running Terraform

- Validate Controller IAM role has EC2, VPC, and route table permissions

Use Terraform workspaces for multi-environment deployments

- Separate state files for dev/staging/prod

Create a deployment checklist based on this experience

- Document prerequisites (API keys, IAM roles, network CIDRs)

Test in smaller increments

- Deploy just VPCs first, then gateways, then policies
- Easier to troubleshoot failures

What to Say:

> "These lessons will make the next deployment faster and smoother. And I can share this knowledge with the team so they don't hit the same issues."

---

Slide 5: Resources & Links

Links to Share:

- Claude Code Installation: https://claude.ai/install.sh
- Anthropic API Console: https://console.anthropic.com/dashboard
- Aviatrix Blueprints Repo (Original): https://github.com/AviatrixSystems/aviatrix-blueprints
- My Fork: https://github.com/tatiLogg/aviatrix-blueprints
- Aviatrix Terraform Provider Docs: https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs
- Zero Trust Blueprint README: [Link to your repo README]

Internal Resources:

- George Lam's Claude Code Guidelines: [Slack/Email link]
- Aviatrix Controller Access: [Internal wiki link]
- AWS Account Access: [Internal onboarding doc]

---

Final Slide: Call to Action

What to Say:

> "I encourage everyone to try Claude Code for your next infrastructure project. Start small—maybe deploy a single VPC or test environment—and see how it changes your workflow."

> "Happy to answer questions or do a follow-up session if anyone wants to dive deeper into Terraform, Zero Trust policies, or Claude Code usage."

---

Recording & Presentation Tips

Before Recording:

Technical Prep:

- [ ] Close unnecessary browser tabs
- [ ] Clear terminal history (`clear`)
- [ ] Set terminal font size to 16pt for readability
- [ ] Test screen sharing in Zoom/Teams
- [ ] Have all screenshots ready in a folder
- [ ] Pre-stage terminal windows (one for commands, one for SSH)

✅ Content Prep:

- [ ] Rehearse transitions between screens
- [ ] Time each section (aim for 30 min total)
- [ ] Prepare backup talking points if you finish early
- [ ] Have Q&A answers ready for common questions

Environment Prep:

- [ ] Quiet room (no background noise)
- [ ] Good microphone (built-in Mac mic is fine)
- [ ] Stable internet connection
- [ ] Charge laptop (don't rely on battery)

During Recording:

Screen Sharing Order:

1. Start with slide deck (introduction)
2. Switch to Terminal for Claude Code demo
3. Switch to browser for GitHub/Anthropic Console
4. Switch to VS Code for file structure
5. Back to Terminal for Terraform commands
6. Switch to CoPilot for live demo
7. Back to slides for wrap-up

Pacing Tips:

- Speak slowly and clearly (especially technical terms)
- Pause 2-3 seconds after showing a screenshot
- Narrate what you're doing ("Now I'm clicking on SmartGroups...")
- Don't rush through errors—explain them

Engagement Tips:

- Use "we" instead of "I" when appropriate
- Ask rhetorical questions ("Have you ever struggled with Terraform variables?")
- Show enthusiasm when things work
- Be honest about challenges (builds credibility)

---

Appendix: Full Command Reference

A. Claude Code Installation & Setup

```bash
# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Configure API key
echo 'export ANTHROPIC_API_KEY="sk-ant-YOUR-KEY"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
claude --version

# Launch Claude Code
cd ~/Downloads/aviatrix-blueprints
claude
```

---

B. Git Workflow

```bash
# Clone forked repository
git clone https://github.com/tatiLogg/aviatrix-blueprints.git
cd aviatrix-blueprints

# Create feature branch
git checkout -b feat/prevent-lateral-movement-vm-tags

# Stage changes
git add blueprints/prevent-lateral-movement-vm-tags/terraform.tfvars
git add .gitignore

# Commit
git commit -m "Add Zero Trust segmentation configuration"

# Push to remote
git push origin feat/prevent-lateral-movement-vm-tags
```

---

C. Terraform Commands

```bash
# Navigate to blueprint
cd blueprints/prevent-lateral-movement-vm-tags

# Initialize
terraform init

# Validate configuration
terraform validate

# Format files
terraform fmt

# Plan deployment
terraform plan -out=tfplan

# Review plan details
terraform show tfplan

# Apply changes
terraform apply tfplan

# Check state
terraform state list

# Destroy (cleanup)
terraform destroy
```

---

D. AWS EC2 Instance Connect

```bash
# SSH to dev VM
aws ec2-instance-connect ssh \
  --region us-east-1 \
  --instance-id i-06d8521a74dbdda2a

# SSH to prod VM
aws ec2-instance-connect ssh \
  --region us-east-1 \
  --instance-id i-016d5ddf58669c588

# SSH to DB VM
aws ec2-instance-connect ssh \
  --region us-east-1 \
  --instance-id i-0c5e20af298c6cbfe
```

---

E. Test Commands (run from inside VMs)

```bash
# Test 1: Prod → DB (should succeed)
ping -c 5 10.3.0.126

# Test 2: Dev → DB (should fail)
ping -c 5 10.3.0.126

# Test 3: Dev → Prod (ICMP should succeed, SSH should fail)
ping -c 5 10.2.0.110
ssh -o ConnectTimeout=5 ec2-user@10.2.0.110

# Check VM metadata
curl -s http://169.254.169.254/latest/meta-data/instance-id
```

---

Screenshot Checklist

Required Screenshots (23 total)

Setup Phase (4):

- [ ] 1. Terminal showing Claude Code installation
- [ ] 2. Anthropic Console API key creation
- [ ] 3. Terminal showing environment variable configuration
- [ ] 4. Claude Code welcome screen

Repository Phase (5):

- [ ] 5. GitHub forked repository page
- [ ] 6. VS Code showing directory tree
- [ ] 7. Terminal with initial Claude Code prompt
- [ ] 8. Claude Code response with deployment plan
- [ ] 9. VS Code showing terraform.tfvars.example

Deployment Phase (9):

- [ ] 10. Terminal showing Claude Code executing commands
- [ ] 10b. VS Code showing completed terraform.tfvars file (proof it worked)
- [ ] 11. Terminal showing terraform init output
- [ ] 12. Terminal showing terraform plan (first 20 lines)
- [ ] 13. Terminal showing provider version error
- [ ] 14. Terminal showing terraform apply in progress
- [ ] 15. Terminal showing IAM permissions error
- [ ] 16. AWS IAM Console showing updated permissions
- [ ] 17. Terminal showing successful completion

CoPilot Phase (6):

- [ ] 18. CoPilot topology view (4 gateways)
- [ ] 19. SmartGroups list (3 groups)
- [ ] 20. DCF Rules list (5 policies)
- [ ] 21. Terminal showing prod→db ping SUCCESS
- [ ] 22. Terminal showing dev→db ping BLOCKED
- [ ] 23. FlowIQ dashboard with traffic flows

Screenshot Specifications:

- Resolution: 1920x1080 minimum
- Format: PNG
- Annotations: Use red boxes/arrows for key areas
- Text: Add brief captions explaining what's shown
- Redaction: Hide passwords, API keys, account IDs

---

Timing Breakdown

| Section              | Duration | Key Points                          |
| -------------------- | -------- | ----------------------------------- |
| Introduction         | 1 min    | Hook + Claude Code overview         |
| Claude Code Setup    | 4 min    | Install, API key, launch            |
| Repository Setup     | 5 min    | Fork, clone, understand structure   |
| Terraform Deployment | 10 min   | Init, plan, apply + troubleshooting |
| Live Zero Trust Demo | 8 min    | CoPilot walkthrough + traffic tests |
| Wrap-up              | 2 min    | Lessons learned + Q&A               |
| TOTAL                | 30 min   |                                     |

---

Success Metrics

After this presentation, attendees should be able to:

Install and configure Claude Code on their machines

- Understand when to use Claude Code vs regular Claude
- Fork and customize an Aviatrix blueprint
- Deploy infrastructure using Terraform with AI assistance
- Troubleshoot common Terraform/AWS issues
- Validate Zero Trust policies with live traffic tests
- Use Aviatrix CoPilot for network visibility

---

Q&A Preparation

Anticipated Questions & Answers:

Q1: How much did this cost in API tokens?

> A: Approximately $8-12 in Claude Code API usage for the entire project (including troubleshooting). A standard Claude conversation would have been < $1 but wouldn't have had file access or automation capabilities.

Q2: Can Claude Code make mistakes?

> A: Yes! It's not perfect. In my case, it correctly updated the provider version, but I still had to manually fix IAM permissions because that's external to the codebase. Always review changes before applying.

Q3: How long would this take without Claude Code?

> A: Estimated 6-8 hours for someone unfamiliar with the blueprint. Claude Code compressed that to ~2 hours (including deployment time). Most time savings came from understanding the codebase and generating config files.

Q4: Is Claude Code suitable for production deployments?

> A: Use with caution. It's excellent for development, prototyping, and learning. For production, have a human review all changes, use PR workflows, and test thoroughly. Never commit API keys.

Q5: What if I don't have access to Aviatrix Controller?

> A: You'll need Controller access to deploy this blueprint. Contact your Aviatrix admin or request a trial Controller. The blueprint won't work without it.

Q6: Can I use this with Azure or GCP instead of AWS?

> A: Yes! Aviatrix supports multi-cloud. You'd need to modify the Terraform provider configs and use Azure/GCP-specific resources, but the DCF policies work the same way.

Q7: How do I clean up the resources after testing?

> A: Run `terraform destroy` from the blueprint directory. This removes all infrastructure. Be careful—this is irreversible.

---

Next Steps for You

After presenting:

- Share this document with the team via Confluence/SharePoint
- Upload the recording to your internal video platform
- Create a follow-up workshop for hands-on Claude Code practice
- Document additional learnings as people try it themselves
- Update the blueprint README with your improvements
- Submit a PR to the upstream Aviatrix repo with any fixes

---

Good luck with your presentation, Selina! You've got this.

---

Document Version: 1.0  
Last Updated: March 5, 2026  
Author: Selina Loggins  
Reviewed By: [To be filled after dry run with Wes]
