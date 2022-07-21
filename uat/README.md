## Proposed Architecture

![](./assets/UAT-DevOps.png)
```

 Name                                                                                Monthly Qty  Unit                    Monthly Cost 
                                                                                                                                       
 module.acm_internal.aws_route53_record.validation[0]                                                                                  
 ├─ Standard queries (first 1B)                                                Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                   Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                 Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                       
 module.alb_internal.aws_lb.this[0]                                                                                                    
 ├─ Application load balancer                                                                730  hours                         $18.40 
 └─ Load balancer capacity units                                               Monthly cost depends on usage: $5.84 per LCU            
                                                                                                                                       
 module.alb_public.aws_lb.this[0]                                                                                                      
 ├─ Application load balancer                                                                730  hours                         $18.40 
 └─ Load balancer capacity units                                               Monthly cost depends on usage: $5.84 per LCU            
                                                                                                                                       
 module.cloudwatch_logs.aws_cloudwatch_log_group.default[0]                                                                            
 ├─ Data ingested                                                              Monthly cost depends on usage: $0.57 per GB             
 ├─ Archival Storage                                                           Monthly cost depends on usage: $0.03 per GB             
 └─ Insights queries data scanned                                              Monthly cost depends on usage: $0.0057 per GB           
                                                                                                                                       
 module.documentdb-cluster.aws_docdb_cluster.default[0]                                                                                
 └─ Backup storage                                                             Monthly cost depends on usage: $0.00 per GB             
                                                                                                                                       
 module.documentdb-cluster.aws_docdb_cluster_instance.default[0]                                                                       
 ├─ Database instance (on-demand, db.t3.medium)                                              730  hours                         $61.32 
 ├─ Storage                                                                    Monthly cost depends on usage: $0.00 per GB             
 ├─ I/O requests                                                               Monthly cost depends on usage: $0.00 per 1M requests    
 └─ CPU credits                                                                Monthly cost depends on usage: $0.09 per vCPU-hours     
                                                                                                                                       
 module.documentdb-cluster.module.dns_master.aws_route53_record.default[0]                                                             
 ├─ Standard queries (first 1B)                                                Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                   Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                 Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                       
 module.documentdb-cluster.module.dns_replicas.aws_route53_record.default[0]                                                           
 ├─ Standard queries (first 1B)                                                Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                   Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                 Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                       
 module.documentdb_kms.aws_kms_key.this[0]                                                                                             
 ├─ Customer master key                                                                        1  months                         $1.00 
 ├─ Requests                                                                   Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                                       
 module.efs.aws_efs_file_system.default[0]                                                                                             
 └─ Storage (standard)                                                         Monthly cost depends on usage: $0.33 per GB             
                                                                                                                                       
 module.efs.module.dns.aws_route53_record.default[0]                                                                                   
 ├─ Standard queries (first 1B)                                                Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                   Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                 Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                       
 module.efs_kms.aws_kms_key.this[0]                                                                                                    
 ├─ Customer master key                                                                        1  months                         $1.00 
 ├─ Requests                                                                   Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                                       
 module.elasticache-redis.aws_elasticache_replication_group.default[0]                                                                 
 └─ ElastiCache (on-demand, cache.t3.micro)                                                  730  hours                         $13.14 
                                                                                                                                       
 module.mod_eks.module.base.aws_cloudwatch_log_group.this[0]                                                                           
 ├─ Data ingested                                                              Monthly cost depends on usage: $0.57 per GB             
 ├─ Archival Storage                                                           Monthly cost depends on usage: $0.03 per GB             
 └─ Insights queries data scanned                                              Monthly cost depends on usage: $0.0057 per GB           
                                                                                                                                       
 module.mod_eks.module.base.aws_eks_cluster.this[0]                                                                                    
 └─ EKS cluster                                                                              730  hours                         $73.00 
                                                                                                                                       
 module.mod_eks.module.base.module.kms.aws_kms_key.this[0]                                                                             
 ├─ Customer master key                                                                        1  months                         $1.00 
 ├─ Requests                                                                   Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                                       
 module.mod_vpc.module.uat_vpc.aws_nat_gateway.this[0]                                                                                 
 ├─ NAT gateway                                                                              730  hours                         $35.04 
 └─ Data processed                                                             Monthly cost depends on usage: $0.048 per GB            
                                                                                                                                       
 module.mod_vpc.module.uat_vpc.aws_nat_gateway.this[1]                                                                                 
 ├─ NAT gateway                                                                              730  hours                         $35.04 
 └─ Data processed                                                             Monthly cost depends on usage: $0.048 per GB            
                                                                                                                                       
 module.mod_vpc.module.uat_vpc.aws_nat_gateway.this[2]                                                                                 
 ├─ NAT gateway                                                                              730  hours                         $35.04 
 └─ Data processed                                                             Monthly cost depends on usage: $0.048 per GB            
                                                                                                                                       
 module.mq_broker.aws_mq_broker.default[0]                                                                                             
 ├─ Instance usage (RabbitMQ, mq.m5.large, single_instance)                                  730  hours                        $234.33 
 └─ Storage (RabbitMQ, EBS)                                                    Monthly cost depends on usage: $0.11 per GB             
                                                                                                                                       
 module.rds_kms.aws_kms_key.this[0]                                                                                                    
 ├─ Customer master key                                                                        1  months                         $1.00 
 ├─ Requests                                                                   Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                                           Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                                       
 module.route53_zones.aws_route53_zone.this["internal.easygenerator.com"]                                                              
 └─ Hosted zone                                                                                1  months                         $0.50 
                                                                                                                                       
 module.route53_zones.aws_route53_zone.this["uat.easygenerator.com"]                                                                   
 └─ Hosted zone                                                                                1  months                         $0.50 
                                                                                                                                       
 module.win_nodes_secretsmanager_keypair.aws_secretsmanager_secret.secret_key                                                          
 ├─ Secret                                                                                     1  months                         $0.40 
 └─ API requests                                                               Monthly cost depends on usage: $0.05 per 10k requests   
                                                                                                                                       