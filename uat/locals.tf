locals {

  common_tags = {
    created_by = "terraform"
    project    = "easygenerator"
    owner      = "DevOps"
    Billing    = "EG-UAT"
  }

  documentdb = {
    name                            = lower("ezgen-${var.env}")
    cluster_size                    = "2"
    master_username                 = "ezgenuat"
    instance_class                  = "db.t3.medium"
    preferred_backup_window         = "23:00-02:00"
    cluster_family                  = "docdb3.6"
    engine_version                  = "3.6.0"
    enabled_cloudwatch_logs_exports = ["audit", "profiler"]
    cluster_dns_name                = "ezgen-${var.env}-documentdb"
    reader_dns_name                 = "ezgen-${var.env}-document-db-reader"
    preferred_maintenance_window    = "Mon:22:00-Mon:22:30"




    cluster_parameters = [
      {
        name         = "tls"
        value        = "disabled"
        apply_method = "pending-reboot"


      }
    ]

  }
  domain      = "easygenerator.com"
  domain_name = trimsuffix(local.domain, ".")

  route53 = {
    domain_internal = "uat.internal.easygenerator.com"
    domain_uat      = "uat.easygenerator.com"

  }


}
