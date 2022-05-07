locals {
  waf_name = "${var.waf_name}-${var.env}"
  ip_sets= {
    whitelist_ipv4_prod = {
      ip_address_version = "IPV4"
      description        = "Allow whitelist for IPV4 addresses"
    }
    whitelist_ipv6_prod = {
      ip_address_version = "IPV6"
      description        = "Allow whitelist for IPV6 addresses"
    }
    scanners_probes_ipv6_prod = {
      ip_address_version = "IPV6"
      description        = "Block Scanners/Probes IPV6 addresses"
    }
    scanners_probes_ipv4_prod = {
      ip_address_version = "IPV4"
      description        = "Block Scanners/Probes IPV4 addresses"
    }
    ipreputationlist_ipv6_prod = {
      ip_address_version = "IPV6"
      description        = "Block Reputation List IPV6 addresses"
    }
    ipreputationlist_ipv4_prod = {
      ip_address_version = "IPV4"
      description        = "Block Reputation List IPV4 addresses"
    }
    ip_badbot_ipv6_prod = {
      ip_address_version = "IPV6"
      description        = "Block Bad Bot IPV6 addresses"
    }
    ip_badbot_ipv4_prod = {
      ip_address_version = "IPV4"
      description        = "Block Bad Bot IPV4 addresses"
    }

    blacklist_ipv6_prod = {
      ip_address_version = "IPV6"
      description        = "Block blacklist for IPV6 addresses"
    }
    blacklist_ipv6_prod = {
      ip_address_version = "IPV4"
      description        = "Block blacklist for IPV4 addresses"
    }
  }

}