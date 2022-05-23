resource "aws_wafv2_web_acl" "main" {
  description = "Custom WAFWebACL"

  name  = local.waf_name
  scope = "REGIONAL"


  default_action {
    allow {
    }
  }


  rule {
    name     = "whitelist"
    priority = 3

    action {
      allow {
      }
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["whitelist_ipv4"].arn
          }
        }
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["whitelist_ipv6"].arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "whitelist"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "bad-bot"
    priority = 8

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["ip_badbot_ipv4"].arn
          }
        }
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["ip_badbot_ipv6"].arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "bad-bot"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "blacklist"
    priority = 4

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["blacklist_ipv6"].arn
          }
        }
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["blacklist_ipv6"].arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blacklist"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "http-floodrate"
    priority = 5

    action {

      block {
      }
    }

    statement {

      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 2000
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "http-flood-rate"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "ip-reputation"
    priority = 7

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["ipreputationlist_ipv4"].arn
          }
        }
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["ipreputationlist_ipv6"].arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ipreputation-listsrule"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "scanners-and-Probes"
    priority = 6

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["scanners_probes_ipv4"].arn
          }
        }
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_sets["scanners_probes_ipv6"].arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "scanners-probes-rule"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "sql-Injection"
    priority = 9

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          sqli_match_statement {
            field_to_match {

              query_string {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          sqli_match_statement {
            field_to_match {

              body {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          sqli_match_statement {
            field_to_match {

              uri_path {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          sqli_match_statement {
            field_to_match {

              single_header {
                name = "authorization"
              }
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          sqli_match_statement {
            field_to_match {

              single_header {
                name = "cookie"
              }
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "sql-Injection"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "xss"
    priority = 10

    action {

      block {
      }
    }

    statement {

      or_statement {
        statement {

          xss_match_statement {
            field_to_match {

              query_string {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          xss_match_statement {
            field_to_match {

              body {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          xss_match_statement {
            field_to_match {

              uri_path {}
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {

          xss_match_statement {
            field_to_match {

              single_header {
                name = "cookie"
              }
            }

            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "xss"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "custom-whitelist-2"
    priority = 1

    action {

      count {
      }
    }

    statement {

      size_constraint_statement {
        comparison_operator = "LE"
        size                = 8192

        field_to_match {

          body {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "custom-whitelist-2"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {

      none {}
    }

    statement {

      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "EC2MetaDataSSRF_BODY"
        }
        excluded_rule {
          name = "EC2MetaDataSSRF_COOKIE"
        }
        excluded_rule {
          name = "GenericRFI_BODY"
        }
        excluded_rule {
          name = "NoUserAgent_HEADER"
        }
        excluded_rule {
          name = "SizeRestrictions_BODY"
        }
        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "MetricForAMRCRS"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAFWebACL"
    sampled_requests_enabled   = true
  }
}


resource "aws_wafv2_ip_set" "ip_sets" {
  ## We are ignoring the changes in the addresses block because the ips list of ips are constantly updated in remote resouce,
  ##this would result in a mismatch between the tf state list and the remote list.
  lifecycle {
    ignore_changes = [addresses]
  }

  for_each           = local.ip_sets
  addresses          = []
  description        = each.value.description
  ip_address_version = each.value.ip_address_version
  name               = each.key
  scope              = "REGIONAL"

}

 resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.load_balancer_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
 
resource "aws_cloudwatch_log_group" "waf" {
  name = "aws-waf-logs-${var.env}-group" // As per AWS waf logs for resources such as S3 and Cloudwatch logs name should start with aws-waf-log
}


resource "aws_wafv2_web_acl_logging_configuration" "cloudwatch_association" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
} 