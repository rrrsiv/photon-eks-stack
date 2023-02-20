# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)

# This sets up control-host and installs following tools on it.
 - Python3
 - ansible
 - awscli
 - kubectl
 - terraform
 - helm
 - Jenkins

# Install ansible on your machine

- Customizations/ Variables - Set AWS aws_access_key, aws_secret_key , region_name , vpc_id , subnet_id and other details as per your environment.
- You can use existing VPC and Subnet or can create your own.
- It is preferred that you create a seperate one
- The AWS keys should have access to create VPC, Subnets, EC2 instances, EKS clusters etc..
 - Refer vars/main_template.yml

## Run below command to setup networking (VPC,Subnet,Igw, routes etc.), if it does not exist.
### ansible-playbook -i inventory 1-setup-networking.yml

## Run below command to run the setup - Make sure inventory/ec2 is clean and no entries exist under [servers] for earlier installations and leave an empty line under [servers]
  - Best is to copy inventory/ec2_template to inventory/ec2 every time you run fresh installation.
  - Also delete current host before recreating new one by running.
      - ansible-playbook -i inventory 3-delete-control-host.yml
  
### ansible-playbook -i inventory 2-setup-control-host.yml

- Get the IP of the server from inventory/ec2 file
- Accessing Jenkins on below URL - It's access over web to be disabled later.
   - http://<IP_FROM_EC2_FILE>:8080/
- SSH to the server using key saved under keys directory. 
- Validate all installed tools


## Pending

 - Ansible
   - setup terraform backed beforehand
   - Install FE and BE services (update SG accoedingly)
   - Installed fixed version of all tools (terraform / helm etc..)

 - Terraform 
   - Will cluster autoscale nodes ?
   - s3 or some other backend storage - In case management server is deleted before terraform destroy ?
   - 

 - Helm
  - Distributed-Jmeter
  - InfluxDB
  - Grafana
  - Prometheus
  - ELK / EFK

## EKS - To be Done
- cluster autocluster needs to be implemented
- s3 backend storage
- EBS storage PV's for persistent storage for logs/metrices - Same PV to be used everytime


# Cleanup AWS Resources - Control Host and underlying Network Infra.

## Run below command to delete the control host 
### ansible-playbook -i inventory 3-delete-control-host.yml

## Run below command to delete all networking VPC,subnet,Igw,routes etc.
### ansible-playbook -i inventory 4-delete-networking.yml
