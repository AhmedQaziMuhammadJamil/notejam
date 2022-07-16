locals {

  common_tags = {
    created_by = "terraform"
    project    = "easygenerator"
    owner      = "DevOps"
    Billing    = "EG-UAT"
  }

/*     document-db = {
    cluster_size = 2
    master_username = ezgen-uat
    instance_class = db.t4g.medium
  } */

}
