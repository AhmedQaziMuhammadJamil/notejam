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
- Changes to the infrastructure are made using IaC (Terraform),git acts as the main source of truth.


# Terraform 
The infrastructure is deployed using Terraform.AWS resources are created using different terraform modules.Terraform is integrated with GitHub as the source,Pull Requests can be used to initiate terraform plan before merging the code into the main git branch.This allows  us to evaluate our changes in desired env before merging them .Speculative plans can also be run from terminal to view planned changes without creating PR.The terraform state is managed by Terraform Cloud.Terraform Cloud is ideal for state management as it provides versioning and stat locking features.


```
├── dev-infra
├── notejam-django
├── notejam-django-prod
├── operations-k8s-dev
├── operations-k8s-prod
├── prod-infra
└── README.md
```
Folders infra and prod-infra contain code terraform code for staging and production env.

```
├── locals.tf
├── main.tf
├── modules
│   ├── ecr
│   ├── eks
│   ├── flux
│   ├── github
│   ├── iam
│   ├── kms
│   ├── rds
│   ├── security-groups
│   ├── vpc
│   └── waf
├── providers.tf
└── variables.tf
 ```
The following structure was choosen to follow modular design,this allows us to seperate functionality of different modules,allowing us to make changes without impacting other modules ,better re-usability and easier debugging are also a major benefit of this modular design.

#### main.tf --> This file is used to call on other modules that are needed to build  the env.

#### variable.tf --> contains different variables that are passed to the modules eg env variable is used to create resources based on env.
#### locals.tf --> contains local values that are primarily used within main.tf

#### providers.tf ---> contains the information about terraform workspaces and required providers that interact with different cloud apis for creating the resources

### Modules
```
├── modules
│   ├── ecr --> Creates ECR Repo as Per Env
│   ├── eks --> Creates EKS Cluster and IRSA roles as per env
│   ├── flux --> Flux provider to Bootstrap flux to EKS cluster
│   ├── github --> Used to create github OIDC connection for ECR 
│   ├── iam --> Responsible for creating various roles and IAM users
│   ├── kms --> Responsible for creating KMS keys for worker nodes,S3 and RDs
│   ├── rds --> Creates RDS Cluster with reader and writer ,username ,DB-Name,DB-Host and password are sent to Secrets Manager
│   ├── security-groups --> security groups for RDS,ALB,EKS
│   ├── vpc -->  Creates VPC with 3Public,3Private Subnets,3DB-Subnets
│   └── waf -- > Creates AWS  Regional WAF with ALB
```


## Inputs
| Name                  | Description                                 | Type    | Default                 | Required | Variable Location |
|-----------------------|---------------------------------------------|---------|-------------------------|----------|-------------------|
| region                | Infrastructure-Deployment-Region            | String  | eu-west-1               | No       | variables.tf      |
| vpc_cidr              | VPC-CIDR for the env                        | String  | 192.168.0.0/16          | No       | variables.tf      |
| env                   | Env name used                               | String  | Prod                    | No       | variables.tf      |
| TF_VAR_github_owner   | Github Owner Name                           | String  | AhmedQaziMuhammadJamil  | Yes      | Terraform-Cloud   |
| TF_VAR_github_token   | Github Owner Token                          | String  | Set Your Token          | Yes      | Terraform-Cloud   |
| TF_VAR_db_user        | DBuser for the DB                           | String  | Set Your DBuser name    | Yes      | Terraform-Cloud   |
| TF_VAR_db_name        | Name of the DB in RDS                       | String  | Set your DB-Name        | Yes      | Terraform-Cloud   |
| TF_VAR_db_pass        | DB password                                 | String  | Set your DB-Pass        | Yes      | Terraform-Cloud   |
| AWS_ACCESS_KEY_ID     | AWS Access Key for deployment of resources  | String  | Set your AWS Access Key | Yes      | Terraform-Cloud   |
| AWS_SECRET_ACCESS_KEY | AWS Access Key for deployment of resources  | String  | Set your AWS Secret Key | Yes      | Terraform-Cloud   |
| github_repositories   | Github repo name required by modules/github | String  | notejam                 |          |                   |


***Some of the variables stated above need to explicitly defined in Terraform cloud either as variables for  each workspace,variables such as db_name,db_pass can differ as per workspace env(stage or prod) but since we are using Accesskeys,Secrets Keys and Github token  we can use variable sets and apply these variables to more than one workspace as these are not environment independent.***


## Steps to create resources with TF:
1. Change the name of the organization and workspace in  provider.tf of each env
2. Add the relevant values given in the table above to start creating infrastructure through Terraform.
3. Once the resources are created with Terraform its time to configure github actions and flux manifests
### GitHub Secrets

| Name           | Description           | Type          |
|----------------|-----------------------|---------------|
| AWS_ACCOUNT_ID | AWS Account ID        | GitHub-Secret |
| AWS_REGION     | AWS Region for ECR    | GitHub-Secret |
| PROD_REGISTRY  | ECR PROD REGISTRY URL | GitHub-Secret |
| REGISTRY       | ECR DEV REGISTRY URL  | GitHub-Secret |

**Update GitHub Secrets after Terraform deployment**

Its important that the github secrets are updated incase you are deploying to a different account id and the ecr repos are following different naming convention.Test the image creation.

### Flux Deployments
By using Terraform flux provider,flux is  bootstrapped to our EKS cluster with all the required controllers and configurations. Terraform flux provider from each env creates repository for each env,depending on the env it can be operations-k8s-prod or operations-k8s-dev.These repositories contain flux-manifsts that are applied to the Cluster as well as target path where all the flux manifests should be placed .

## Steps:
1. Copy the kubernetes manifests in the notejam repo from the folder operations-k8s-dev or operations-k8s-prod.Do not copy flux-system,this folder was created during the bootstrap process.Each newly created  target repo has its own flux-system folder.Only copy the manifests infrastructure.yaml,ingress-Class.yaml,microservices.yaml and namespaces.yaml.These manifests refer to folder with further configurations copy and paste them maintaining the same hierarcy
2. Once copied the final list should be something like this
```
├── clusters
│   └── services
│       ├── flux-system
│       ├── infrastructure.yaml
│       ├── ingress-Class.yaml
│       ├── microservices.yaml
│       └── namespaces.yaml
├── infrastructure
│   ├── base
│   │   ├── helmrepositories
│   │   └── kustomization.yaml
│   ├── common
│   │   ├── aws-otel.yaml
│   │   ├── cluster-autoscaler.yaml
│   │   ├── ingress-prom.yaml
│   │   ├── kustomization.yaml
│   │   ├── metrics-server.yaml
│   │   └── prometheus.yaml
│   ├── csi-driver
│   │   ├── kustomization.yaml
│   │   └── secrets-csi-driver.yaml
│   ├── image-repo
│   │   ├── app-repo.yaml
│   │   ├── image-policy.yaml
│   │   ├── image-update.yaml
│   │   └── kustomization.yaml
│   └── production
│       ├── aws-alb-controller.yaml
│       ├── kustomization.yaml
│       └── new-ascp.yaml
├── ingress-Class
│   ├── ingress-class.yaml
│   └── kustomization.yaml
├── microservices
│   ├── app.yaml
│   ├── backup-cm.yaml
│   ├── backup-cronjob.yaml
│   ├── cron-backup-secret-store.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── kustomization.yaml
│   └── notejam-deployment-secrets.yaml
├── namespaces
│   ├── kustomization.yaml
│   ├── monitoring.yaml
│   └── prod.yaml
└── README.md
```


Once the files are added and changes are committed you can either wait for flux to apply the changes or run the following commands to reconcile git and helm releases.

1. `flux reconcile source git prod-source -n flux-system`
2. ` flux reconcile kustomization infrastructure -n flux-system`
3. ` flux reconcile kustomization notejam-prod-application -n flux-system`
4. `flux reconcile helmrelease aws-load-balancer-controller -n production`


**The notejam-application pod will fail to start due to ImagePullBack error,this is because the ecr image address is older and obselete .You can initate a build from Github actions and based on the availability of the fresh image the manifest is automatically updated in GitHub and the newly modified manifest is automatically applied.Once the pod is up and running check if your AWS-Ingress-Controller automatically created ALB in AWS Console.Create a Route53 Alias Record and map the ALB DNS to this record for usage**




### Business Requirements Fulfilled: 
- [x]  The resources can dynamically scale up and down using AWS Autoscaling with Cluster AutoScaler.During Big events we can setup scheduled scaling policy that enables us to have extra nodes inplace.
- [x]  Using Kubernetes Cronjob we are take pgsql backups and storing them in S3 for 3 years,AWS snapshots through AWS Backup are also an option but considering the size of snapshots and retention costs,its better to go with Kubernetes Cronjob  
- [x] RDS Aurora  Cluster with Read Replica(Different AZ) and Multi AZ  is highly available  helps against data center failure. EKS nodes are spread across multiple AZ's.Failure in one data center shouldn't impact workloads.
- [x] Kubernetes gives us the flexibility to not only be vendor agnostic   but also makes it easier to deploy application easily on other kubernetes enviornments.Kubernetes manifests and yaml files that are in github,along with terraform code.By changing the env variable in terraform code   new env can easily be created.
- [x]  Using GitHub Actions and flux image controllers we can update the pod images automatically.Once an image is updated in ecr ,flux conrtoller scans this repo and updates the respective kubernetes manifest with the new image tag.Once this change is commited flux kustomization controller reconciles and  applies this change
- [x]  We have setup 2 env's prod and stage with the same resource types.These env's have their own terraform code and kubernetes manifests.Each env is independent from the other.
- [x]  AWS Container insights and fluentd allow for metrics and logs to be visible in cloudwatch for monitoring and analysis purposes.Moreover Graffana and Prometheus are also deplloyed but not configured 





### Common  Debug Commands
```
Update kubeconfig
aws eks --region eu-west-1 --profile sandbox update-kubeconfig --name notejam-dev

aws eks --region eu-west-1 --profile sandbox update-kubeconfig --name notejam-prod

Delete Namespace stuck in terminating state
NS=`kubectl get ns |grep Terminating | awk 'NR==1 {print $1}'` && kubectl get namespace "$NS" -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/$NS/finalize -f -

Force Delete secret 
aws secretsmanager delete-secret --secret-id your-secret --force-delete-without-recovery --region eu-west-1 --profile sandbox

```



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


### Enhancements
- [ ] Use Velaro for DR
- [ ] Use Atlantis/Spacelift for Terraform
- [ ] Use Tekton for Pipelines
- [ ] Enable Encryption Inside the Cluster Ingress (HTTPS-SSL)
- [ ] Use Sealed Secrets -Vault
- [ ] Work with Network Policies
- [ ] Work on GateKeeper
- [ ] Work on OPA
- [ ] Work with Taints and Tolerations ( priority -High)
- [ ] Configure  Loki  along with Alert Managed
- [ ] Work with contour or Traefik ingress
- [ ] Use Github Actions with Private Runners and connect with Vault
- [ ] Use Kaniko in Github Actions using PACKR
- [ ] Build Github Actions  Runners using Packr

---------------------------

## Application Access-Dev
- dev-notejam.aqazi.xyz
- dev.grafana.aqazi.xyz
### Application Access-Prodnd Application Deployed
- prod.grafana.aqazi.xyz
- prod-notejam.aqazi.xyz


