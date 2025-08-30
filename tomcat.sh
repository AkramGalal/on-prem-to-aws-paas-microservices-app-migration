#! /usr/bin/bash

# Update OS with latest patches
sudo yum update -y

# Set Repository
sudo yum install epel-release -y

# Install Dependencies
sudo dnf -y install java-11-openjdk java-11-openjdk-devel
sudo dnf install git maven wget -y

# Change dir to /tmp
sudo cd /tmp/

# Download & Tomcat Package
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
sudo tar xzvf apache-tomcat-9.0.75.tar.gz

# Add tomcat user
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# Copy data to tomcat home dir
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/

# Make tomcat user owner of tomcat home dir
sudo chown -R tomcat.tomcat /usr/local/tomcat

# Create tomcat service file
sudo cat > /etc/systemd/system/tomcat.service << EOF

[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target

EOF

# Reload systemd files
sudo systemctl daemon-reload

# Start & Enable service
sudo systemctl start tomcat
sudo systemctl enable tomcat

# CODE BUILD & DEPLOY
# Download Source code
sudo git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Update configuration
sudo cd vprofile-project

# Build code
# Run below command inside the repository (vprofile-project)
sudo mvn install

# Deploy artifact
sudo systemctl stop tomcat
sudo rm -rf /usr/local/tomcat/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo systemctl start tomcat
sudo chown tomcat.tomcat /usr/local/tomcat/webapps -R
sudo systemctl restart tomcat

# Remove Java 17 for incompatibility  
sudo systemctl stop tomcat
sudo dnf remove java-17-openjdk* -y
sudo systemctl restart tomcat
