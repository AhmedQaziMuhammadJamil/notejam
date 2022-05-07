locals {
  waf_name = "${var.waf_name}-${var.env}"
  ip_sets = {
    whitelist_ipv4 = {
      ip_address_version = "IPV4-${var.env}"
      description        = "Allow whitelist for IPV4 addresses"
    }
    whitelist_ipv6 = {
      ip_address_version = "IPV6-${var.env}"
      description        = "Allow whitelist for IPV6 addresses"
    }
    scanners_probes_ipv6 = {
      ip_address_version = "IPV6-${var.env}"
      description        = "Block Scanners/Probes IPV6 addresses"
    }
    scanners_probes_ipv4 = {
      ip_address_version = "IPV4-${var.env}"
      description        = "Block Scanners/Probes IPV4 addresses"
    }
    ipreputationlist_ipv6 = {
      ip_address_version = "IPV6-${var.env}"
      description        = "Block Reputation List IPV6 addresses"
    }
    ipreputationlist_ipv4 = {
      ip_address_version = "IPV4-${var.env}"
      description        = "Block Reputation List IPV4 addresses"
    }
    ip_badbot_ipv6 = {
      ip_address_version = "IPV6-${var.env}"
      description        = "Block Bad Bot IPV6 addresses"
    }
    ip_badbot_ipv4 = {
      ip_address_version = "IPV4-${var.env}"
      description        = "Block Bad Bot IPV4 addresses"
    }

    blacklist_ipv6 = {
      ip_address_version = "IPV6-${var.env}"
      description        = "Block blacklist for IPV6 addresses"
    }
    blacklist_ipv6 = {
      ip_address_version = "IPV4-${var.env}"
      description        = "Block blacklist for IPV4 addresses"
    }
  }

}