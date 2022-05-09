# NoteJam Application EKS Task
## Infrastructure.

![nord-cloud-eks.png](./documentation/nord-cloud-eks.png)  *Production and Staging are exact replicas*

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
  ### Documentation  is due

 


---------------------------

## Application Access-Dev
- dev-notejam.aqazi.xyz
- dev.grafana.aqazi.xyz
### Application Access-Prodnd Application Deployed
- prod.grafana.aqazi.xyz
- prod-notejam.aqazi.xyz


