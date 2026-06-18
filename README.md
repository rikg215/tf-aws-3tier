# Terraform AWS 3-Tier Architecture

## Network (June 17, 2026)

<img width="1536" height="408" alt="network-graph" src="https://github.com/user-attachments/assets/bf792ef2-4237-44bb-ada1-fbac57065e40" />

- VPC 10.0.0.0/16
- 2 public subnets (1a, 1b) -> IGW
- 2 private subnets (1a, 1b) -> NAT Gateway
- Single NAT GW in public-1a (~$1/day)

## Stack

ALB (public) -> EC2 (private) -> RDS (isolated)

> [!NOTE]
> This is a work in progress!
