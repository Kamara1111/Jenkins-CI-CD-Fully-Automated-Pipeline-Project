#!/bin/bash
# Ensure that your software packages are up to date on your instance by using the following command to perform a quick software update:
sudo yum update –y
sudo su
sudo yum install wget -y

# Add the Jenkins repo using the following command:
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

#Import a key file from Jenkins-CI to enable installation from the package:
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum upgrade -y

# Install Java (Amazon Linux 2023):
sudo dnf install java-17-amazon-corretto -y

sudo echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Jenkins
sudo yum install jenkins -y

# Enable the Jenkins service to start at boot:
sudo systemctl enable jenkins

# Start Jenkins as a service:
sudo systemctl start jenkins

# Installing Git
sudo yum install git -y

sudo yum install ansible
yum install python-pip -y
pip install boto3

# Provisioning Ansible Deployer Access
useradd ansibleadmin
echo ansibleadmin | passwd ansibleadmin --stdin
sed -i "s/.*#host_key_checking = False/host_key_checking = False/g" /etc/ansible/ansible.cfg
sed -i "s/.*#enable_plugins = host_list, virtualbox, yaml, constructed/enable_plugins = aws_ec2/g" /etc/ansible/ansible.cfg
ansible-galaxy collection install amazon.aws

# Enable Password Authentication and Grant Sudo Privilege
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
echo "ansibleadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Apache Maven Installation/Config
#sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
#sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
#sudo yum install -y apache-maven
#sudo yum install java-1.8.0-devel

#sudo /usr/sbin/alternatives --config java
#sudo /usr/sbin/alternatives --config javac

# Use The Amazon Linux 2 AMI When Launching The Jenkins VM/EC2 Instance
# Instance Type: t2.medium or small minimum
# Open Port (Security Group): 8080
