

resource "aws_wafv2_ip_set" "cloudflare_ipv4" {
  //provider = aws.use1

  name               = "${var.env}-cloudflare-ipv4"
  description        = "${var.env}-cloudflare-ipv4"
  scope              = "REGIONAL" //change
  ip_address_version = "IPV4"
  addresses          = var.cloudflare_ipv4

  tags = var.common_tags
  
}

resource "aws_wafv2_ip_set" "cloudflare_ipv6" {
  //provider = aws.use1

  name               = "${var.env}-cloudflare-ipv6"
  description        = "${var.env}-cloudflare-ipv6"
  scope              = "REGIONAL" //change
  ip_address_version = "IPV6"
  addresses          = var.cloudflare_ipv6

  tags =  var.common_tags
   
}

 
 
 
 module "waf_public_alb" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "3.8.1"
  name_prefix = "${var.env}-alb-public"
  alb_arn     = var.alb_arn

  allow_default_action = true

  create_alb_association = true

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.env}-waf-setup-waf-main-metrics"
    sampled_requests_enabled   = false
  }
  rules = [

   
    {
      name     = "cloudflare-ipv4"
      priority = "0"
      action   = "allow"

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.cloudflare_ipv4.arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name       = "${var.env}-cloudflare-ip4"
        sampled_requests_enabled   = false
      }
    },
        {
      name     = "cloudflare-ipv6"
      priority = "1"
      action   = "allow"

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.cloudflare_ipv6.arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name       = "${var.env}-cloudflare-ip6"
        sampled_requests_enabled   = false
      }
    },

    ]
} 

