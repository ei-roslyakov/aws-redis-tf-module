variable "redis" {
  description = "A map of Redis configurations, environment settings, security group configurations, and user access settings"
  type = map(object({
    # Redis Configuration
    vpc_id                        = optional(string)
    subnets                       = optional(list(string), [])
    elasticache_subnet_group_name = optional(string, "")
    maintenance_window            = optional(string, "wed:03:00-wed:04:00")
    cluster_size                  = optional(number, 1)
    port                          = optional(number, 6379)
    instance_type                 = optional(string, "cache.t2.micro")
    family                        = optional(string, "redis4.0")
    parameter = optional(list(object({
      name  = string
      value = string
    })), [])
    engine_version                       = optional(string, "4.0.10")
    at_rest_encryption_enabled           = optional(bool, false)
    transit_encryption_enabled           = optional(bool, true)
    transit_encryption_mode              = optional(string)
    notification_topic_arn               = optional(string, "")
    alarm_cpu_threshold_percent          = optional(number, 75)
    alarm_memory_threshold_bytes         = optional(number, 10000000)
    alarm_actions                        = optional(list(string), [])
    ok_actions                           = optional(list(string), [])
    apply_immediately                    = optional(bool, true)
    data_tiering_enabled                 = optional(bool, false)
    automatic_failover_enabled           = optional(bool, false)
    multi_az_enabled                     = optional(bool, false)
    availability_zones                   = optional(list(string), [])
    zone_id                              = optional(string, "")
    dns_subdomain                        = optional(string, "")
    auth_token                           = optional(string)
    auth_token_update_strategy           = optional(string, "ROTATE")
    kms_key_id                           = optional(string)
    replication_group_id                 = optional(string, "")
    snapshot_arns                        = optional(list(string), [])
    snapshot_name                        = optional(string)
    snapshot_window                      = optional(string, "06:30-07:30")
    snapshot_retention_limit             = optional(number, 0)
    final_snapshot_identifier            = optional(string)
    cluster_mode_enabled                 = optional(bool, false)
    cluster_mode_replicas_per_node_group = optional(number, 0)
    cluster_mode_num_node_groups         = optional(number, 0)
    cloudwatch_metric_alarms_enabled     = optional(bool, false)
    create_parameter_group               = optional(bool, true)
    parameter_group_description          = optional(string)
    parameter_group_name                 = optional(string)
    log_delivery_configuration           = optional(list(map(any)), [])
    description                          = optional(string)
    user_group_ids                       = optional(list(string))
    auto_minor_version_upgrade           = optional(bool)
    serverless_enabled                   = optional(bool, false)
    serverless_major_engine_version      = optional(string, "7")
    serverless_snapshot_time             = optional(string, "06:00")
    serverless_user_group_id             = optional(string)
    serverless_cache_usage_limits        = optional(map(any), {})

    # Context
    enabled             = optional(bool, true)
    namespace           = optional(string)
    tenant              = optional(string)
    environment         = optional(string)
    stage               = optional(string)
    name                = optional(string)
    delimiter           = optional(string)
    attributes          = optional(list(string), [])
    labels_as_tags      = optional(set(string), ["default"])
    tags                = optional(map(string), {})
    additional_tag_map  = optional(map(string), {})
    label_order         = optional(list(string))
    regex_replace_chars = optional(string)
    id_length_limit     = optional(number)
    label_key_case      = optional(string)
    label_value_case    = optional(string)
    descriptor_formats  = optional(any, {})
    #iam role
    iam_role_enable_default_boundary_policy = optional(bool, true)
    iam_role_default_boundary_name          = optional(string, "boundary")

    # Security Group
    create_security_group                = optional(bool, true)
    associated_security_group_ids        = optional(list(string), [])
    allowed_security_group_ids           = optional(list(string), [])
    security_group_name                  = optional(list(string), [])
    security_group_description           = optional(string, "Security group for Elasticache Redis")
    security_group_create_before_destroy = optional(bool, true)
    security_group_create_timeout        = optional(string, "10m")
    security_group_delete_timeout        = optional(string, "15m")
    allow_all_egress                     = optional(bool, null)
    additional_security_group_rules      = optional(list(any), [])
    target_security_group_id             = optional(list(string), [])
    preserve_security_group_id           = optional(bool, false)
    revoke_rules_on_delete               = optional(bool, false)
    inline_rules_enabled                 = optional(bool, false)

    # User Access
    access = optional(object({
      user_group_name = optional(string)
      users = optional(map(object({
        user_id              = string
        user_name            = string
        access_string        = string
        engine               = optional(string, "REDIS")
        passwords            = optional(list(string))
        no_password_required = optional(bool)
        tags                 = optional(map(string))
        authentication_mode = optional(object({
          type      = string
          passwords = optional(list(string))
        }))
      })), {})
      trusted_role_arns = optional(list(string), [])
    }), {})
  }))
  default = {}
}
