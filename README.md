# On-Prem to AWS PaaS App Migration

## Introduction
This repository illustrates the migration of a multi-tier microservices Java application from an on-premises environment to AWS PaaS services.

Originally, the application was deployed using Vagrant on multiple VMs on-prem. The application is re-architected to leverage AWS managed Platform as a Services (PaaS) for scalability, high availability, and reduced operational overhead.

## Application Architecture

The application architecture is composed of 5 microservices. They are:

| On-Prem VM      | Technology              | AWS Service    |
|-----------------|-------------------------|------------------------------|
| Load Balancer   | Nginx                   | Amazon EC2 |
| Application     | Tomcat                  | Amazon EC2          |
| Message Queue   | RabbitMQ                | Amazon EC2 |
| Cache           | Memcached               | Amazon EC2 |
| Database        | MariaDB                 | Amazon EC2  |

Each service is hosted on a separate EC2 instance for scalability. Security groups are configured to allow only the required ports between services.

## Setup and Service Deployment
  - Provision separate EC2 instances for each microservice.
  - Use Amazon Linux 2 as base AMI for all EC2.
  - Each EC2 instance is provisioned using a bootstrap script to install and configure the required service.
  - Configure security groups to expose only the necessary ports:
     - Nginx (80/443)
     - Tomcat (8080)
     - RabbitMQ (5672)
     - Memcached (11211)
     - MariaDB (3306)
