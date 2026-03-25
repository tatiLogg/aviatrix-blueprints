# ============================================================================
# Gatus — Live Zero Trust Connectivity Dashboards
# ============================================================================
# Two real-time dashboards running on the Dev and Prod test VMs, showing
# DCF policy enforcement from each environment's perspective. Updates every
# 10 seconds automatically — no manual ping commands needed during the demo.
#
# Dev dashboard:  what can the dev environment reach?
#   - Dev → DB         RED  (blocked by Zero Trust)
#   - Dev → Prod ICMP  GREEN (allowed — monitoring only)
#   - Dev → Prod TCP   RED  (blocked — ICMP only policy)
#
# Prod dashboard: what can the prod environment reach?
#   - Prod → DB        GREEN (allowed — legitimate business traffic)
#   - Prod → Dev       RED  (blocked by Zero Trust)
#
# Access via SSH tunnel (run each in a separate terminal):
#   Dev:  aws ec2-instance-connect ssh --region <region> --instance-id <dev-id> -- -L 18080:localhost:8080 -N
#         Open: http://localhost:18080
#
#   Prod: aws ec2-instance-connect ssh --region <region> --instance-id <prod-id> -- -L 28080:localhost:8080 -N
#         Open: http://localhost:28080
#
# Both instance IDs and tunnel commands are in terraform output gatus_dashboards.
# ============================================================================

locals {
  # Pin private IPs for test VMs so Gatus configs can reference them at plan
  # time. Uses host 10 in each spoke's private /26 subnet to avoid conflicts
  # with DHCP at the start of the range.
  #
  # Default values (with default spokes variable):
  #   dev  = 10.1.0.74  (cidrhost("10.1.0.64/26", 10))
  #   prod = 10.2.0.74  (cidrhost("10.2.0.64/26", 10))
  #   db   = 10.3.0.74  (cidrhost("10.3.0.64/26", 10))
  test_vm_ips = {
    for k, v in var.spokes : k => cidrhost(cidrsubnet(v.cidr, 2, 1), 10)
  }

  # Gatus YAML config for the Dev VM.
  # Conditions use [CONNECTED] == true so endpoints show GREEN when reachable
  # and RED when blocked — the dashboard directly reflects DCF enforcement.
  gatus_config_dev = <<-YAML
storage:
  type: memory
metrics: false
ui:
  title: "Dev Environment - Zero Trust View"
  header: "Dev VPC | What can dev reach?"
endpoints:
  - name: "Dev to DB (BLOCKED by Zero Trust)"
    group: "Zero Trust Policies"
    url: "icmp://${local.test_vm_ips["db"]}"
    interval: 10s
    conditions:
      - "[CONNECTED] == true"
  - name: "Dev to Prod ICMP (ALLOWED - monitoring only)"
    group: "Zero Trust Policies"
    url: "icmp://${local.test_vm_ips["prod"]}"
    interval: 10s
    conditions:
      - "[CONNECTED] == true"
  - name: "Dev to Prod TCP (BLOCKED - ICMP only policy)"
    group: "Zero Trust Policies"
    url: "tcp://${local.test_vm_ips["prod"]}:22"
    interval: 10s
    conditions:
      - "[CONNECTED] == true"
YAML

  # Gatus YAML config for the Prod VM.
  gatus_config_prod = <<-YAML
storage:
  type: memory
metrics: false
ui:
  title: "Prod Environment - Zero Trust View"
  header: "Prod VPC | What can prod reach?"
endpoints:
  - name: "Prod to DB (ALLOWED - legitimate business traffic)"
    group: "Zero Trust Policies"
    url: "icmp://${local.test_vm_ips["db"]}"
    interval: 10s
    conditions:
      - "[CONNECTED] == true"
  - name: "Prod to Dev (BLOCKED by Zero Trust)"
    group: "Zero Trust Policies"
    url: "icmp://${local.test_vm_ips["dev"]}"
    interval: 10s
    conditions:
      - "[CONNECTED] == true"
YAML

  # Per-spoke user_data map.
  # Dev and Prod: install Docker, write the Gatus config (base64-encoded to
  # avoid heredoc-in-heredoc issues), and start Gatus with --network host so
  # ICMP probes run from the EC2 instance's network stack.
  # DB: basic tooling only — it's a target, not a monitoring source.
  #
  # Note: Keys must match var.spokes keys. If you add custom spokes, add a
  # corresponding entry here (or they fall back to the db/basic user_data).
  gatus_user_data = {
    dev = <<-SCRIPT
#!/bin/bash
set -e
yum update -y
yum install -y tcpdump netcat nmap
hostnamectl set-hostname dev-test-vm
echo "Welcome to dev test VM" > /etc/motd
amazon-linux-extras install -y docker
systemctl start docker
systemctl enable docker
mkdir -p /etc/gatus
echo "${base64encode(local.gatus_config_dev)}" | base64 -d > /etc/gatus/config.yaml
docker run -d \
  --name gatus \
  --restart always \
  --network host \
  -v /etc/gatus:/config:ro \
  twinproduction/gatus:latest
SCRIPT

    prod = <<-SCRIPT
#!/bin/bash
set -e
yum update -y
yum install -y tcpdump netcat nmap
hostnamectl set-hostname prod-test-vm
echo "Welcome to prod test VM" > /etc/motd
amazon-linux-extras install -y docker
systemctl start docker
systemctl enable docker
mkdir -p /etc/gatus
echo "${base64encode(local.gatus_config_prod)}" | base64 -d > /etc/gatus/config.yaml
docker run -d \
  --name gatus \
  --restart always \
  --network host \
  -v /etc/gatus:/config:ro \
  twinproduction/gatus:latest
SCRIPT

    db = <<-SCRIPT
#!/bin/bash
yum update -y
yum install -y tcpdump netcat nmap
hostnamectl set-hostname db-test-vm
echo "Welcome to db test VM" > /etc/motd
SCRIPT
  }
}
