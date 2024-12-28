module "redis" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git//?ref=23723ddb716f07e7dbcbd080b9841cadcba8b04a" #v1.4.1"

  for_each = var.redis

  vpc_id                               = each.value.vpc_id
  subnets                              = each.value.subnets
  elasticache_subnet_group_name        = each.value.elasticache_subnet_group_name
  maintenance_window                   = each.value.maintenance_window
  cluster_size                         = each.value.cluster_size
  port                                 = each.value.port
  instance_type                        = each.value.instance_type
  family                               = each.value.family
  parameter                            = each.value.parameter
  engine_version                       = each.value.engine_version
  at_rest_encryption_enabled           = each.value.at_rest_encryption_enabled
  transit_encryption_enabled           = each.value.transit_encryption_enabled
  transit_encryption_mode              = each.value.transit_encryption_mode
  notification_topic_arn               = each.value.notification_topic_arn
  alarm_cpu_threshold_percent          = each.value.alarm_cpu_threshold_percent
  alarm_memory_threshold_bytes         = each.value.alarm_memory_threshold_bytes
  alarm_actions                        = each.value.alarm_actions
  ok_actions                           = each.value.ok_actions
  apply_immediately                    = each.value.apply_immediately
  data_tiering_enabled                 = each.value.data_tiering_enabled
  automatic_failover_enabled           = each.value.automatic_failover_enabled
  multi_az_enabled                     = each.value.multi_az_enabled
  availability_zones                   = each.value.availability_zones
  zone_id                              = each.value.zone_id
  dns_subdomain                        = each.value.dns_subdomain
  auth_token                           = each.value.auth_token
  auth_token_update_strategy           = each.value.auth_token_update_strategy
  kms_key_id                           = each.value.kms_key_id
  replication_group_id                 = each.value.replication_group_id
  snapshot_arns                        = each.value.snapshot_arns
  snapshot_name                        = each.value.snapshot_name
  snapshot_window                      = each.value.snapshot_window
  snapshot_retention_limit             = each.value.snapshot_retention_limit
  final_snapshot_identifier            = each.value.final_snapshot_identifier
  cluster_mode_enabled                 = each.value.cluster_mode_enabled
  cluster_mode_replicas_per_node_group = each.value.cluster_mode_replicas_per_node_group
  cluster_mode_num_node_groups         = each.value.cluster_mode_num_node_groups
  cloudwatch_metric_alarms_enabled     = each.value.cloudwatch_metric_alarms_enabled
  create_parameter_group               = each.value.create_parameter_group
  parameter_group_description          = each.value.parameter_group_description
  parameter_group_name                 = each.value.parameter_group_name
  log_delivery_configuration           = each.value.log_delivery_configuration
  description                          = each.value.description
  user_group_ids                       = each.value.user_group_ids
  auto_minor_version_upgrade           = each.value.auto_minor_version_upgrade
  serverless_enabled                   = each.value.serverless_enabled
  serverless_major_engine_version      = each.value.serverless_major_engine_version
  serverless_snapshot_time             = each.value.serverless_snapshot_time
  serverless_user_group_id             = aws_elasticache_user_group.redis_user_group[each.key].id
  serverless_cache_usage_limits        = each.value.serverless_cache_usage_limits
  # Context
  enabled             = each.value.enabled
  namespace           = each.value.namespace
  tenant              = each.value.tenant
  environment         = each.value.environment
  stage               = each.value.stage
  name                = each.value.name
  delimiter           = each.value.delimiter
  attributes          = each.value.attributes
  labels_as_tags      = each.value.labels_as_tags
  tags                = each.value.tags
  additional_tag_map  = each.value.additional_tag_map
  label_order         = each.value.label_order
  regex_replace_chars = each.value.regex_replace_chars
  id_length_limit     = each.value.id_length_limit
  label_key_case      = each.value.label_key_case
  label_value_case    = each.value.label_value_case
  descriptor_formats  = each.value.descriptor_formats
  # Security Group Parameters
  create_security_group                = each.value.create_security_group
  associated_security_group_ids        = each.value.associated_security_group_ids
  allowed_security_group_ids           = each.value.allowed_security_group_ids
  security_group_name                  = each.value.security_group_name
  security_group_description           = each.value.security_group_description
  security_group_create_before_destroy = each.value.security_group_create_before_destroy
  security_group_create_timeout        = each.value.security_group_create_timeout
  security_group_delete_timeout        = each.value.security_group_delete_timeout
  allow_all_egress                     = each.value.allow_all_egress
  additional_security_group_rules      = each.value.additional_security_group_rules
  target_security_group_id             = each.value.target_security_group_id
  preserve_security_group_id           = each.value.preserve_security_group_id
  revoke_rules_on_delete               = each.value.revoke_rules_on_delete
  inline_rules_enabled                 = each.value.inline_rules_enabled

  depends_on = [
    aws_elasticache_user_group.redis_user_group
  ]
}
