output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_id" {
  value = data.aws_eks_cluster.cluster
}

output "cluster_auth" {
  value = data.aws_eks_cluster_auth.cluster
}
output "eks_host" {
  value = data.aws_eks_cluster.cluster.endpoint
}
output "cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

output "token" {
  value = data.aws_eks_cluster_auth.cluster.token
}
