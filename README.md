# Terraform Infrastructure Deployment

## Prerequisites

1. Clone the following Git repository and navigate to that repository:

    ```sh
    git clone https://github.com/DhyeyB/vebuin-infra-demo.git
    cd vebuin-infra-demo
    ```

## Steps to Deploy the Infrastructure

### 1. Create `terraform.tfvars` File
Create a `terraform.tfvars` file and add all the variables mentioned in the `example.tfvars` file available in the GitHub repository.

**Note:** Use the SSH public key we created earlier in the `terraform.tfvars` file.

### 2. Initialize Terraform
Run the following command to initialize the Terraform working directory:

```sh
terraform init
```

### 3. Plan the Deployment
Execute the following command to preview the changes before applying them:

```sh
terraform plan
```

### 4. Apply the Deployment
Deploy the infrastructure by running:

```sh
terraform apply -auto-approve
```

### 5. Destroy the Infrastructure (If Needed)
To tear down the infrastructure, use:

```sh
terraform destroy -auto-approve
```

# Architecture Overview

The architecture I have designed leverages AWS services to make the application accessible over the internet while ensuring automatic scaling based on resource usage (CPU and memory). The setup is fully provisioned and managed using Infrastructure as Code (IaC) with Terraform.

## Services Used:

1. **VPC (Virtual Private Cloud)**:
   - The application is deployed inside a VPC to provide network isolation.

2. **Security Groups**:
   - Security Groups are used to define inbound and outbound traffic rules for the application.

3. **Elastic Load Balancer (ALB)**:
   - The Application Load Balancer (ALB) is used to distribute incoming traffic evenly across the ECS service.
   - It exposes the application to the internet and routes traffic based on predefined rules.
   
4. **ECS (Elastic Container Service)**:
   - The application is deployed as a containerized service on AWS ECS.
   - ECS manages the lifecycle of containers and ensures efficient resource utilization.

5. **CloudWatch Alarms**:
   - CloudWatch is used to monitor the resource usage (CPU or memory) of ECS service.
   - Alarms are set to trigger when CPU usage exceeds a predefined threshold, prompting the ECS service to scale out (add tasks).
   - Similarly, when CPU usage drops below a certain threshold, the scaling policy will scale in (remove tasks).

![Infrastucture Diagrame](Infra.jpg)

## Reasoning Behind the Approach

In this architecture, I have considered **Nginx** as the application server to demonstrate the scalability and availability of the setup. Here's the reasoning behind the approach:

1. **Nginx as the Application**:
   - I have chosen **Nginx** as the application, which is commonly used as a reverse proxy and web server. The DNS hostname of the **Application Load Balancer (ALB)** will be used to expose the application over the internet. 
   - When a user accesses the ALB's DNS hostname, it will route the request to the ECS service, which will display the Nginx default page. This confirms that the application (in this case, Nginx) is live and accessible over the internet.

2. **Containerization with ECS and CloudWatch Metrics for Scalability**:
   - Using ECS provides better resource efficiency compared to Auto Scaling Groups.
   - Containers can scale dynamically, and deployment is more efficient with minimal downtime.

3. **Elastic Load Balancer (ALB) for High Availability**:
   - The **ALB** is used to distribute traffic evenly among the ECS service, ensuring that the application can handle high availability and fault tolerance. If one instance becomes unhealthy or is scaled down, the ALB automatically routes the traffic to other healthy instances, ensuring uninterrupted service.

This setup ensures high availability, scalability, and cost-efficiency by leveraging AWS ECS for containerized application deployment instead of traditional EC2-based Auto Scaling Groups.