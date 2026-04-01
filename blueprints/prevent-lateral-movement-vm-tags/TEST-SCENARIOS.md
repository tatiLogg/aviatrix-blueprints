# Test Scenarios — Prevent Lateral Movement (VM Tags)

## How Each Method Works

| | Gatus (Automated) | Manual (SSH) |
|---|---|---|
| **Who initiates** | Gatus EC2 in the **prod** spoke | You, SSH'd into the target VM |
| **When it runs** | Every 10 seconds, continuously | On-demand |
| **How to view** | Browser — `terraform output gatus_dashboard_url` | Terminal (ping/nc) + CoPilot Monitor |
| **Source spoke** | Prod only | Any spoke |

---

## Gatus — 3 Automated Probes (all from prod)

| # | Flow | Protocol | Expected | DCF Policy |
|---|------|----------|----------|------------|
| G1 | Prod → DB | ICMP | 🟢 GREEN | `allow-prod-to-db` (priority 100) |
| G2 | Prod → Dev | ICMP | 🔴 RED | `deny-prod-to-dev` (priority 210) |
| G3 | Prod → Dev | TCP:22 | 🔴 RED | `default-deny-all` (priority 1000) |

---

## Manual — 4 SSH Test Scenarios

| # | Flow | Protocol | Expected | DCF Policy |
|---|------|----------|----------|------------|
| M1 | Dev → DB | ICMP | ❌ BLOCK | `deny-dev-to-db` (priority 200) |
| M2 | Prod → DB | ICMP | ✅ ALLOW | `allow-prod-to-db` (priority 100) |
| M3 | Dev → Prod | ICMP | ✅ ALLOW | `allow-dev-to-prod-read-only` (priority 110) |
| M3 | Dev → Prod | TCP | ❌ BLOCK | `default-deny-all` (priority 1000) |
| M4 | Prod → Dev | ICMP | ❌ BLOCK | `deny-prod-to-dev` (priority 210) |

---

## Policy Coverage Matrix

| Priority | Policy | Gatus | Manual |
|----------|--------|-------|--------|
| 100 | `allow-prod-to-db` | ✅ G1 | ✅ M2 |
| 110 | `allow-dev-to-prod-read-only` | ❌ gap | ✅ M3 |
| 200 | `deny-dev-to-db` | ❌ gap | ✅ M1 |
| 210 | `deny-prod-to-dev` | ✅ G2 | ✅ M4 |
| 1000 | `default-deny-all` | ✅ G3 | ✅ M3 |

**Gatus gap:** Policies 110 and 200 (dev-originated traffic) have no Gatus coverage because
Gatus runs on the prod spoke and cannot initiate probes from dev. Manual testing is required
for these two policies. A second Gatus instance in the dev spoke is planned for v2.

---

## Running Manual Tests

### Connect to a test VM

```bash
# Get instance IDs
terraform output test_vm_ids

# SSH using EC2 Instance Connect (no key file needed)
aws ec2-instance-connect ssh --instance-id <instance-id> --region us-east-1
```

### Run a test

```bash
# ICMP test (ping)
ping <target-private-ip>

# TCP test (port 22, wait up to 10s for timeout)
nc -zv -w 10 <target-private-ip> 22
```

### View results in CoPilot

Navigate to **Security > Distributed Cloud Firewall > Monitor** to see PERMITTED/DENIED entries for each test in real time.
