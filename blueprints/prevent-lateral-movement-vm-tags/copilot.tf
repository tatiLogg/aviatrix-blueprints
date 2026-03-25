# ============================================================================
# Aviatrix CoPilot Deployment
# ============================================================================

# Get the latest CoPilot AMI
data "aws_ami" "copilot" {
  most_recent = true
  owners      = ["679593333241"] # Aviatrix AWS account

  filter {
    name   = "name"
    values = ["avx-copilot-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for CoPilot
resource "aws_security_group" "copilot" {
  name_prefix = "${var.name_prefix}-copilot-sg"
  description = "Security group for Aviatrix CoPilot"
  vpc_id      = aws_vpc.transit.id

  # HTTPS access from anywhere (for demo)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access to CoPilot UI"
  }

  # HTTPS from Controller
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["44.214.60.253/32"]
    description = "HTTPS from Controller"
  }

  # Netflow from gateways
  ingress {
    from_port   = 31283
    to_port     = 31283
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Netflow from gateways"
  }

  # Syslog from gateways
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Syslog from gateways"
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-copilot-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# CoPilot EC2 instance
resource "aws_instance" "copilot" {
  ami           = data.aws_ami.copilot.id
  instance_type = "t3.2xlarge" # Minimum recommended size
  key_name      = var.test_vm_key_name

  subnet_id                   = aws_subnet.transit_public.id
  vpc_security_group_ids      = [aws_security_group.copilot.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-copilot"
  })
}

# Outputs
output "copilot_public_ip" {
  value       = aws_instance.copilot.public_ip
  description = "CoPilot public IP address"
}

output "copilot_private_ip" {
  value       = aws_instance.copilot.private_ip
  description = "CoPilot private IP address (initial password)"
}

output "copilot_url" {
  value       = "https://${aws_instance.copilot.public_ip}"
  description = "CoPilot access URL"
}

output "copilot_initial_password" {
  value       = aws_instance.copilot.private_ip
  description = "Initial CoPilot password (private IP)"
  sensitive   = true
}

output "copilot_setup_instructions" {
  value = <<-EOT

  ╔════════════════════════════════════════════════════════════════════╗
  ║                  CoPilot Setup Instructions                        ║
  ╚════════════════════════════════════════════════════════════════════╝

  1. Access CoPilot UI:
     URL: https://${aws_instance.copilot.public_ip}

  2. Initial Login:
     Username: admin
     Password: ${aws_instance.copilot.private_ip}

  3. After login, you'll be prompted to:
     - Change password
     - Set up email (optional)

  4. Associate with Controller:
     - Go to Settings > Controller Association
     - Controller IP: 44.214.60.253
     - Username: admin
     - Password: Selina123!
     - Click "Associate"

  5. Wait 5-10 minutes for initial sync

  6. Navigate to:
     - Cloud Fabric > Topology (see your gateways)
     - Security > DCF > SmartGroups
     - Security > DCF > Rules
     - Security > DCF > Monitor

  ╔════════════════════════════════════════════════════════════════════╗
  ║  Note: CoPilot costs ~$0.34/hour (~$8/day) - destroy when done!   ║
  ╚════════════════════════════════════════════════════════════════════╝

  EOT
}
