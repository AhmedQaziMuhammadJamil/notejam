# NoteJam EKS Implementation (WIP)


## BackGround: 
[Notejam](https://github.com/komarserjio/notejam) is a note taking monolith application currently deployed  on  a single server along with its SQLite-DB .This raises serious concerns over the applications  scalability,high availability and  security.We are tasked to refactor this application and deploy it onto a public cloud.This helps us with Undifferentiated Lifting 

![Notejam](https://i.imgur.com/WVo00oY.png) *Current Application Architecture*



## Business requirements

- The application must serve a variable amount of traffic. Most users are active during business hours. During big events and conferences, the traffic could be 4 times more than typical.
- Notes should be preserved up to 3 years and recovered, if needed.
- Service continuity should be maintained in case of datacenter failures.
- The service must be capable of being migrated to any region supported by the cloud provider in case of an emergency.
- The target architecture must support more than 100 developers to work on, with multiple daily deployments, without interruption / downtime.
- The target architecture must provide separated environments to support processes for development, testing and deployment to production in the near future.
- Relevant infrastructure metrics and logs should be collected for quality assurance and security purposes.




## Proposed Architecure:
![nord-cloud-eks.png](https://i.imgur.com/OE618Jh.png)  *Production and Staging Env's are exact replicas*

### Architecutre BreakDown: 
- GitHub is used for storing code
- GitHub Actions are used as CI to build the image using buildah and push the OCI compliant image to Private ECR repo. 
- The EKS Control Plane is in AWS account and the access to worker nodes is done via an ENI attached to the Worker Node VPC.
- VPC is created with multiple Private,Public and DB subnets in each AZ.
- Each Public Subnet contains NAT GateWay for outbound traffic.
- Inbound Traffic is controlled via AWS Load Balancer that has WAF 
- TCP and UDP traffic and ports  are restricted using AWS Security Groups
- RDS DataBase has a subnet group that consists of multiple subnets across different AZ's
- AWS Cloudwatch is used to get metrics and logs from Worker Nodes,RDS,WAF and VPC flow logs
- S3 is used to store DB backups
- AWS Secrets Manager is used to store secrets for kubernetes Pods
- Flux is bootstrapped to the cluster using Terraform Provider it contains image repo controller that continously scans ECR for image updates and update this image in the kubernetes manifest that then is deployed.

## Proposed Solution:
 In order to meet the business requirements it is essential to adhere to AWS WAF(Well-Architected-Framework) principles.The proposed solution is aligned with the WAF 5 pillars.

1. Operational excellence 
2. Cost optimization 
3. Reliability 
4. Performance efficiency 
5. Security  

### Operational excellence
- Refactor [Notejam](https://github.com/komarserjio/notejam) to microservices based solution using a  containerzation service such as AWS EKS. EKS offers managed control plane that is highly available,can be integrated with  many AWS services ,multiple third party and open source solutions can also help cover niche usecases.
### Reliability 
- Decouple the application,move the DB to AWS RDS which allows Multi-AZ for high availability.
- AWS EKS has managed control plane thats highly available.
- Nodes can scale out in multiple AZ's incase one AZ is impacted.
- Resources are deployed over multiple AZ's to support the application.
- DB snapshots are taken automatically


### Cost optimization
-  In order to optimize cost the some of the resource can be have reversed instance pricing namely AWS RDS and EKS Worker Nodes.Instances can be rightsized as per the usage based on historic metric data.
  
### Performance efficiency 
- EKS allows us to scale up to hundered's of nodes based on requirements,whether its spot instances or scheduled scaling AWS AutoScaling can manage Scalability.
- AWS RDS Aurora is high performing cloud native DDB that allows us to have multiple Read Replicas ,Cross Region Replica for DR,Backup of PTR(Point in Time Restore).Scaling Up and Scaling Down with minimal downtime.
 

### Security 
 - Different tiers such as Data Tier,Application Tier are decoupled.The networking layer is secured using the best pratices ,the application and database have their own networking subnets,security groups.
 - Application resources have fine grained IAM policy access to ensure only relevant access is allowed.
- Underlying block volumes of storage are encrypted using AWS KMS keys.
- Changes to the infrastructure are made using IaC (Terraform),git acts as the main source of Truth.










### Tasks Completed

- [x] GitHub Actions CI-Images are created  using Buildah and authentication is done using OIDC.

- [x] Flux 2 is bootsraped using Terraform Provider.

- [x] Terraform is used to create networking compute and storage layers on AWS, Terraform Cloud is used for state management.

- [x] Monitoring (AWS Cloudwatch Container Insights) and FluentD via FluxV2 and Kustomization. 

- [x] WAF is used to protect application and secrets are managed by Secrets Manager.

- [x] Scalability is managed by Cluster AutoScaler and AutoScaling Group 
- [x] HPA is also created.
- [x]  AWS-Ingress-Controller is created  using helm  chart and deployed via Flux
- [x] Application and dependencies  are Deployed via Flux Image Controllers.
- [x] RDS DBBackups are done via kubernetes cronjob.


## Wip 
  ### Documentation  in Wip

 


---------------------------

## Application Access-Dev
- dev-notejam.aqazi.xyz
- dev.grafana.aqazi.xyz
### Application Access-Prodnd Application Deployed
- prod.grafana.aqazi.xyz
- prod-notejam.aqazi.xyz


