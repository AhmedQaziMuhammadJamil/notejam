data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

locals {
  eks_managed_node_group_defaults = {
    
    create_launch_template               = true
    //subnets                              = var.private_subnets
    instance_types                       = ["t3.large"]
    set_instance_types_on_lt             = true
    capacity_type                        = "ON_DEMAND"
    metadata_http_endpoint               = "enabled"
    metadata_http_tokens                 = "required"
    metadata_http_put_response_hop_limit = 2
    ebs_optimized                        = true
    disk_type                            = "gp3"
    disk_size                            = 50
    disk_encrypted                       = true
    disk_kms_key_id                      = data.aws_kms_alias.ebs.target_key_arn
    create_iam_role                      = true
   

  }
  node_groups = {
     apps = merge(local.eks_managed_node_group_defaults, {
      name = "apps-${var.env}"
      subnets =  var.private_subnets[0]
      instance_types   = ["t3.large"]
      max_capacity     = 3
      min_capacity     = 1
      desired_capacity = 1
      node_security_group_id              =  [var.worker-sg]
      k8s_labels = {
        scope = "apps"
      }
/*       taints = [
        {
          key    = "scope"
          value  = "apps"
          effect = "NO_SCHEDULE"
        }
      ] */
    }) 
    monitoring = merge(local.eks_managed_node_group_defaults, {
      name = "monitoring-${var.env}"
      node_security_group_id              =  [var.worker-sg]
       subnets =  var.private_subnets[1]
      max_capacity     = 3
      min_capacity     = 1
      desired_capacity = 1

      k8s_labels = {
        scope = "monitoring"
      }
      /* taints = [
        {
          key    = "scope"
          value  = "monitoring"
          effect = "NO_SCHEDULE"
        }
      ] */
    })
    operations = merge(local.eks_managed_node_group_defaults, {
      name  = "operations-${var.env}"
      node_security_group_id              =  [var.worker-sg]
       subnets =  var.private_subnets[2]
      max_capacity     = 3
      min_capacity     = 1
      desired_capacity = 1

      k8s_labels = {
        scope = "operations"
      }
/*        taints = [
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]  */
    }) 
  }

  cluster_name    = "notejam-${var.env}"
  cluster_version = "1.21"
  name            = "ex-iam-eks-role"
  region          = "eu-west-1"
  coredns = {
    cluster_name      = module.eks.cluster_id
    addon_name        = "coredns"
    addon_version     = "v1.8.4-eksbuild.1"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.custom_tags,
      {
        "eks_addon" = "coredns"
      }
    )
  }
  vpc-cni = {
    cluster_name = module.eks.cluster_id
    addon_name   = "vpc-cni"

    addon_version = "v1.10.2-eksbuild.1"

    resolve_conflicts        = "OVERWRITE"
    //service_account_role_arn = module.vpc_cni_ipv4_irsa_role.iam_role_arn

  }
  kube-proxy = {
    cluster_name      = module.eks.cluster_id
    addon_name        = "kube-proxy"
    addon_version     = "v1.21.2-eksbuild.2"
    resolve_conflicts = "OVERWRITE"

    tags = merge(
      var.custom_tags,
      {
        "eks_addon" = "kube-proxy"
      }
    )
  }
  admin_access = {
    description = "Admin ingress to Kubernetes API"
    cidr_blocks = ["10.10.0.0/16"] //TODO add subnets
    protocol    = "all"
    from_port   = 0
    to_port     = 65535
    type        = "ingress"
  }
  node_egress = {
    description = "EgressTraffic"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "all"
    from_port   = 0
    to_port     = 65535
    type        = "egress"
  }
  ingress_all_node = {
  description = "Node to node traffic open"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  type        = "ingress"
  self        = true
}
 
}
module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.20.5"
  cluster_name                    = local.cluster_name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access = true //TODO: Make it public

  //create_cni_ipv6_iam_policy = true
  
  enable_irsa                = true
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  cluster_addons = {
    kube-proxy = "${local.kube-proxy}"
    vpc-cni    = "${local.vpc-cni}"
    coredns    = "${local.coredns}"
  }
  cluster_encryption_config = [{
    provider_key_arn = var.cluster_kms
    resources        = ["secrets"]
  }]
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true 
    create_node_security_group = false
    vpc_security_group_ids     = [var.worker-sg]
    ami_type                   = "AL2_x86_64"
    create_iam_role            = true
    iam_role_use_name_prefix   = true
     node_security_group_id              =  [var.worker-sg]
     create_security_group = false
  }

  eks_managed_node_groups                = local.node_groups
  cluster_security_group_use_name_prefix = true
  create_iam_role                        = true
  iam_role_use_name_prefix               = false
  create_node_security_group =  true
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    metrics-server = {
    description = "metrics ingress to Kubernetes API"
    cidr_blocks = ["10.10.0.0/16"] //TODO add subnets
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
    type        = "ingress"
  }
   ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }

   cluster_security_group_additional_rules = {
    admin_access = "${local.admin_access}"
    node_egress  = "${local.node_egress}"
     ingress_all_node = "${local.ingress_all_node}"
  }   
}


### Auth-config

 # aws-auth configmap
  /* manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::003767002475:user/aqazi"
      username = "aqazi"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = ["003767002475"]


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

 */



##INGRESS

data "aws_region" "current" {}

data "aws_eks_cluster" "target" {
  name = local.cluster_name

  depends_on = [
    module.eks
  ]

}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name

    depends_on = [
    module.eks
  ]

}



data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
/* provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
} */

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
     load_config_file       = false
    
  }
}

provider "kubernetes" {
    version                = "~>1.10.0"
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority.0.data)
    exec {
        api_version = "client.authentication.k8s.io/v1alpha1"
        args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
        command     = "aws"
     }
     load_config_file       = false
}
/* 
resource "null_resource" "k8s_patcher" {
  triggers = {
    // fire any time the cluster is update in a way that changes its endpoint or auth
    endpoint = data.aws_eks_cluster.cluster.endpoint
    ca_crt   = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token    = nonsensitive(data.aws_eks_cluster_auth.cluster.token)
  }
   provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command = <<EOH
cat >/tmp/ca.crt <<EOF
${self.triggers.ca_crt}
EOF
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator && chmod +x ./aws-iam-authenticator && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && \
mkdir -p $HOME/bin && mv ./aws-iam-authenticator $HOME/bin/ && export PATH=$PATH:$HOME/bin && \
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile \
aws eks --region eu-west-1 --profile sandbox update-kubeconfig --name notejam-dev

./kubectl --server="${self.triggers.endpoint}" --certificate_authority=/tmp/ca.crt  --token="${self.triggers.token}" get namespace flux-system -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | ./kubectl  --server="${self.triggers.endpoint}" --certificate_authority=/tmp/ca.crt --token="${self.triggers.token}" replace --raw /api/v1/namespaces/flux-system/finalize -f - \
cat > delete_stuck_ns.sh << "EOF"
#!/usr/bin/env bash

function delete_namespace () {
    echo "Deleting namespace $1"
    kubectl get namespace flux-system -o json > tmp.json
    sed -i 's/"kubernetes"//g' tmp.json
    kubectl replace --raw "/api/v1/namespaces/flux-system/finalize" -f ./tmp.json
    rm ./tmp.json
}

TERMINATING_NS=$(kubectl get ns | awk '$2=="Terminating" {print $1}')

for ns in $TERMINATING_NS
do
    delete_namespace $ns
done
EOF

chmod +x delete_stuck_ns.sh

EOH
  }
} */
 
data "template_file" "kubeconfig" {
  template = <<-EOF
    apiVersion: v1
    kind: Config
    current-context: terraform
    clusters:
    - name: "${data.aws_eks_cluster.target.name}"
      cluster:
        certificate-authority-data: ${data.aws_eks_cluster.target.certificate_authority.0.data}
        server: "${data.aws_eks_cluster.target.endpoint}"
    contexts:
    - name: terraform
      context:
        cluster: "${data.aws_eks_cluster.target.name}"
        user: terraform
    users:
    - name: terraform
      user:
        token: "${data.aws_eks_cluster_auth.cluster.token}"
EOF
}

resource "null_resource" "update_ns_annotations" {
  triggers = {
    kubeconfig = base64encode(data.template_file.kubeconfig.rendered)
    cmd_patch = <<-EOF
      curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl  \
      echo $KUBECONFIG | base64 --decode \
      kubectl --kubeconfig <(echo $KUBECONFIG | base64 --decode) get namespace flux-system -o json  > tmp.json  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl   --kubeconfig <(echo $KUBECONFIG | base64 --decode) \ replace --raw /api/v1/namespaces/flux-system/finalize -f - \
      sed -i 's/"kubernetes"//g' tmp.json
      kubectl --kubeconfig <(echo $KUBECONFIG | base64 --decode) replace --raw "/api/v1/namespaces/flux-system/finalize" -f ./tmp.json
      rm ./tmp.json
      kubectl --kubeconfig --kubeconfig <(echo $KUBECONFIG | base64 --decode) delete namespace flux-system --cascade=true --wait=false && sleep 120

     EOF
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    interpreter = ["/bin/bash", "-c","curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl","echo $KUBECONFIG | base64 --decode"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command =<<-EOF
    ${self.triggers.cmd_patch}"
     kubectl --kubeconfig "${self.triggers.kubeconfig}" delete namespace flux-system --cascade=true --wait=false && sleep 120
    EOF
  }

  depends_on = [ data.aws_eks_cluster.cluster]
}





data "aws_iam_policy" "cw_agent_policy" {
  arn="arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "additional" {
  for_each =module.eks.eks_managed_node_groups

  policy_arn = data.aws_iam_policy.cw_agent_policy.arn
  role       = each.value.iam_role_name
}



module "alb-ingress" {
  source       = "Young-ook/eks/aws//modules/alb-ingress"
  cluster_name =  local.cluster_name
  oidc         = {arn=module.eks.oidc_provider_arn
                  url=module.eks.oidc_provider}
  tags         = { env = "test" }
}