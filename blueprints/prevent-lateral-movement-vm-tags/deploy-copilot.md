# Deploy Aviatrix CoPilot - Quick Guide

## Option 1: Via AWS Marketplace (Recommended)

### Step 1: Subscribe to CoPilot in AWS Marketplace
1. Go to: https://aws.amazon.com/marketplace/pp/prodview-qxvje6qoxugvu
2. Click **"Continue to Subscribe"**
3. Click **"Accept Terms"**
4. Wait for subscription confirmation (~2 minutes)

### Step 2: Launch CoPilot Instance
1. Click **"Continue to Configuration"**
2. Select:
   - **Fulfillment Option:** Amazon Machine Image
   - **Software Version:** Latest (7.2.x or higher)
   - **Region:** us-east-1
3. Click **"Continue to Launch"**

### Step 3: Configure Launch Settings
1. **Choose Action:** Launch through EC2
2. **Instance Type:** t3.2xlarge (minimum) or t3.xlarge for demo
3. **VPC:** Select your existing VPC or create new
4. **Subnet:** Public subnet with internet access
5. **Security Group:** Create new with these rules:
   - HTTPS (443) from your IP
   - HTTPS (443) from Controller IP (44.214.60.253)
   - SSH (22) from your IP (optional)
6. **Key Pair:** Select your existing key pair (avxlabs)
7. Click **"Launch"**

### Step 4: Get CoPilot IP Address
Wait 5-10 minutes for instance to launch, then:
```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*CoPilot*" \
          "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[PublicIpAddress]' \
  --output text \
  --region us-east-1
```

### Step 5: Initial CoPilot Setup
1. Access CoPilot: `https://<copilot-public-ip>`
2. Accept certificate warning
3. Initial login:
   - Username: `admin`
   - Password: Private IP of the CoPilot instance
4. Change password when prompted

### Step 6: Associate CoPilot with Controller
1. In CoPilot UI, go to **Settings > Controller Integration**
2. Enter Controller details:
   - **Controller IP:** 44.214.60.253
   - **Username:** admin
   - **Password:** Selina123!
3. Click **"Associate"**
4. Wait for synchronization (~5 minutes)

---

## Option 2: Via Terraform (Faster)

Create `copilot.tf`:

```hcl
data "aws_ami" "copilot" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["aviatrix-copilot-*"]
  }
}

resource "aws_instance" "copilot" {
  ami           = data.aws_ami.copilot.id
  instance_type = "t3.xlarge"
  key_name      = "avxlabs"

  subnet_id                   = aws_subnet.transit_public.id
  vpc_security_group_ids      = [aws_security_group.copilot.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "aviatrix-copilot"
  }
}

resource "aws_security_group" "copilot" {
  name        = "copilot-sg"
  description = "Security group for Aviatrix CoPilot"
  vpc_id      = aws_vpc.transit.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "copilot_public_ip" {
  value = aws_instance.copilot.public_ip
}
```

Then deploy:
```bash
terraform apply -target=aws_instance.copilot -target=aws_security_group.copilot
```

---

## Option 3: Via Controller UI

### In Controller Dashboard:
1. Click **Settings** (left sidebar)
2. Click **CoPilot**
3. Click **"Launch CoPilot"** or **"Deploy CoPilot"**
4. Follow the wizard:
   - Select AWS account
   - Select VPC and subnet
   - Choose instance size (t3.xlarge minimum)
   - Select key pair
5. Click **"Launch"**
6. Wait 10-15 minutes for deployment

---

## Post-Deployment Checklist

After CoPilot is deployed:

- [ ] Access CoPilot UI at https://<copilot-ip>
- [ ] Complete initial setup wizard
- [ ] Associate with Controller
- [ ] Wait for data synchronization (5-10 minutes)
- [ ] Verify topology appears
- [ ] Verify SmartGroups are visible
- [ ] Verify DCF policies are shown

---

## Troubleshooting

**Can't access CoPilot UI:**
- Check security group allows HTTPS from your IP
- Verify instance is running: `aws ec2 describe-instances`
- Check public IP is assigned

**Association fails:**
- Verify Controller IP is correct
- Check Controller security group allows HTTPS from CoPilot IP
- Verify credentials are correct

**No data showing:**
- Wait 5-10 minutes for initial sync
- Check Controller → CoPilot connection in Controller UI
- Verify CoPilot can reach Controller (network connectivity)

---

## Cost Estimate

**CoPilot Instance (t3.xlarge):**
- Hourly: ~$0.17/hour
- Daily: ~$4/day
- Monthly: ~$120/month

**Remember to terminate when done with demo!**
