#!/bin/bash
# Update system packages
dnf update -y

# Install Java (Nexus requires Java)
dnf install java-17-amazon-corretto -y

# Create Nexus User
useradd nexus
echo "nexus ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Download and Extract Nexus Repository Manager
cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz -O nexus.tar.gz
tar -xvzf nexus.tar.gz
rm -f nexus.tar.gz
mv nexus-3* nexus

# Set Ownership and Permissions
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to Run as Nexus User
echo 'run_as_user="nexus"' > /opt/nexus/bin/nexus.rc

# Enable Nexus Service on Startup
cat <<EOF > /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload and Start Nexus Service
systemctl daemon-reload
systemctl enable nexus
systemctl start nexus
