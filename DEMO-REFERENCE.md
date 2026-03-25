# Demo Reference Guide

**Owner:** Selina Loggins (@tatiLogg)
**Last Updated:** March 2026

---

## Quick Links

| Resource | URL |
|----------|-----|
| **GitHub — Aviatrix Blueprints Repo** | https://github.com/aviatrix/aviatrix-blueprints |
| **GitHub — Personal Profile** | https://github.com/tatiLogg |
| **Aviatrix Controller** | https://44.214.60.253 |
| **Aviatrix CoPilot** | https://100.52.75.135/cloud-fabric/topology/overview |
| **AWS Console** | https://565569641641.signin.aws.amazon.com/console |
| **CloudShop E-Commerce Platform** | http://af47ed1f392fd45dd89d57f0cf01b257-1920686525.us-east-1.elb.amazonaws.com |
| **MITRE Caldera** | https://caldera.avxlab.io |
| **Confluence — Claude Code Setup** | https://aviatrix.atlassian.net/wiki/spaces/SEA/pages/3552542779/How+to+install+set+up+Claude+Code |

---

## Demos

---

### Demo 1: Prevent Lateral Movement - VM Tags

**Blueprint:** `blueprints/prevent-lateral-movement-vm-tags/`
**Duration:** 15–25 minutes
**Audience:** Security/Network Engineers, Directors, C-Suite

#### What It Does

Deploys Prevent Lateral Movement - VM Tags using Aviatrix Distributed Cloud Firewall (DCF) and SmartGroups across 3 AWS VPCs (Dev, Prod, Database). Demonstrates lateral movement prevention — if an attacker compromises Dev, they cannot reach production databases.

#### Infrastructure Deployed

| Component | Qty | Description |
|-----------|-----|-------------|
| Aviatrix Transit Gateway | 1 | Central hub |
| Aviatrix Spoke Gateways | 3 | Dev, Prod, Database |
| AWS VPCs | 4 | Isolated network segments |
| DCF SmartGroups | 3 | Tag-based dynamic groups |
| DCF Policies | 5 | Zero Trust segmentation rules |
| EC2 Test VMs | 3 | One per environment for validation |

#### Zero Trust Policies

| Priority | Policy | Source | Destination | Action | Purpose |
|----------|--------|--------|-------------|--------|---------|
| 100 | allow-prod-to-db | Prod | Database | PERMIT | Legitimate business need |
| 110 | allow-dev-to-prod | Dev | Prod | PERMIT (ICMP only) | Health checks |
| 200 | **deny-dev-to-db** | Dev | Database | **DENY** | **Block lateral movement** |
| 210 | deny-prod-to-dev | Prod | Dev | DENY | Prevent contamination |
| 1000 | default-deny-all | ANY | ANY | DENY | Zero Trust default |

#### Key Links

| Resource | URL / Path |
|----------|------------|
| Blueprint code | `blueprints/prevent-lateral-movement-vm-tags/` |
| CoPilot Topology | https://100.52.75.135/cloud-fabric/topology/overview |
| CoPilot SmartGroups | https://100.52.75.135 → Security > DCF > SmartGroups |
| CoPilot DCF Rules | https://100.52.75.135 → Security > DCF > Rules |
| CoPilot Monitor | https://100.52.75.135 → Security > DCF > Monitor |
| Controller | https://44.214.60.253 |
| AWS Console | https://565569641641.signin.aws.amazon.com/console |
| Aviatrix Terraform Provider | https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs |

#### Presentation Materials

| Document | Path |
|----------|------|
| 30-min Presentation Script | `PREVENT-LATERAL-MOVEMENT-DEMO-SCRIPT.md` |
| CPO Demo Brief | `blueprints/prevent-lateral-movement-vm-tags/CPO-DEMO-BRIEF.md` |
| Confluence Demo Guide | `blueprints/prevent-lateral-movement-vm-tags/CONFLUENCE-DEMO-PAGE-FINAL.md` |
| Deployment Report | `blueprints/prevent-lateral-movement-vm-tags/DEPLOYMENT-REPORT.md` |
| Getting Started | `blueprints/prevent-lateral-movement-vm-tags/GETTING-STARTED.md` |
| Blueprint Readiness Checklist | `blueprints/prevent-lateral-movement-vm-tags/BLUEPRINT-READINESS-CHECKLIST.md` |

#### Business Value

- **80% faster** Zero Trust deployment — 15 minutes vs. 2–3 weeks
- **Zero lateral movement** — breaches contained to single workload
- **Compliance-ready** — PCI-DSS, HIPAA, SOC 2 microsegmentation requirements
- **90% less policy overhead** — tag-based SmartGroups replace manual security group management
- **Cost:** ~$0.25/hour (~$6/day)

---

### Demo 2: DCF with EKS (Multi-Cluster Kubernetes)

**Blueprint:** `blueprints/dcf-eks/`
**Duration:** 45–60 minutes (deployment) | 20–30 minutes (live demo)
**Audience:** DevOps, Platform Engineering, Security Teams

#### What It Does

Deploys a multi-cluster Kubernetes environment on AWS EKS with Aviatrix transit networking, demonstrating Distributed Cloud Firewall (DCF) with Kubernetes-native FirewallPolicy CRDs. Uses the **CloudShop e-commerce platform** as the demo application running across frontend and backend clusters.

#### Infrastructure Deployed

| Component | Description |
|-----------|-------------|
| Aviatrix Transit Gateway | Central hub (us-east-2) |
| Frontend EKS Cluster | Customer-facing CloudShop frontend |
| Backend EKS Cluster | CloudShop backend services |
| Database VM (Apache) | Simulated database layer |
| Route53 Private Hosted Zone | Internal DNS (aws.aviatrixdemo.local) |
| AWS Load Balancer Controller | Ingress for CloudShop |
| ExternalDNS | Auto DNS record creation for k8s services |
| Aviatrix FirewallPolicy CRD | Kubernetes-native DCF rules |
| Gatus Health Monitoring | Connectivity validation dashboards |

#### Deployment Layers

```
Layer 1 — Network:      network/
Layer 2 — EKS Clusters: clusters/frontend/  clusters/backend/
Layer 3 — Node Groups:  nodes/frontend/     nodes/backend/
Layer 4 — K8s Apps:     k8s-apps/frontend/  k8s-apps/backend/
```

#### Key Links

| Resource | URL / Path |
|----------|------------|
| **CloudShop App (Live)** | http://af47ed1f392fd45dd89d57f0cf01b257-1920686525.us-east-1.elb.amazonaws.com |
| Blueprint code | `blueprints/dcf-eks/` |
| CoPilot Topology | https://100.52.75.135/cloud-fabric/topology/overview |
| Controller | https://44.214.60.253 |
| AWS Console | https://565569641641.signin.aws.amazon.com/console |
| Aviatrix Terraform Provider | https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs |
| Docker Install Guide | https://docs.docker.com/get-docker/ |
| Node.js | https://nodejs.org |
| kubectl Install Guide | https://kubernetes.io/docs/tasks/tools/ |
| AWS CLI Install Guide | https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html |
| Terraform Install Guide | https://developer.hashicorp.com/terraform/install |

---

### Demo 3: Adversarial Simulation with MITRE Caldera

**Tool:** MITRE Caldera (open-source adversary emulation)
**URL:** https://caldera.avxlab.io
**Audience:** Security Teams, Red/Blue Team, SOC

#### What It Does

Runs automated adversary emulation against the deployed Zero Trust environment to prove that DCF policies actually stop lateral movement. Demonstrates what an attacker would attempt and shows Aviatrix blocking it in real time.

#### Caldera Access

Credentials are custom — check `conf/local.yml` on the Caldera host (`caldera.avxlab.io`) for the configured values.

#### Key Links

| Resource | URL |
|----------|-----|
| **Caldera UI** | https://caldera.avxlab.io |
| Caldera GitHub | https://github.com/mitre/caldera |
| Caldera Documentation | https://caldera.readthedocs.io |
| CoPilot DCF Monitor (for blocking evidence) | https://100.52.75.135 → Security > DCF > Monitor |

---

## Tools & Technology Reference

| Tool | Purpose | Link |
|------|---------|-------|
| **Terraform** | Infrastructure as Code for all blueprints | https://developer.hashicorp.com/terraform/install |
| **Aviatrix Terraform Provider** | Aviatrix resource management | https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs |
| **AWS CLI** | AWS authentication and resource management | https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html |
| **Docker** | Container builds for CloudShop and EKS workloads | https://docs.docker.com/get-docker/ |
| **Node.js** | CloudShop application runtime | https://nodejs.org |
| **kubectl** | Kubernetes cluster interaction | https://kubernetes.io/docs/tasks/tools/ |
| **Claude Code** | AI-assisted deployment and development | https://claude.ai/code |

---

## Documentation & Internal Resources

| Resource | Link |
|----------|------|
| **Confluence — Claude Code Setup Guide** | https://aviatrix.atlassian.net/wiki/spaces/SEA/pages/3552542779/How+to+install+set+up+Claude+Code |
| **GitHub — Aviatrix Blueprints Repo** | https://github.com/aviatrix/aviatrix-blueprints |
| **GitHub — Personal Profile (@tatiLogg)** | https://github.com/tatiLogg |
| **Blueprint Standards** | `docs/blueprint-standards.md` |
| **Prerequisites Overview** | `docs/prerequisites/README.md` |
| **Streamlined Demo Guide** | `CONFLUENCE-DEMO-PAGE-STREAMLINED.md` |
| **PR Description** | `PR-DESCRIPTION.md` |

---

## Aviatrix Control Plane Navigation

| Section | Path in CoPilot |
|---------|----------------|
| Network Topology | Cloud Fabric > Topology > Overview |
| SmartGroups | Security > Distributed Cloud Firewall > SmartGroups |
| DCF Rules | Security > Distributed Cloud Firewall > Rules |
| Live Traffic Monitor | Security > Distributed Cloud Firewall > Monitor |
| Audit Logs | Security > Distributed Cloud Firewall > Logs |
| FlowIQ | Monitor > FlowIQ |
| Diagnostics | Performance > Diagnostics |
