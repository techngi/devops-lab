# Week 2 - Terraform + Ansible Integration

This week focuses on Infrastructure as Code (Terraform) and Configuration Management (Ansible).

## Goals

- Provision an EC2 instance and networking on AWS using Terraform
- Configure the instance as an Nginx web server using Ansible
- Demonstrate an end-to-end automated setup

## Structure

- `terraform/` - Terraform configuration for AWS infra
- `ansible/`   - Ansible playbooks and roles
- `screenshots/` - Place any screenshots here (Terraform plan/apply, Ansible runs, browser output)
- `end_to_end.md` - Documentation of the full workflow

## High-Level Flow

1. Use Terraform to create:
   - VPC, subnet, internet gateway
   - Security group (SSH + HTTP)
   - Ubuntu EC2 instance

2. Collect the public IP output from Terraform.

3. Use Ansible to:
   - SSH into the instance
   - Install Nginx
   - Deploy a custom index.html

4. Access the web server via the public IP.

