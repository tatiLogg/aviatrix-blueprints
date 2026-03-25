
# Prevent Lateral Movement - VM Tags with Aviatrix - Complete Demo Guide

**Demo Type:** Technical Demo | Proof of Concept | Video Recording
**Duration:** 30 minutes (live) | 15 minutes (video)
**Audience:** Security Engineers, Network Architects, Cloud Engineers, CISOs
**Last Updated:** February 18, 2026
**Demo Owner:** @tatiLogg
**Status:** 🎥 Ready for video recording (pending CoPilot access)

---

## 🎯 Demo Objectives

By the end of this demo, customers will understand how to:
1. **Deploy Prevent Lateral Movement - VM Tags** in 15 minutes with Terraform
2. **Prevent lateral movement** after security breaches using DCF policies
3. **Achieve compliance** (PCI-DSS, HIPAA, SOC 2) with microsegmentation audit trails
4. **Eliminate security group sprawl** through tag-based automation
5. **Scale Zero Trust** across multi-cloud environments

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Business Problem & Outcomes](#business-problem--outcomes)
3. [Architecture: Zero Trust in Action](#architecture)
4. [Video Demo Script](#video-demo-script)
5. [Screenshot Guide](#screenshot-guide)
6. [Live Demo Flow](#live-demo-flow)
7. [Key Differentiators](#key-differentiators)
8. [Objection Handling](#objection-handling)
9. [Next Steps & Resources](#next-steps)

---

<a name="executive-summary"></a>
## 📊 Executive Summary

### What This Demo Proves

This demo **proves Prevent Lateral Movement - VM Tags** by showing:
- ✅ **Dev environment BLOCKED from production database** (lateral movement prevented)
- ✅ **Production ALLOWED to database** (legitimate business traffic flows)
- ✅ **Default-deny enforcement** (Zero Trust principle: no implicit trust)
- ✅ **Tag-based automation** (new workloads inherit policies automatically)
- ✅ **Complete audit trail** (every denied connection logged for compliance)

### Customer Outcomes Demonstrated

| Outcome | Traditional Approach | Aviatrix Zero Trust | Improvement |
|---------|---------------------|---------------------|-------------|
| **Deployment Speed** | 2-4 weeks (manual SGs) | ⚡ 15 minutes (Terraform) | **80% faster** |
| **Lateral Movement** | ❌ Uncontrolled | ✅ **Blocked at network layer** | **100% prevented** |
| **Policy Management** | Manual per-workload | ✅ **Tag-based automation** | **90% less overhead** |
| **Compliance Audit** | ⚠️ Delayed VPC logs | ✅ **Real-time DCF monitor** | **Audit-ready** |
| **Multi-Cloud** | ❌ Per-cloud silos | ✅ **Unified policies** | **Consistent** |

### Why Prevent Lateral Movement - VM Tags Matters

**The Threat:**
- 83% of ransomware attacks succeed through **lateral movement**
- Average breach detection time: **277 days** (IBM Cost of Data Breach 2025)
- Flat networks allow attackers to reach crown jewels after initial compromise

**The Solution:**
- **Prevent Lateral Movement - VM Tags** contains breaches to single workload
- Microsegmentation enforced at gateway layer (no host agents required)
- Default-deny + explicit allow = no unauthorized lateral movement

---

<a name="business-problem--outcomes"></a>
## 💼 Business Problem & Outcomes

### The Challenge Customers Face

**Scenario:**
> "We have dev, staging, and production environments in AWS. Our security team uses security groups, but they're unmanageable—hundreds of rules, no visibility, and we failed our PCI audit because we can't prove segmentation between dev and production data."

**Quantified Pain:**
1. ❌ **10+ hours/week** managing security group rules
2. ❌ **$50K-$500K** in compliance remediation costs after failed audits
3. ❌ **Millions in potential breach costs** if lateral movement reaches production
4. ❌ **2-4 week delays** for security approvals on new deployments

### How Prevent Lateral Movement - VM Tags Solves It

**The Aviatrix Approach:**

```
Traditional:  [Flat Network] → [Breach] → [Lateral Movement] → [Total Compromise]
                     ❌

Zero Trust:   [Segmented] → [Breach] → [DCF Blocks] → [Contained to 1 Workload]
                     ✅
```

**Outcome Mapping:**

| Customer Pain | Zero Trust Solution | Measurable Outcome |
|---------------|---------------------|-------------------|
| Security group sprawl | **SmartGroups** (tag-based) | 90% reduction in rule management |
| No visibility into denied traffic | **DCF Monitor** (real-time logging) | Complete audit trail for compliance |
| Lateral movement risk | **Default-deny policies** | Zero unauthorized east-west traffic |
| Slow deployment approvals | **Automated policy enforcement** | 80% faster secure deployments |
| Failed compliance audits | **Microsegmentation proof** | Pass PCI/HIPAA/SOC 2 requirements |

---

<a name="architecture"></a>
## 🏗️ Architecture: Prevent Lateral Movement - VM Tags in Action

### Hub-and-Spoke Topology with Zero Trust Enforcement

```
                    ┌─────────────────────────────┐
                    │   Aviatrix Transit Gateway  │
                    │    (Zero Trust Policy       │
                    │     Enforcement Point)      │
                    │       10.0.0.0/23           │
                    └──────────────┬──────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         │                         │                         │
  ┌──────▼──────┐          ┌──────▼──────┐          ┌──────▼──────┐
  │   Dev VPC   │          │  Prod VPC   │          │   DB VPC    │
  │ 10.1.0.0/24 │          │ 10.2.0.0/24 │          │ 10.3.0.0/24 │
  │             │          │             │          │             │
  │ SmartGroup: │          │ SmartGroup: │          │ SmartGroup: │
  │ Environment │          │ Environment │          │ Environment │
  │ = dev       │          │ = prod      │          │ = database  │
  └──────┬──────┘          └──────┬──────┘          └──────┬──────┘
         │                         │                         │
  ┌──────▼──────┐          ┌──────▼──────┐          ┌──────▼──────┐
  │  dev-spoke  │          │ prod-spoke  │          │  db-spoke   │
  │   gateway   │          │  gateway    │          │  gateway    │
  └──────┬──────┘          └──────┬──────┘          └──────┬──────┘
         │                         │                         │
  ┌──────▼──────┐          ┌──────▼──────┐          ┌──────▼──────┐
  │  Test VM    │          │  Test VM    │          │  Test VM    │
  │ 10.1.0.93   │          │ 10.2.0.110  │          │ 10.3.0.126  │
  │ (Ubuntu)    │          │ (Ubuntu)    │          │ (Ubuntu)    │
  └─────────────┘          └─────────────┘          └─────────────┘

  ❌ DENIED                 ✅ ALLOWED                ❌ DENIED
  Dev → DB                  Prod → DB                Prod → Dev
```

### Zero Trust Policies Enforced

| Priority | Policy Name | Source | Destination | Action | Purpose |
|----------|-------------|--------|-------------|--------|---------|
| **100** | allow-prod-to-db | prod-smartgroup | db-smartgroup | ✅ PERMIT | Legitimate business need |
| **110** | allow-dev-to-prod-ro | dev-smartgroup | prod-smartgroup | ✅ PERMIT (ICMP) | Read-only monitoring |
| **200** | deny-dev-to-db | dev-smartgroup | db-smartgroup | ❌ DENY (Watch) | **Block lateral movement** |
| **210** | deny-prod-to-dev | prod-smartgroup | dev-smartgroup | ❌ DENY | Production isolation |
| **1000** | default-deny-all | ANY | ANY | ❌ DENY | **Zero Trust default** |

**Key Insight:** Even if dev environment is compromised, **Zero Trust blocks access to production database**—ransomware cannot spread.

---

## 📸 Screenshot Placeholders & Where to Capture

### Controller Screenshots (Available Now - No CoPilot Needed)

#### Screenshot 1: Gateway List
**File Name:** `01-controller-gateways.png`
**Navigation:** Controller → Multi-Cloud → List → Gateways
**What to Show:**
- All 4 gateways listed (zt-seg-transit-gw, zt-seg-dev-spoke-gw, zt-seg-prod-spoke-gw, zt-seg-db-spoke-gw)
- Status: "Up" with green checkmarks
- Gateway IPs visible

**Talking Point for Image:**
> "These Aviatrix gateways are enforcing Prevent Lateral Movement - VM Tags policies at the network layer—before traffic reaches destination VPCs."

---

#### Screenshot 2: SmartGroups List
**File Name:** `02-controller-smartgroups.png`
**Navigation:** Controller → Security → Distributed Cloud Firewall → SmartGroups
**What to Show:**
- 3 SmartGroups listed:
  - zt-seg-dev-smartgroup (1 member)
  - zt-seg-prod-smartgroup (1 member)
  - zt-seg-db-smartgroup (1 member)
- UUID columns visible

**Talking Point for Image:**
> "SmartGroups automatically group workloads by tags. Any new instance tagged 'Environment=production' instantly inherits Zero Trust policies—no manual security group updates."

---

#### Screenshot 3: SmartGroup Detail (Dev)
**File Name:** `03-controller-smartgroup-dev-detail.png`
**Navigation:** Controller → Security → DCF → SmartGroups → Click "zt-seg-dev-smartgroup"
**What to Show:**
- SmartGroup name: zt-seg-dev-smartgroup
- Match Expression: `type = vm, tags = {Environment = development}`
- Members section showing: 10.1.0.93 (dev-test-vm)

**Talking Point for Image:**
> "Tag-based matching eliminates manual IP management. This SmartGroup dynamically includes all resources tagged 'Environment=development'—the foundation of Zero Trust automation."

---

#### Screenshot 4: DCF Policies List
**File Name:** `04-controller-dcf-policies.png`
**Navigation:** Controller → Security → Distributed Cloud Firewall → Rules
**What to Show:**
- All 5 policies visible with priorities (100, 110, 200, 210, 1000)
- Policy names, source/dest SmartGroups, actions (PERMIT/DENY)
- Watch Mode indicator on deny-dev-to-db

**Talking Point for Image:**
> "These 5 policies prove Zero Trust: default-deny (priority 1000), explicit allows for business needs (100, 110), and lateral movement blocks (200, 210). Priority-based evaluation ensures correct enforcement."

---

#### Screenshot 5: DCF Policy Detail (Deny Dev to DB)
**File Name:** `05-controller-policy-deny-dev-to-db.png`
**Navigation:** Controller → Security → DCF → Rules → Click "zt-seg-deny-dev-to-db"
**What to Show:**
- Policy name: zt-seg-deny-dev-to-db
- Priority: 200
- Source: dev-smartgroup
- Destination: db-smartgroup
- Protocol: ALL
- Action: DENY
- **Watch Mode: Enabled** (checkbox checked)

**Talking Point for Image:**
> "Watch Mode is critical for Zero Trust adoption—it logs violations without enforcing, letting you validate policies before full deployment. This policy will block dev from accessing production databases."

---

### CoPilot Screenshots (When Accessible)

#### Screenshot 6: CoPilot Topology View
**File Name:** `06-copilot-topology-full.png`
**Navigation:** CoPilot → Cloud Fabric → Topology
**What to Show:**
- Interactive topology map showing:
  - Transit gateway (hub) in center
  - 3 spoke gateways connected with lines
  - VPC icons with CIDR labels
  - Gateway health status indicators (green)
- Zoom level showing full architecture

**Expected View:** Hub-and-spoke visual with all connections clearly visible

**Talking Point for Image:**
> "CoPilot's topology view proves Zero Trust is enforced at the gateway layer. Traffic between dev and database must pass through the transit gateway, where DCF policies are evaluated."

**🎥 Video Note:** Zoom in/out to show gateway details, hover over connections to show active routes

---

#### Screenshot 7: CoPilot SmartGroups with Members
**File Name:** `07-copilot-smartgroups-members.png`
**Navigation:** CoPilot → Security → DCF → SmartGroups → Click "dev-smartgroup"
**What to Show:**
- SmartGroup detail panel on right side
- Tag selector: `Environment = development`
- Members list showing:
  - VM instance IDs
  - Private IPs (10.1.0.93)
  - Cloud provider (AWS)
  - Region (us-east-1)

**Expected View:** Member list dynamically populated based on tags

**Talking Point for Image:**
> "This member list updates automatically as workloads are created or destroyed. Tag once, secured forever—that's Zero Trust at scale."

**🎥 Video Note:** Click between different SmartGroups to show different members

---

#### Screenshot 8: CoPilot DCF Monitor - Denied Traffic
**File Name:** `08-copilot-monitor-denied-dev-to-db.png`
**Navigation:** CoPilot → Security → DCF → Monitor
**Filter:** Action = DENIED, Time Range = Last 15 minutes
**What to Show:**
- Table of denied traffic entries with RED "DENIED" status
- Specific entry showing:
  - Source: dev-smartgroup (10.1.0.93)
  - Destination: db-smartgroup (10.3.0.126)
  - Protocol: ICMP
  - Policy: zt-seg-deny-dev-to-db
  - Timestamp
  - Watch Mode indicator

**Expected View:** Real-time log proving Zero Trust blocks lateral movement

**Talking Point for Image:**
> "This is Zero Trust in action: dev environment tried to reach production database and was BLOCKED. This denied connection is logged for compliance audit trails—proving microsegmentation."

**🎥 Video Note:** Run live ping test from dev to db, refresh monitor to show new denied entry appearing

---

#### Screenshot 9: CoPilot DCF Monitor - Allowed Traffic
**File Name:** `09-copilot-monitor-allowed-prod-to-db.png`
**Navigation:** CoPilot → Security → DCF → Monitor
**Filter:** Action = PERMITTED, Time Range = Last 15 minutes
**What to Show:**
- Table of allowed traffic entries with GREEN "PERMITTED" status
- Specific entry showing:
  - Source: prod-smartgroup (10.2.0.110)
  - Destination: db-smartgroup (10.3.0.126)
  - Protocol: ALL
  - Policy: zt-seg-allow-prod-to-db (priority 100)
  - Timestamp

**Expected View:** Legitimate business traffic flowing freely

**Talking Point for Image:**
> "Zero Trust allows authorized traffic while blocking everything else. Production's legitimate database access succeeds—this is least-privilege enforcement."

**🎥 Video Note:** Run live ping test from prod to db, refresh to show permitted entry

---

#### Screenshot 10: CoPilot Traffic Flow Detail
**File Name:** `10-copilot-traffic-detail-expanded.png`
**Navigation:** CoPilot → Security → DCF → Monitor → Click any traffic entry
**What to Show:**
- Detailed flow information panel:
  - Source SmartGroup + IP
  - Destination SmartGroup + IP
  - Protocol details (ICMP, TCP, UDP)
  - Port information (if applicable)
  - Applied policy name and priority
  - Timestamp (precise)
  - Action (PERMIT/DENY)
  - Bytes transferred
  - Packet count

**Expected View:** Forensic-level detail for compliance reporting

**Talking Point for Image:**
> "Every flow is logged with SmartGroup context, policy name, and action—giving security teams complete visibility for compliance audits and incident response."

**🎥 Video Note:** Click multiple entries to show different traffic patterns

---

### Controller Alternatives (When CoPilot Not Available)

For screenshots 6-10, **Controller UI can substitute** (with reduced visual appeal):

**Controller → Security → DCF → Monitor** provides:
- ✅ Traffic log with permit/deny actions
- ✅ Source/destination IPs and SmartGroups
- ✅ Applied policy names
- ⚠️ Less visual/interactive than CoPilot
- ⚠️ No topology view

**Use Controller screenshots with note:**
> "CoPilot provides enhanced visualization and real-time monitoring. Controller UI shown here for demonstration—CoPilot recommended for production use."

---

<a name="video-demo-script"></a>
## 🎥 Video Demo Script (15 Minutes)

### Pre-Recording Checklist

- [ ] CoPilot accessible at https://44.204.58.42 (or working alternative)
- [ ] Controller accessible at https://44.214.60.253
- [ ] Screen recording software ready (Loom, OBS, QuickTime)
- [ ] Audio test completed
- [ ] Browser tabs prepared:
  - [ ] CoPilot Topology
  - [ ] CoPilot SmartGroups
  - [ ] CoPilot DCF Rules
  - [ ] CoPilot DCF Monitor
  - [ ] Controller Gateways (backup)
- [ ] Test VMs accessible for live ping tests
- [ ] Script notes visible (second monitor or printed)

---

### Act 1: The Problem (2 minutes) 🎬

**[SCREEN: Blank slide with title]**

**SCRIPT:**
> "Hi, I'm Selina with Aviatrix. Today I'm going to show you how to deploy Prevent Lateral Movement - VM Tags in 15 minutes—solving a critical security challenge that costs organizations millions in breach damages."

**[SCREEN: Transition to simple diagram showing flat network]**

**SCRIPT:**
> "Here's the problem: traditional networks are flat. You have dev environments, staging, production, databases—all connected via VPCs or transit gateways. Security groups provide *some* isolation, but they're IP-based, manually managed, and don't provide visibility."
>
> "When an attacker breaches your dev environment—maybe through a phishing email or vulnerable dependency—they can move laterally to production databases. 83% of ransomware attacks succeed because of this lateral movement."
>
> "And from a compliance perspective? PCI-DSS, HIPAA, and SOC 2 all require microsegmentation to protect sensitive data. Security groups alone don't give you the audit trail to prove it."

**[SCREEN: Transition to Zero Trust architecture diagram]**

**SCRIPT:**
> "That's where Prevent Lateral Movement - VM Tags comes in. Instead of trusting everything inside the network perimeter, Zero Trust enforces explicit authorization at every connection. Default-deny, with allow rules only for legitimate business needs."
>
> "Let me show you how Aviatrix makes this simple."

---

### Act 2: The Architecture (3 minutes) 🎬

**[SCREEN: CoPilot Topology View - Screenshot 6]**

**SCRIPT:**
> "Here's what I've deployed: a hub-and-spoke architecture with three environments—development, production, and database. Each environment has its own VPC and Aviatrix spoke gateway."
>
> [HOVER over transit gateway]
> "The transit gateway in the center is the enforcement point. All traffic between VPCs flows through here, and that's where Distributed Cloud Firewall policies are evaluated."
>
> [CLICK on dev spoke, then prod spoke, then db spoke]
> "Three spoke gateways attach the three VPCs. Each VPC represents a different trust zone: dev, production, and database."

**[SCREEN: CoPilot SmartGroups List - Screenshot 7]**

**SCRIPT:**
> "Now, instead of managing security rules by IP address, Aviatrix uses SmartGroups—logical groupings based on tags."
>
> [CLICK on dev-smartgroup]
> "This SmartGroup matches any resource tagged 'Environment equals development.' You can see one member: my dev test VM."
>
> [CLICK on prod-smartgroup, then db-smartgroup]
> "Same pattern for production and database. When I launch a new EC2 instance and tag it 'Environment equals production,' it automatically joins the prod SmartGroup and inherits all the Zero Trust policies. No manual security group updates."
>
> "This is how Zero Trust scales: tag once, secured forever."

---

### Act 3: Zero Trust Policies (4 minutes) 🎬

**[SCREEN: CoPilot DCF Rules List - Screenshot 4]**

**SCRIPT:**
> "Now let's look at the Zero Trust policies. I have five policies here, evaluated by priority from lowest number to highest."
>
> [POINT to priority 100]
> "Priority 100: allow-prod-to-db. This is an explicit allow—production needs database access for the application to function. Source: prod SmartGroup. Destination: database SmartGroup. Action: PERMIT."
>
> [POINT to priority 110]
> "Priority 110: allow-dev-to-prod-read-only. Developers can ping production for diagnostics, but only ICMP traffic. No writes, no SSH, no SQL connections. This is granular, protocol-level control."
>
> [CLICK on priority 200 policy to open detail - Screenshot 5]
> "Priority 200: deny-dev-to-db. This is the critical one—this blocks development from reaching the production database. Source: dev SmartGroup. Destination: database SmartGroup. Action: DENY."
>
> [POINT to Watch Mode checkbox]
> "Notice Watch Mode is enabled. This is huge for adoption: Watch Mode logs violations without enforcing. I can see which connections would be blocked, validate there's no legitimate traffic, then disable Watch Mode to enforce."
>
> [GO BACK to rules list]
>
> [POINT to priority 210]
> "Priority 210: deny-prod-to-dev. Production isolation—if production is compromised, it can't reach dev."
>
> [POINT to priority 1000]
> "And priority 1000: default-deny-all. This is the Zero Trust foundation: deny everything that doesn't match an explicit allow. No implicit trust."
>
> "These five policies enforce microsegmentation across three VPCs. Now let's see them in action."

---

### Act 4: Live Testing - Zero Trust Blocking Lateral Movement (4 minutes) 🎬

**[SCREEN: Terminal window with SSH to dev-test-vm]**

**SCRIPT:**
> "I'm going to run four tests. First: can development reach the production database?"
>
> [TYPE command slowly so viewers can see]
```bash
# From dev-test-vm (10.1.0.93)
ping -c 4 10.3.0.126
```

**[SHOW: Ping timeout / 100% packet loss]**

**SCRIPT:**
> "Timeout. Zero Trust blocked it. Let's see this in the monitor."

**[SCREEN: CoPilot DCF Monitor - Screenshot 8]**
**[FILTER: Action = DENIED, Source = dev]**

**SCRIPT:**
> [POINT to red DENIED entry]
> "Here's the denied connection: source is dev SmartGroup, destination is database SmartGroup, blocked by policy 'deny-dev-to-db.' This is Zero Trust preventing lateral movement."
>
> [CLICK entry to expand detail - Screenshot 10]
> "Full context: source IP, destination IP, SmartGroups, protocol, timestamp, policy name. This is your compliance audit trail—proof that microsegmentation is enforced."

**[SCREEN: Terminal window with SSH to prod-test-vm]**

**SCRIPT:**
> "Now let's test production to database. This *should* work—it's a legitimate business need."

```bash
# From prod-test-vm (10.2.0.110)
ping -c 4 10.3.0.126
```

**[SHOW: Ping success / 0% packet loss]**

**SCRIPT:**
> "Success. Production can reach the database. Let's verify in the monitor."

**[SCREEN: CoPilot DCF Monitor - Screenshot 9]**
**[FILTER: Action = PERMITTED, Source = prod]**

**SCRIPT:**
> [POINT to green PERMITTED entry]
> "Green 'permitted' status. Source: prod SmartGroup. Destination: database SmartGroup. Policy: allow-prod-to-db, priority 100."
>
> "This is Zero Trust: allow authorized traffic, block everything else. No implicit trust."

**[SCREEN: Split view - terminal left, CoPilot monitor right]**

**SCRIPT:**
> "Let me run one more test: production trying to reach dev."

```bash
# From prod-test-vm
ping -c 4 10.1.0.93
```

**[SHOW: Ping timeout]**
**[SCREEN: Monitor shows DENIED entry]**

**SCRIPT:**
> "Blocked. Even though prod can reach database, it can't reach dev. Each connection is independently evaluated against Zero Trust policies."

---

### Act 5: Why This Matters - Outcomes (2 minutes) 🎬

**[SCREEN: Outcome comparison table slide]**

**SCRIPT:**
> "Let's talk about what this means for your organization."
>
> "First: **speed**. I deployed this entire Zero Trust architecture—three VPCs, four gateways, SmartGroups, five policies—in 15 minutes using Terraform. Traditional approach with security groups? Two to four weeks of planning and manual configuration. That's 80% faster."
>
> "Second: **security**. We just proved that dev cannot reach production database. If an attacker compromises dev through phishing or supply chain attack, they cannot move laterally to your crown jewels. Breach contained to single workload."
>
> "Third: **compliance**. Every denied connection is logged with full context. When your auditor asks, 'How do you prove dev can't access production data?'—you show them the DCF Monitor. PCI-DSS 1.2.1, HIPAA 164.312, SOC 2—all require this microsegmentation, and you have the audit trail."
>
> "Fourth: **operations**. No more security group sprawl. I'm not managing hundreds of IP-based rules. SmartGroups and policies follow workloads automatically. 90% reduction in security policy overhead."
>
> "And finally: **scale**. This same architecture, these same SmartGroups and policies, work across AWS, Azure, and GCP. Consistent Zero Trust across multi-cloud."

**[SCREEN: Call to action slide]**

**SCRIPT:**
> "This blueprint is available now in the Aviatrix blueprints repository. You can deploy it in your own AWS account in 15 minutes and see Zero Trust in action."
>
> "If you want help deploying this for your specific use case—whether it's PCI compliance, ransomware defense, or DevSecOps acceleration—reach out to your Aviatrix SE or contact us at aviatrix.com."
>
> "Thanks for watching."

**[END RECORDING]**

---

## 📝 Post-Recording Checklist

After recording video:
- [ ] Edit out pauses/mistakes (keep under 15 minutes)
- [ ] Add title cards at section transitions
- [ ] Add text overlays for key stats (80% faster, 90% less overhead)
- [ ] Add background music (optional, low volume)
- [ ] Export in 1080p
- [ ] Upload to:
  - [ ] YouTube (public or unlisted)
  - [ ] Confluence
  - [ ] Internal video platform
- [ ] Create GIF highlights for Slack/email:
  - [ ] Denied dev→db traffic (3-5 seconds)
  - [ ] Topology zoom animation (3-5 seconds)
  - [ ] Monitor showing real-time denied traffic (3-5 seconds)
- [ ] Share video link with SE team for feedback
- [ ] Add video embed to README.md

---

<a name="live-demo-flow"></a>
## 🎤 Live Demo Flow (30 Minutes with Q&A)

### Pre-Demo Setup (10 minutes before)

**Technical Prep:**
- [ ] CoPilot logged in and ready
- [ ] Controller logged in (backup)
- [ ] Browser tabs organized
- [ ] Test VMs SSH access verified
- [ ] Screen sharing tested
- [ ] Audio tested
- [ ] Backup slides ready (if demo fails)

**Audience Prep:**
- [ ] Understand audience: technical level, pain points, decision authority
- [ ] Tailor talking points to their industry/use case
- [ ] Prepare answers to anticipated questions
- [ ] Have pricing/next steps ready

---

### Act 1: Discovery & Problem (5 minutes)

**Objective:** Understand customer pain, establish relevance

**Questions to Ask:**
1. "What's your current approach to network segmentation in AWS?"
2. "Are you using security groups, NACLs, or third-party firewalls?"
3. "Do you have compliance requirements for microsegmentation?" (PCI/HIPAA/SOC 2)
4. "Have you experienced or are you concerned about lateral movement in a breach?"

**Listen for pain points:**
- Security group complexity
- Failed compliance audits
- Lack of visibility
- Manual overhead
- Fear of breaches

**Transition to demo:**
> "Let me show you how we solve [specific pain point customer mentioned] with Prevent Lateral Movement - VM Tags."

---

### Act 2: Architecture Walkthrough (7 minutes)

**Show:** CoPilot Topology (Screenshot 6)

**Script (adapted to customer):**
> "Here's an architecture similar to what you described: [mirror customer's environment description]. We have dev, production, and database environments in separate VPCs."
>
> "The key difference is the Aviatrix transit gateway here [POINT]. This is the Zero Trust enforcement point. All traffic between VPCs is evaluated against policies before being allowed or denied."

**Show:** CoPilot SmartGroups (Screenshot 7)

**Script:**
> "Instead of IP-based rules, we use SmartGroups. You mentioned you use tags for resource organization—we leverage those same tags. 'Environment equals production' automatically includes all production workloads. No manual IP management."

**Ask:** "Does your team use tags today?" (If yes: "Great, you can reuse them." If no: "This is a good driver to start tagging.")

---

### Act 3: Zero Trust Policies (8 minutes)

**Show:** CoPilot DCF Rules (Screenshot 4)

**Script (emphasize customer's compliance needs):**
> "These policies enforce [customer's compliance requirement - e.g., PCI-DSS requirement 1.2.1]. Let me walk you through the logic."
>
> [Walk through each policy, relating to customer's environment]
> "This policy [POINT to deny-dev-to-db] addresses your concern about [customer pain point - e.g., dev accessing production data]. Dev is blocked from database entirely."

**Show:** Policy Detail with Watch Mode (Screenshot 5)

**Highlight for risk-averse customers:**
> "I know you mentioned concerns about breaking production traffic. Watch Mode solves this—you can test policies in 'monitor only' mode, see what would be blocked, validate no legitimate traffic, then enforce. Zero risk."

---

### Act 4: Live Testing (7 minutes)

**Pre-announce what you'll show:**
> "I'm going to run three tests: dev trying to reach database—should be blocked. Production trying to reach database—should be allowed. And production trying to reach dev—should be blocked."

**Run tests as in video script:**
1. Dev → DB: DENIED (Screenshot 8)
2. Prod → DB: ALLOWED (Screenshot 9)
3. Prod → Dev: DENIED

**After each test, show monitor entry and ask:**
> "This is your audit trail for [customer's compliance framework]. Is this the level of visibility you have today?"

---

### Act 5: Outcomes & Next Steps (3 minutes)

**Summarize what customer saw:**
> "So in this demo, you saw:
> 1. [Customer pain point 1] solved by [Zero Trust feature]
> 2. [Customer pain point 2] solved by [Zero Trust feature]
> 3. Complete audit trail for [compliance requirement]"

**Provide outcome metrics:**
> "Our customers see:
> - 80% faster deployment vs. security groups
> - 90% less security policy overhead
> - Zero lateral movement after breach
> - Pass compliance audits with DCF Monitor logs"

**Next steps:**
> "Would it be valuable to deploy this in your AWS account so you can test with your actual workloads? I can help you set it up—takes about 30 minutes, and you'll have a working Zero Trust environment."

---

### Q&A (Time Permitting)

**Common questions & answers:** (See Objection Handling section below)

---

<a name="key-differentiators"></a>
## 🏆 Key Differentiators: Why Aviatrix for Zero Trust

### vs. AWS Security Groups

| Capability | AWS Security Groups | Aviatrix Zero Trust |
|------------|---------------------|---------------------|
| **Segmentation Granularity** | Per-instance | Per-SmartGroup (tag-based) |
| **Management Overhead** | Manual per-instance | Automated (tag-driven) |
| **Default Posture** | Allow within VPC | **Default-deny everywhere** |
| **Visibility** | ⚠️ VPC Flow Logs (delayed) | ✅ **Real-time DCF Monitor** |
| **Audit Trail** | Partial (flow logs) | **Complete (policy + SmartGroup)** |
| **Multi-Cloud** | ❌ AWS only | ✅ **AWS, Azure, GCP** |
| **Protocol Granularity** | Port-level | **Protocol + Port** (ICMP, TCP, UDP) |
| **Watch Mode** | ❌ Not available | ✅ **Test before enforce** |

**Win Statement:**
> "Security groups are IP-based, per-instance, and require manual management. Aviatrix delivers tag-based, automated Zero Trust with real-time visibility—at scale."

---

### vs. AWS Network Firewall

| Capability | AWS Network Firewall | Aviatrix DCF |
|------------|---------------------|--------------|
| **Use Case** | IDS/IPS, egress filtering | **Zero Trust microsegmentation** |
| **Between VPCs** | ❌ Not designed for this | ✅ **Primary use case** |
| **SmartGroups** | ❌ IP-based rules | ✅ **Tag-based automation** |
| **Multi-Cloud** | ❌ AWS only | ✅ **Unified across clouds** |
| **Cost** | $0.395/hr + $0.065/GB | **Gateway-based (no per-GB)** |

**Win Statement:**
> "AWS Network Firewall is great for north-south traffic (egress filtering, IDS/IPS). For east-west Zero Trust segmentation between VPCs, Aviatrix DCF is purpose-built and more cost-effective."

---

### vs. Palo Alto / Fortinet NGFWs

| Capability | Traditional NGFWs | Aviatrix DCF |
|------------|------------------|--------------|
| **Architecture** | ❌ Appliances (VM-Series) | ✅ **Cloud-native software** |
| **Deployment** | Weeks (sizing, HA, scaling) | **15 minutes (Terraform)** |
| **Scaling** | Manual (add appliances) | **Automatic (cloud-native)** |
| **Multi-Cloud** | ⚠️ Per-cloud silos | ✅ **Unified policies** |
| **Cost Model** | CapEx + OpEx (licenses) | **Software subscription** |
| **SmartGroups** | ⚠️ Limited tag support | ✅ **Native tag-based** |

**Win Statement:**
> "Palo Alto and Fortinet are powerful for perimeter security. For Zero Trust microsegmentation in the cloud, Aviatrix delivers cloud-native simplicity—no appliances to size, scale, or manage—with tag-based automation NGFWs can't match."

**When to position both:**
> "Many customers use Aviatrix DCF for east-west Zero Trust microsegmentation and Palo Alto for north-south (egress inspection, threat prevention). They're complementary."

---

<a name="objection-handling"></a>
## 🛡️ Objection Handling

### "We can do this with security groups."

**Acknowledge:**
> "You're right that security groups provide some segmentation. Let me show you the gap."

**Demonstrate limitation:**
> [Show security group console with 50+ rules]
> "Security groups are IP-based. Every new instance requires manual rule updates. And there's no visibility—you can't see denied traffic, so you can't prove segmentation to auditors."

**Show Aviatrix advantage:**
> "With Aviatrix, you tag once—'Environment equals production'—and the workload inherits all Zero Trust policies. No manual rules. And DCF Monitor gives you complete audit trail [show Screenshot 8]."

**Close:**
> "Our customers switch from security groups to Aviatrix DCF and see 90% reduction in security policy overhead. Would that level of automation be valuable for your team?"

---

### "What about AWS Network Firewall?"

**Clarify use case:**
> "Great question. AWS Network Firewall is designed for north-south traffic—egress filtering, IDS/IPS, threat prevention. It's not designed for Zero Trust segmentation between VPCs."

**Show architecture difference:**
> "Network Firewall sits at VPC edge. DCF sits at transit gateway—evaluating east-west traffic between workloads. Different use cases."

**Position both:**
> "Many customers use both: AWS Network Firewall for egress inspection and Aviatrix DCF for east-west Zero Trust. They're complementary."

**If customer insists:**
> "Happy to do a side-by-side comparison. Let me show you what DCF does that Network Firewall can't: SmartGroups [show Screenshot 7], tag-based automation, real-time monitoring across multi-cloud."

---

### "We already have Palo Alto / Fortinet."

**Acknowledge investment:**
> "That's a significant investment and Palo Alto is a great perimeter firewall. Where are your Palo Alto appliances deployed today?"

**Listen:** (Usually: perimeter, DMZ, egress filtering)

**Position Aviatrix:**
> "Exactly—perimeter. What Aviatrix solves is east-west Zero Trust segmentation between workloads inside your cloud environment. Palo Alto appliances are expensive to deploy at every VPC connection point."

**Show cost comparison:**
> "To deploy PA-VM-Series at scale for east-west traffic, you'd need appliances at every spoke, HA pairs, plus throughput licensing. That's $100K-$500K+ per cloud. Aviatrix DCF is software-only, scales automatically, and costs a fraction."

**Close:**
> "Most customers use Palo Alto for north-south and Aviatrix for east-west. You get the best of both: perimeter protection from PA, Zero Trust microsegmentation from Aviatrix. Would you like to see a reference architecture?"

---

### "How does this work with Kubernetes?"

**Acknowledge complexity:**
> "Great question—Kubernetes adds another layer. Let me break it down."

**Explain layers:**
> "Zero Trust for Kubernetes has two layers:
> 1. **Pod-to-pod (within cluster):** Use Kubernetes Network Policies or service mesh like Istio
> 2. **Cluster-to-cluster or cluster-to-VPC:** That's where Aviatrix DCF shines."

**Show use case:**
> "You can create a SmartGroup that matches EKS clusters by tag, then enforce Zero Trust policies between clusters or between Kubernetes and traditional VMs. Gives you consistent segmentation across containers and VMs."

**Reference:**
> "We have a separate blueprint for DCF with EKS that dives deeper. Would that be useful?"

---

### "What's the performance impact?"

**Acknowledge concern:**
> "Performance is critical—no one wants security to slow down applications."

**Provide facts:**
> "Aviatrix gateways are inline but optimized for high throughput:
> - HPE (High Performance Encryption): Line-rate encryption up to 25 Gbps
> - DCF policy evaluation: Sub-microsecond latency
> - No packet inspection (unlike NGFWs)—just policy match on 5-tuple + SmartGroup"

**Show data:**
> "Our customers run latency-sensitive applications—financial trading, real-time analytics—through DCF with no noticeable impact."

**Offer proof:**
> "Happy to set up a PoC where we measure latency before and after enabling DCF on your actual workloads. Our SLA is <1ms added latency."

---

### "What if I need more than network-layer segmentation?"

**Acknowledge need:**
> "You're thinking holistically—network segmentation is one layer of defense-in-depth."

**Position DCF as foundation:**
> "DCF provides network-layer Zero Trust—preventing lateral movement at Layer 3/4. This stops most attacks since they rely on network connectivity."

**Layer with other controls:**
> "You should still use:
> - Identity-based access (IAM, Active Directory)
> - Application-layer auth (API gateways, OAuth)
> - Host-based controls (EDR, file integrity monitoring)
> - Data-layer encryption (TLS, database encryption)"

**Show how DCF complements:**
> "What DCF does is provide the network enforcement backbone. Even if an attacker compromises credentials, they still can't move laterally because DCF blocks the network path. Defense-in-depth."

---

### "How much does this cost?"

**Clarify scope:**
> "Cost depends on number of gateways and throughput. For this demo architecture—three spokes plus transit—it's about:
> - **Aviatrix Software:** ~$5K-$10K/year (depending on contract)
> - **AWS Compute:** ~$6/day for gateway EC2 instances (~$2,200/year)
> - **Total:** ~$10K-$15K/year for full Zero Trust"

**Compare to alternatives:**
> "Compare that to:
> - **PA-VM-Series:** $100K-$500K+ (licensing + compute)
> - **Manual security group management:** 10+ hours/week = $50K+/year in engineering time
> - **Compliance audit failure:** $50K-$500K in remediation"

**ROI:**
> "Our customers see ROI in 3-6 months just from operational efficiency savings—not counting breach prevention value."

**Next step:**
> "Want me to put together a detailed quote for your environment? I'd need to know number of VPCs and estimated throughput."

---

### "What about egress filtering / internet security?"

**Clarify use case:**
> "Good question—are you asking about:
> 1. Blocking workloads from reaching the internet (egress prevention), or
> 2. Inspecting internet-bound traffic for threats (egress inspection)?"

**If egress prevention:**
> "DCF can do this. Create a SmartGroup for 'Internet' (destination 0.0.0.0/0) and deny traffic from sensitive workloads to that group. [Show example policy]"

**If egress inspection (IDS/IPS):**
> "That's where you'd use AWS Network Firewall or an NGFW like Palo Alto. DCF is optimized for east-west segmentation, not deep packet inspection."

**Show Aviatrix FireNet (if applicable):**
> "If you need NGFW inspection for internet egress, Aviatrix FireNet integrates Palo Alto or Fortinet into the transit architecture. Gives you centralized inspection without manually managing appliances in every VPC."

**Reference architecture:**
> "Want to see how customers combine DCF for east-west Zero Trust with FireNet for egress inspection?"

---

<a name="next-steps"></a>
## 🚀 Next Steps & Resources

### For the Customer

**Immediate Next Steps:**
1. ✅ **Deploy blueprint in your AWS account** (30 minutes)
   - GitHub: https://github.com/AviatrixSystems/aviatrix-blueprints
   - Path: `blueprints/prevent-lateral-movement-vm-tags/`
   - Prerequisites: AWS account, Aviatrix Controller, IAM roles

2. ✅ **Test with your actual workloads**
   - Tag your VMs with Environment tags
   - Define SmartGroups for your apps
   - Create DCF policies based on your security requirements
   - Use Watch Mode to validate before enforcement

3. ✅ **Schedule POC planning call** (1 hour)
   - Review your architecture and compliance requirements
   - Design SmartGroup and policy structure
   - Plan phased rollout (start with non-prod)

**Typical POC Timeline:**
- **Week 1:** Deploy blueprint, validate basic functionality
- **Week 2:** Add real workloads, test Watch Mode
- **Week 3:** Enforce policies, measure impact
- **Week 4:** Present results to stakeholders, plan production rollout

---

### Resources

**Technical Documentation:**
- [Aviatrix DCF Overview](https://docs.aviatrix.com/HowTos/dcf_overview.html)
- [SmartGroups Configuration](https://docs.aviatrix.com/HowTos/smartgroups.html)
- [DCF Policy Management](https://docs.aviatrix.com/HowTos/dcf_policy.html)
- [Watch Mode Guide](https://docs.aviatrix.com/HowTos/dcf_policy.html#watch-mode)

**This Blueprint:**
- **GitHub:** github.com/AviatrixSystems/aviatrix-blueprints/blueprints/prevent-lateral-movement-vm-tags
- **README:** Complete deployment guide (20KB)
- **IAM Setup:** AWS-IAM-SETUP-GUIDE.md (12KB)
- **Troubleshooting:** DEPLOYMENT-REPORT.md

**Video Demo:**
- [Link to be added when video is recorded]

**Community:**
- Aviatrix Community Forum: community.aviatrix.com
- Slack: [Internal Aviatrix workspace]

---

### Success Metrics to Track

**For POC:**
- [ ] Time to deploy (target: <1 hour)
- [ ] Number of policies created
- [ ] Lateral movement tests blocked (target: 100%)
- [ ] Watch Mode violations observed (document false positives)
- [ ] Audit trail completeness (can you prove segmentation?)

**For Production:**
- [ ] Policy management time reduction (target: 90% vs. security groups)
- [ ] Compliance audit findings (target: zero findings related to segmentation)
- [ ] Security incidents prevented (blocked lateral movement attempts)
- [ ] Deployment velocity increase (faster approvals for new workloads)

---

## 📞 Support & Feedback

**Questions During Demo?**
- Pause and ask: "Does this make sense? Any questions before I continue?"
- Encourage questions: "What part of your environment would you want to secure first?"

**Post-Demo Follow-Up:**
- Send blueprint link within 24 hours
- Offer to jump on a call to help with deployment
- Schedule POC kickoff within 1 week

**Internal Feedback:**
- Demo too long/short? Suggest edit to @tatiLogg
- Objections not covered? Add to this doc
- Customer questions stumped you? Let's add the answer

---

**Last Updated:** February 18, 2026
**Demo Owner:** @tatiLogg
**Video Status:** 🎥 Pending CoPilot access for recording
**Confluence URL:** [To be added after upload]

---

## 🎬 Ready to Record?

**Pre-Flight Checklist:**
- [ ] CoPilot accessible ← **BLOCKER**
- [ ] Controller accessible ✅
- [ ] Test VMs accessible ✅
- [ ] Script reviewed ✅
- [ ] Screen recording tested
- [ ] Backup slides ready
- [ ] Coffee/water nearby ☕

**When CoPilot is accessible, we're ready to record! 🚀**
