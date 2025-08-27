# On-Prem to AWS Microservices App Migration

## Introduction
This repository illustrates the migration of a **multi-tier microservices application** from an on-premises environment to **AWS cloud-native services**.  
Originally deployed using **Vagrant + Bash** on multiple VMs, the application is now re-architected to leverage **AWS managed services** for scalability, high availability, and reduced operational overhead.

## Application Architecture

The application architecture is composed of 5 microservices. They are:

| On-Prem VM      | Technology              | AWS Service (Replacement)    |
|-----------------|-------------------------|------------------------------|
| Load Balancer   | Nginx                   | Application Load Balancer (ALB) |
| Application     | Java 11 + Maven + Tomcat| Amazon EC2          |
| Message Queue   | RabbitMQ                | Amazon MQ |
| Cache           | Memcached               | Amazon ElastiCache (Memcached)|
| Database        | MariaDB                 | Amazon RDS (MariaDB)   |

## AWS Service Deployment
   - Deploy ALB to balance traffic across EC2 instances.  
   - Launch EC2 instances with user-data/bootstrap scripts for the Java app.  
   - Set up RDS with MariaDB as the application’s database.  
   - Configure ElastiCache (Memcached) for caching.  
   - Integrate Amazon MQ as the messaging backbone. 
