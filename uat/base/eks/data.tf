data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}
data "aws_ami" "win_ami" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["Windows_Server-2019-English-Core-EKS_Optimized-${local.cluster_version}-*"]
    }
}
