#!/bin/bash

# ========= Variables =========
TOMURL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz"
JAVA_HOME_DIR="/usr/lib/jvm/java-11-amazon-corretto"
APP_PROPS="/home/ec2-user/application.properties"

# ========= Install Dependencies =========
sudo dnf update -y
sudo dnf install -y java-11-amazon-corretto java-11-amazon-corretto-devel git maven wget rsync tar unzip mysql

# ========= Download & Install Tomcat =========
cd /tmp/
wget $TOMURL -O tomcatbin.tar.gz
EXTOUT=$(tar xzvf tomcatbin.tar.gz)
TOMDIR=$(echo $EXTOUT | cut -d '/' -f1)

# Create tomcat user & install directory
sudo useradd tomcat --shell /sbin/nologin -md /usr/local/tomcat || true
sudo rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat/
sudo chown -R tomcat:tomcat /usr/local/tomcat

# ========= Create Systemd Service =========
sudo rm -f /etc/systemd/system/tomcat.service

cat <<EOT | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=$JAVA_HOME_DIR
Environment=CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh
RestartSec=10
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

# ========= Enable & Start Tomcat =========
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# ========= Clone & Build vprofile Project =========
cd /opt/
sudo git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mvn clean install -DskipTests

# ========= Deploy WAR into Tomcat =========
sudo systemctl stop tomcat
sleep 10
sudo rm -rf /usr/local/tomcat/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo chown -R tomcat:tomcat /usr/local/tomcat/webapps
sudo systemctl start tomcat
