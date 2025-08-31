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

### 1. security groups
- In this project we will two security groups:
   - A) one security group for DB, MQ, Elasticache and EC2 (APP-SG).
      - Inbound
        <img width="3261" height="1119" alt="SG" src="https://github.com/user-attachments/assets/0403c79c-b273-4ef5-bc56-a825a369a514" />
      
      - Outbound: All traffic.

   - B) One security group for the load balancer (ALB-SG).
      - Inbound: HTTP:80 for all.
      - Outbound: All traffic.


### 2. Database (MariaDB → Amazon RDS)
- Choose **RDS service** and select engine type (MySQL or MariaDB).  
- Template: Free tier.  
- Create credentials for DB access.  
- Assign **APP-SG** security group.  

**Initialize RDS Database:**  

