# Terraform AWS 3-Tier Architecture

<img width="1536" height="408" alt="network-graph" src="https://github.com/user-attachments/assets/bf792ef2-4237-44bb-ada1-fbac57065e40" />

## Network (June 17, 2026)

- VPC 10.0.0.0/16
- 2 public subnets (1a, 1b) -> IGW
- 2 private subnets (1a, 1b) -> NAT Gateway
- Single NAT GW in public-1a (~$1/day)

## Compute (June 24, 2026)
- AMI filter` ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]`
- instance type EC2 `"t3.micro"`
- public subnet 1a
- nginx installed and configured to serve "Welcome to rainlabs" message via `user_data`


## Stack

ALB (planned) -> EC2 (accessible via public ip, WIP) -> RDS (planned)

> [!NOTE]
> This is a work in progress!
