# On-Prem to AWS Microservices App Migration

## Introduction
This repository illustrates the migration of a multi-tier microservices Java application from an on-premises environment to AWS cloud-native services.  
Originally the application was deployed using Vagrant on multiple VMs on-prem. The application is re-architected to leverage AWS managed services for scalability, high availability, and reduced operational overhead.

## Application Architecture

The application architecture is composed of 5 microservices. They are:

| On-Prem VM      | Technology              | AWS Service (Replacement)    |
|-----------------|-------------------------|------------------------------|
| Load Balancer   | Nginx                   | Application Load Balancer (ALB) |
| Application     | Tomcat                  | Amazon EC2          |
| Message Queue   | RabbitMQ                | Amazon MQ |
| Cache           | Memcached               | Amazon ElastiCache |
| Database        | MariaDB                 | Amazon RDS  |

## Setup and Service Deployment
   - Launch EC2 instances with bootstrap scripts for the Java app.
   - Deploy ALB to balance traffic across EC2 instances.  
   - Set up RDS with MariaDB as the application’s database.  
   - Configure ElastiCache for caching.  
   - Integrate Amazon MQ as the messaging backbone.
