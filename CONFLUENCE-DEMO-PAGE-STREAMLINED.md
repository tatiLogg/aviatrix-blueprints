Prevent Lateral Movement - VM Tags Demo Guide

Duration: 25 minutes | Audience: Security/Network Engineers | Owner: @tatiLogg

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Executive Summary

What You'll Demo: Zero Trust segmentation using Aviatrix DCF + SmartGroups. 15-minute deployment vs. weeks with traditional security groups.

Key Value:

- Lateral Movement Prevention: Stop attackers from pivoting between dev/prod/database
- Tag-Based Automation: Policies follow workloads (no manual IP management)
- Real-Time Visibility: Full audit trail for compliance (PCI-DSS, HIPAA, SOC 2)
- 15-Minute Deployment: vs. 2-3 weeks with security groups

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The Problem

> "We manage hundreds of security group rules across VPCs. When breached, attackers move laterally. We need microsegmentation for compliance without the operational overhead."

| Traditional Approach             | Aviatrix DCF                          |
| -------------------------------- | ------------------------------------- |
| IP-based per-VPC security groups | Tag-based SmartGroups across all VPCs |
| Manual updates for every change  | Automatic policy application          |
| No visibility into traffic       | Real-time monitoring + audit trail    |
| 2-3 weeks deployment             | 15 minutes                            |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Architecture

Components Deployed:

| Component       | Qty | Purpose                                |
| --------------- | --- | -------------------------------------- |
| Transit Gateway | 1   | Central hub for all spoke connectivity |
| Spoke Gateways  | 3   | Attach to dev, prod, database VPCs     |
| SmartGroups     | 3   | Tag-based logical groupings            |
| DCF Policies    | 5   | Zero Trust segmentation rules          |
| Test VMs        | 3   | Validate traffic flows                 |

High-Level Topology:

        ┌─────────────────┐
        │ Transit Gateway │
        │   (10.0.0.0/23) │
        └────────┬─────────┘
         ┌───────┼────────┐
    ┌────▼───┐ ┌▼────┐ ┌──▼────┐
    │Dev VPC │ │Prod │ │DB VPC │
    └────────┘ └─────┘ └───────┘

Screenshot: CoPilot Topology View (Cloud Fabric > Topology)

- Show all 4 gateways connected in hub-and-spoke pattern

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Demo Flow (20 minutes)

Act 1: SmartGroups - Tag-Based Automation (5 min)

Navigate to: Security > Distributed Cloud Firewall > SmartGroups

Show: 3 SmartGroups automatically including resources by AWS tags

| SmartGroup             | Tag Match               | Members      |
| ---------------------- | ----------------------- | ------------ |
| zt-seg-dev-smartgroup  | Environment=development | dev-test-vm  |
| zt-seg-prod-smartgroup | Environment=production  | prod-test-vm |
| zt-seg-db-smartgroup   | Environment=database    | db-test-vm   |

Click into: dev-smartgroup to show match criteria

Key Message: "When you tag a new EC2 with 'Environment=development', it instantly joins this SmartGroup. Policies apply automatically—no manual updates."

Screenshot: SmartGroups list view
Screenshot: dev-smartgroup detail showing tag match criteria

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Act 2: DCF Policies - Zero Trust Rules (6 min)

Navigate to: Security > Distributed Cloud Firewall > Rules

Show: 5 policies enforcing microsegmentation

| Priority | Policy             | Source | Dest | Action             | Purpose                    |
| -------- | ------------------ | ------ | ---- | ------------------ | -------------------------- |
| 100      | allow-prod-to-db   | Prod   | DB   | PERMIT             | Business need              |
| 110      | allow-dev-to-prod  | Dev    | Prod | PERMIT (ICMP only) | Health checks              |
| 200      | **deny-dev-to-db** | Dev    | DB   | **DENY**           | **Block lateral movement** |
| 210      | deny-prod-to-dev   | Prod   | Dev  | DENY               | Prevent contamination      |
| 1000     | default-deny-all   | ANY    | ANY  | DENY               | Zero Trust default         |

Click into: deny-dev-to-db policy (Priority 200)

Key Message: "This is the critical policy. Even if ransomware compromises dev, it cannot reach the database. This is Zero Trust—never trust, always verify."

Screenshot: DCF Rules list with all 5 policies
Screenshot: deny-dev-to-db policy details

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Act 3: Live Traffic Demo (7 min)

Navigate to: Monitor > FlowIQ (set time range to "Last 7 Days")

Show: Real traffic data

- Total Traffic: 32.3 kB, 384 packets
- 3 Source IPs, 3 Destination IPs
- Flow Exporters (your gateways)
- Flow Locality: private (inter-VPC)

Key Message: "This is complete visibility into cross-VPC traffic. Every flow captured for forensics and compliance audits."

Screenshot: FlowIQ dashboard showing traffic donut charts

Live Policy Testing (THE "WOW" MOMENT)

Demonstrate Zero Trust enforcement with real-time connectivity tests:

Test 1: Prod → DB (SHOULD SUCCEED)

- SSH to prod-test-vm: aws ec2-instance-connect ssh --region us-east-1 --instance-id i-016d5ddf58669c588
- Run: ping -c 5 10.3.0.126
- Result: SUCCESS - 0% packet loss (Policy 100 PERMIT allows prod→database)

Test 2: Dev → Prod (SHOULD SUCCEED - ICMP only)

- SSH to dev-test-vm: aws ec2-instance-connect ssh --region us-east-1 --instance-id i-06d8521a74dbdda2a
- Run: ping -c 5 10.2.0.110
- Result: SUCCESS - 0% packet loss (Policy 110 PERMIT allows ICMP)
- Try SSH: ssh -o ConnectTimeout=5 ec2-user@10.2.0.110
- Result: TIMEOUT - Connection blocked (only ICMP allowed, not TCP)

Test 3: Dev → DB (SHOULD BE BLOCKED)

- From dev-test-vm (still connected)
- Run: ping -c 5 10.3.0.126
- Result: 100% packet loss - BLOCKED by Policy 200 (deny-dev-to-db)

Test 4: Prod → Dev (SHOULD BE BLOCKED)

- SSH to prod-test-vm: aws ec2-instance-connect ssh --region us-east-1 --instance-id i-016d5ddf58669c588
- Run: ping -c 5 10.1.0.93
- Result: 100% packet loss - BLOCKED by Policy 210 (deny-prod-to-dev)

Test 5: DB → Prod (SHOULD BE BLOCKED - no policy exists)

- SSH to db-test-vm: aws ec2-instance-connect ssh --region us-east-1 --instance-id i-0c5e20af298c6cbfe
- Run: ping -c 5 10.2.0.110
- Result: 100% packet loss - BLOCKED by Policy 1000 (default-deny-all)

Key Message: "This is Zero Trust in real-time. Prod can reach the database—that's legitimate business traffic. But dev is completely blocked from the database, even though they're in the same network. Policy 200 enforces lateral movement prevention. If ransomware compromises dev, it stops here."

Screenshot: Terminal showing prod→db ping SUCCESS (0% packet loss)
Screenshot: Terminal showing dev→db ping BLOCKED (100% packet loss)
Screenshot: Terminal showing dev→prod ICMP works but SSH times out (protocol-level control)

Optional: Check DCF Monitor

- Navigate to: Security > Distributed Cloud Firewall > Monitor
- If logs appear, point out DENIED entries for dev→db attempts
- If empty, explain: "The policies enforce at the data path. FlowIQ shows what flows—notice no dev→database traffic because it's blocked before logging."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Act 4: Watch Mode - Safe Rollout (2 min)

Explain: Watch Mode logs violations without blocking traffic

Policy Lifecycle:

1. Create policy in Watch Mode (observe)
2. Validate no legitimate traffic blocked (refine)
3. Disable Watch Mode (enforce)
4. Monitor and adjust (iterate)

Key Message: "Watch Mode ensures you never break applications when implementing Zero Trust. Test first, enforce second."

Screenshot: Policy with Watch Mode enabled

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Key Differentiators

| Capability  | AWS Security Groups    | AWS Network Firewall | Aviatrix DCF                   |
| ----------- | ---------------------- | -------------------- | ------------------------------ |
| Scope       | Single VPC             | Per-VPC              | Multi-VPC, Multi-Cloud         |
| Management  | IP-based, per-resource | Per-VPC              | Centralized, tag-based         |
| Visibility  | Flow Logs (delayed)    | CloudWatch           | Real-time + SmartGroup context |
| Deployment  | Days                   | Days (per VPC)       | 15 minutes                     |
| Watch Mode  | No                     | No                   | Yes (Safe testing)             |
| Multi-Cloud | AWS only               | AWS only             | AWS, Azure, GCP, OCI           |
| Cost        | Included               | Per-VPC + data       | Included                       |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Common Objections

| Objection                 | Response                                                                                                                              | Show                                         |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| "We have security groups" | "Security groups are VPC-scoped and IP-based. DCF is centralized, tag-based, works across all VPCs/clouds with real-time visibility." | CoPilot unified view vs. per-VPC AWS console |
| "What's the ROI?"         | "DCF is included—no per-VPC firewall costs. 70% fewer security tickets. Preventing one breach ($4.35M avg) pays for itself 10x over." | Cost comparison table                        |
| "Migration complexity?"   | "Use Watch Mode to observe traffic. Create SmartGroups matching security groups. Run in parallel, then cutover."                      | Watch Mode demo                              |
| "Performance impact?"     | "<1ms latency. Line-rate throughput. Gateways already in data path."                                                                  | Architecture diagram                         |
| "Works with K8s?"         | "Yes. Match pod labels, namespaces, service accounts. Works with EKS, AKS, GKE."                                                      | K8s SmartGroup example                       |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Customer Benefits

Security:

- Zero Trust enforcement (default-deny)
- 80% reduction in attack surface
- Compliance: PCI-DSS, HIPAA, SOC 2 audit trails

Operational:

- 70% fewer security tickets
- Tag-based automation (no IP management)
- Single pane of glass for all VPCs/clouds

Financial:

- No per-VPC firewall costs
- Avoid breach costs ($4.35M average)
- 15-minute deployment vs. weeks

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Technical Deep Dive (Optional)

How DCF Works:

Application → Spoke Gateway → DCF Evaluation → Transit → Destination
↓ 1. SmartGroup tag lookup 2. Policy match (priority order) 3. PERMIT/DENY decision 4. Log to CoPilot

SmartGroups Match On: AWS tags | Resource type (EC2, RDS, Lambda, EKS pods) | VPC/Region | IP CIDR | Combined (AND/OR)

Performance: <1ms latency | Line-rate throughput | 1000+ policies | Active-active HA

IaC: Full Terraform support. See repo: https://github.com/tatiLogg/aviatrix-blueprints

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next Steps

For Prospects:

1. POC Request: "Let's deploy in your environment"
2. Architecture Review: "Map your apps to SmartGroups"
3. Timeline: "POC in 2 weeks, production in 30 days"

For Customers:

- Expand to Azure/GCP
- EKS/Kubernetes segmentation
- Advanced analytics (FlowIQ integration)

Follow-Up Email:

Subject: Zero Trust Demo Follow-Up

Thanks for the demo! Here's what we covered:

- Zero Trust segmentation across VPCs
- SmartGroups tag-based automation
- Real-time traffic monitoring

Next: Identify 2-3 apps for POC. Schedule 30-min architecture review?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Screenshot Checklist

| Screenshot          | Location                     | What to Show                   |
| ------------------- | ---------------------------- | ------------------------------ |
| Topology            | Cloud Fabric > Topology      | All 4 gateways connected       |
| SmartGroups List    | Security > DCF > SmartGroups | 3 groups visible               |
| SmartGroup Detail   | Click dev-smartgroup         | Tag match + members            |
| DCF Rules           | Security > DCF > Rules       | 5 policies with priorities     |
| Policy Detail       | Click deny-dev-to-db         | Watch Mode highlighted         |
| FlowIQ              | Monitor > FlowIQ             | Traffic donut charts (32.3 kB) |
| Monitor - Denied    | DCF Monitor                  | dev→db DENIED entry            |
| Monitor - Permitted | DCF Monitor                  | prod→db PERMITTED entry        |
| Watch Mode          | Policy detail                | Watch Mode toggle              |

Screenshot Tips:

- Resolution: 1920x1080 minimum
- Hide: Personal info, account IDs
- Highlight: Use red boxes/arrows for key areas
- Annotate: Add text explaining what's shown

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Demo Tips

Opening Hook (30 sec):

> "Implement Zero Trust segmentation across all AWS VPCs in 15 minutes—without touching a security group."

During Demo:

- Ask questions: "Do you manage security groups today?"
- Relate to their use cases: "Similar to your dev/prod setup"
- Show, don't tell: Run live tests
- Pause for questions after each act

Closing:

> "DCF provides Zero Trust with SmartGroups, centralized policies, and real-time visibility. Let's schedule a 30-minute POC discussion for your environment next week."

Leave Behind: Demo recording + architecture diagram

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: 2.0 (Streamlined)
Last Updated: March 4, 2026
Review Date: June 4, 2026
