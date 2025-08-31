# On-Prem to AWS Microservices App Migration

## Introduction
This repository illustrates the migration of a multi-tier microservices Java application from an on-premises environment to AWS cloud-native services.

Originally the application was deployed using Vagrant on multiple VMs on-prem. The application is re-architected to leverage AWS managed services for scalability, high availability, and reduced operational overhead.

## Application Architecture

The application architecture is composed of 5 microservices. They are:

| On-Prem VM      | Technology              | AWS Service    |
|-----------------|-------------------------|------------------------------|
| Load Balancer   | Nginx                   | Application Load Balancer (ALB) |
| Application     | Tomcat                  | Amazon EC2          |
| Message Queue   | RabbitMQ                | Amazon MQ |
| Cache           | Memcached               | Amazon ElastiCache |
| Database        | MariaDB                 | Amazon RDS  |

<img width="2048" height="1302" alt="473799416-8d9c68fa-2f3c-4a95-b9e6-da550952c2be" src="https://github.com/user-attachments/assets/61edd283-f961-490c-a88a-b6cead84de52" />


## AWS Services Deployment

### 1. Security Groups
- In this project we will two security groups:
   - A) one security group for DB, MQ, Elasticache and EC2 (APP-SG).
      - Inbound
        <img width="3261" height="1119" alt="SG" src="https://github.com/user-attachments/assets/0403c79c-b273-4ef5-bc56-a825a369a514" />
      - Outbound: All traffic.

   - B) One security group for the load balancer (ALB-SG).
      - Inbound: HTTP:80 for all.
      - Outbound: All traffic.

### 2. Database (Amazon RDS)
- Choose RDS service and select engine type (MySQL or MariaDB).  
- Template: Free tier.  
- Create credentials for DB access.  
- Assign (APP-SG) security group.
  <img width="3210" height="1558" alt="db" src="https://github.com/user-attachments/assets/86a35357-bbad-451e-9806-044485d5d5ca" />


### 3. Message Queue (Amazon MQ)
- Choose Amazon MQ service, then Rabbit MQ.
- Select single cluster, then the instance type chooses “mq.t3.micro”.
- Assign (APP-SG) security group.
  <img width="3763" height="1704" alt="MQ" src="https://github.com/user-attachments/assets/35be6fb5-18ce-4f8b-aebc-966c41ce3607" />

### 4. Cache (Amazon Elasticache)
- Choose Elasticache service with the minimal free tier requirement.
- Assign (APP-SG) security group.
  <img width="3245" height="1151" alt="mmc" src="https://github.com/user-attachments/assets/dcae8f7e-0b2d-4073-8219-8107bdf709c7" />

### 5. Application (EC2)
- Choose EC2 service with Amazon Linux image.
- Create the key and assign the application security group (APP-SG).
- From advanced details, go to “User data” and select “tomcat.sh” script attached on the project repo to provision the EC2.
- After creating EC2, clone the project directory.
  ```bash
  git clone -b main https://github.com/hkhcoder/vprofile-project.git
  
- To access RDS from the EC2, install the client tool for the database engine.
   ```bash
   sudo dnf install mysql-community-client --nogpgcheck -y
   mysql -h <RDS-endpoint> -P 3306 -u <username> -p
   
- Initialize RDS configuration.
  ```sql
  create database accounts;
  GRANT ALL PRIVILEGES ON accounts.* TO 'admin123';
  FLUSH PRIVILEGES;
  mysql> exit;

- Copy database file from the project directory on the EC2 to RDS
  ```bash
   cd vprofile-project
   mysql -h database-app.cbsumi2ok52c.eu-north-1.rds.amazonaws.com -u admin -padmin123 accounts < src/main/resources/db_backup.sql
  
- Build the application using maven
  ```bash
   cd vprofile-project
   mvn install
   systemctl stop tomcat
   sudo rm -rf /usr/local/tomcat/webapps/ROOT*
   sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
   sudo systemctl start tomcat
   sudo chown tomcat.tomcat /usr/local/tomcat/webapps -R
   sudo systemctl restart tomcat

- Application needs Java 11 to work, in case of other version of Java is the default, choose version 11:
  ```bash
   systemctl stop tomcat
   sudo alternatives --config java
   systemctl restart tomcat

- Adjust the application configuration to point out to the endpoints of the AWS services.
  ```bash
  cd vprofile-project/
  vim src/main/resources/application.properties







