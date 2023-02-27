resource "random_id" "suffix" {
  byte_length = 4
}

module "cloud_armor" {
  source = "GoogleCloudPlatform/cloud-armor/google"

  project_id                  = module.project-networking.project_id
  name                        = "policy-${random_id.suffix.hex}"
  default_rule_action         = "allow"
  type                        = "CLOUD_ARMOR"
  layer_7_ddos_defense_enable = false

  pre_configured_rules = {

    "sqli_sensitivity_level_4" = {
      action            = "deny(502)"
      priority          = 1
      target_rule_set   = "sqli-v33-stable"
      sensitivity_level = 2
    }

    "xss-stable_level_2_with_exclude" = {
      action            = "deny(502)"
      priority          = 2
      target_rule_set   = "xss-v33-stable"
      sensitivity_level = 2
    }
  }
}