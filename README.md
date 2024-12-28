# Terraform AWS ElastiCache Redis Module

This Terraform module creates an AWS ElastiCache Redis cluster along with necessary IAM policies and roles. It also manages users and user groups for fine-grained access control.

## Overview

This module allows you to deploy an AWS ElastiCache Redis cluster with the following capabilities:

- **ElastiCache Redis Cluster**: Provisions an ElastiCache Redis cluster with customizable configurations.
- **IAM Policies and Roles**: Creates IAM policies that allow access to the Redis cluster and associates them with roles.
- **User and User Group Management**: Manages Redis users and user groups for enhanced security and access control.

## Usage

```hcl
module "redis" {
  source = "./path/to/module"

  redis = {
    "example-cluster" = {
      name                              = "example-cluster"
      enabled                           = true
      vpc_id                            = "vpc-xxxxxxx"
      subnets                           = ["subnet-xxxxxxx"]
      serverless_enabled                = true
      serverless_major_engine_version   = "7"
      at_rest_encryption_enabled        = false
      serverless_cache_usage_limits = {
        data_storage = {
          maximum = 5
        }
        ecpu_per_second = {
          maximum = 1000
        }
      }
      security_group_create_before_destroy = true
      security_group_name                  = ["example-sg"]
      security_group_delete_timeout        = "5m"
      tags = {
        "Environment" = "dev"
        "Project"     = "example"
      }
      access = {
        user_group_name = "example"
        users = {
          "testusername" = {
            user_id       = "testusername"
            user_name     = "testusername"
            access_string = "on ~* +@all"
            engine        = "REDIS"
            authentication_mode = {
              type = "iam"
            }
          }
          "testusername2" = {
            user_id       = "testusername2"
            user_name     = "testusername2"
            access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo"
            engine        = "REDIS"
            authentication_mode = {
              type      = "password"
              passwords = ["password1", "password2"]
            }
          }
        }
        trusted_role_arns = [
          "arn:aws:iam::123456789012:role/role1",
          "arn:aws:iam::123456789012:role/role2"
        ]
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_custom"></a> [iam\_assumable\_role\_custom](#module\_iam\_assumable\_role\_custom) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role | v5.39.1 |
| <a name="module_iam_policy"></a> [iam\_policy](#module\_iam\_policy) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy | v5.34.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | cloudposse/elasticache-redis/aws | 1.4.1 |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_user.redis_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user) | resource |
| [aws_elasticache_user_group.redis_user_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_redis"></a> [redis](#input\_redis) | A map of Redis configurations, environment settings, security group configurations, and user access settings | <pre>map(object({<br>    # Redis Configuration<br>    vpc_id                        = optional(string)<br>    subnets                       = optional(list(string), [])<br>    elasticache_subnet_group_name = optional(string, "")<br>    maintenance_window            = optional(string, "wed:03:00-wed:04:00")<br>    cluster_size                  = optional(number, 1)<br>    port                          = optional(number, 6379)<br>    instance_type                 = optional(string, "cache.t2.micro")<br>    family                        = optional(string, "redis4.0")<br>    parameter = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    engine_version                       = optional(string, "4.0.10")<br>    at_rest_encryption_enabled           = optional(bool, false)<br>    transit_encryption_enabled           = optional(bool, true)<br>    transit_encryption_mode              = optional(string)<br>    notification_topic_arn               = optional(string, "")<br>    alarm_cpu_threshold_percent          = optional(number, 75)<br>    alarm_memory_threshold_bytes         = optional(number, 10000000)<br>    alarm_actions                        = optional(list(string), [])<br>    ok_actions                           = optional(list(string), [])<br>    apply_immediately                    = optional(bool, true)<br>    data_tiering_enabled                 = optional(bool, false)<br>    automatic_failover_enabled           = optional(bool, false)<br>    multi_az_enabled                     = optional(bool, false)<br>    availability_zones                   = optional(list(string), [])<br>    zone_id                              = optional(list(string), [])<br>    dns_subdomain                        = optional(string, "")<br>    auth_token                           = optional(string)<br>    auth_token_update_strategy           = optional(string, "ROTATE")<br>    kms_key_id                           = optional(string)<br>    replication_group_id                 = optional(string, "")<br>    snapshot_arns                        = optional(list(string), [])<br>    snapshot_name                        = optional(string)<br>    snapshot_window                      = optional(string, "06:30-07:30")<br>    snapshot_retention_limit             = optional(number, 0)<br>    final_snapshot_identifier            = optional(string)<br>    cluster_mode_enabled                 = optional(bool, false)<br>    cluster_mode_replicas_per_node_group = optional(number, 0)<br>    cluster_mode_num_node_groups         = optional(number, 0)<br>    cloudwatch_metric_alarms_enabled     = optional(bool, false)<br>    create_parameter_group               = optional(bool, true)<br>    parameter_group_description          = optional(string)<br>    parameter_group_name                 = optional(string)<br>    log_delivery_configuration           = optional(list(map(any)), [])<br>    description                          = optional(string)<br>    user_group_ids                       = optional(list(string))<br>    auto_minor_version_upgrade           = optional(bool)<br>    serverless_enabled                   = optional(bool, false)<br>    serverless_major_engine_version      = optional(string, "7")<br>    serverless_snapshot_time             = optional(string, "06:00")<br>    serverless_user_group_id             = optional(string)<br>    serverless_cache_usage_limits        = optional(map(any), {})<br><br>    # Context<br>    enabled             = optional(bool, true)<br>    namespace           = optional(string)<br>    tenant              = optional(string)<br>    environment         = optional(string)<br>    stage               = optional(string)<br>    name                = optional(string)<br>    delimiter           = optional(string)<br>    attributes          = optional(list(string), [])<br>    labels_as_tags      = optional(set(string), ["default"])<br>    tags                = optional(map(string), {})<br>    additional_tag_map  = optional(map(string), {})<br>    label_order         = optional(list(string))<br>    regex_replace_chars = optional(string)<br>    id_length_limit     = optional(number)<br>    label_key_case      = optional(string)<br>    label_value_case    = optional(string)<br>    descriptor_formats  = optional(any, {})<br><br>    # Security Group<br>    create_security_group                = optional(bool, true)<br>    associated_security_group_ids        = optional(list(string), [])<br>    allowed_security_group_ids           = optional(list(string), [])<br>    security_group_name                  = optional(list(string), [])<br>    security_group_description           = optional(string, "Security group for Elasticache Redis")<br>    security_group_create_before_destroy = optional(bool, true)<br>    security_group_create_timeout        = optional(string, "10m")<br>    security_group_delete_timeout        = optional(string, "15m")<br>    allow_all_egress                     = optional(bool, null)<br>    additional_security_group_rules      = optional(list(any), [])<br>    target_security_group_id             = optional(list(string), [])<br>    preserve_security_group_id           = optional(bool, false)<br>    revoke_rules_on_delete               = optional(bool, false)<br>    inline_rules_enabled                 = optional(bool, false)<br><br>    # User Access<br>    access = optional(object({<br>      user_group_name = optional(string)<br>      users = optional(map(object({<br>        user_id              = string<br>        user_name            = string<br>        access_string        = string<br>        engine               = optional(string, "REDIS")<br>        passwords            = optional(list(string))<br>        no_password_required = optional(bool)<br>        tags                 = optional(map(string))<br>        authentication_mode = optional(object({<br>          type      = string<br>          passwords = optional(list(string))<br>        }))<br>      })), {})<br>      trusted_role_arns = optional(list(string), [])<br>    }), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elasticache_user_group_ids"></a> [elasticache\_user\_group\_ids](#output\_elasticache\_user\_group\_ids) | List of ElastiCache user group IDs |
| <a name="output_elasticache_user_ids"></a> [elasticache\_user\_ids](#output\_elasticache\_user\_ids) | List of ElastiCache user IDs |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | Elasticache Replication Group ARN |
| <a name="output_redis_cluster_enabled"></a> [redis\_cluster\_enabled](#output\_redis\_cluster\_enabled) | Indicates if cluster mode is enabled |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis primary, configuration or serverless endpoint, whichever is appropriate for the given configuration |
| <a name="output_redis_engine_version_actual"></a> [redis\_engine\_version\_actual](#output\_redis\_engine\_version\_actual) | The running version of the cache engine |
| <a name="output_redis_host"></a> [redis\_host](#output\_redis\_host) | Redis hostname |
| <a name="output_redis_id"></a> [redis\_id](#output\_redis\_id) | Redis cluster IDs |
| <a name="output_redis_member_clusters"></a> [redis\_member\_clusters](#output\_redis\_member\_clusters) | Redis cluster members |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_reader_endpoint_address"></a> [redis\_reader\_endpoint\_address](#output\_redis\_reader\_endpoint\_address) | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled or serverless is being used. |
| <a name="output_redis_security_group_id"></a> [redis\_security\_group\_id](#output\_redis\_security\_group\_id) | The ID of the created security group |
| <a name="output_redis_security_group_name"></a> [redis\_security\_group\_name](#output\_redis\_security\_group\_name) | The name of the created security group |
| <a name="output_redis_serverless_enabled"></a> [redis\_serverless\_enabled](#output\_redis\_serverless\_enabled) | Indicates if serverless mode is enabled |
<!-- END_TF_DOCS --><!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.62 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.62 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_custom"></a> [iam\_assumable\_role\_custom](#module\_iam\_assumable\_role\_custom) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role | 89fe17a6549728f1dc7e7a8f7b707486dfb45d89 |
| <a name="module_iam_policy"></a> [iam\_policy](#module\_iam\_policy) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy | 89fe17a6549728f1dc7e7a8f7b707486dfb45d89 |
| <a name="module_redis"></a> [redis](#module\_redis) | git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git// | 23723ddb716f07e7dbcbd080b9841cadcba8b04a |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_user.redis_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user) | resource |
| [aws_elasticache_user_group.redis_user_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_redis"></a> [redis](#input\_redis) | A map of Redis configurations, environment settings, security group configurations, and user access settings | <pre>map(object({<br>    # Redis Configuration<br>    vpc_id                        = optional(string)<br>    subnets                       = optional(list(string), [])<br>    elasticache_subnet_group_name = optional(string, "")<br>    maintenance_window            = optional(string, "wed:03:00-wed:04:00")<br>    cluster_size                  = optional(number, 1)<br>    port                          = optional(number, 6379)<br>    instance_type                 = optional(string, "cache.t2.micro")<br>    family                        = optional(string, "redis4.0")<br>    parameter = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    engine_version                       = optional(string, "4.0.10")<br>    at_rest_encryption_enabled           = optional(bool, false)<br>    transit_encryption_enabled           = optional(bool, true)<br>    transit_encryption_mode              = optional(string)<br>    notification_topic_arn               = optional(string, "")<br>    alarm_cpu_threshold_percent          = optional(number, 75)<br>    alarm_memory_threshold_bytes         = optional(number, 10000000)<br>    alarm_actions                        = optional(list(string), [])<br>    ok_actions                           = optional(list(string), [])<br>    apply_immediately                    = optional(bool, true)<br>    data_tiering_enabled                 = optional(bool, false)<br>    automatic_failover_enabled           = optional(bool, false)<br>    multi_az_enabled                     = optional(bool, false)<br>    availability_zones                   = optional(list(string), [])<br>    zone_id                              = optional(string, "")<br>    dns_subdomain                        = optional(string, "")<br>    auth_token                           = optional(string)<br>    auth_token_update_strategy           = optional(string, "ROTATE")<br>    kms_key_id                           = optional(string)<br>    replication_group_id                 = optional(string, "")<br>    snapshot_arns                        = optional(list(string), [])<br>    snapshot_name                        = optional(string)<br>    snapshot_window                      = optional(string, "06:30-07:30")<br>    snapshot_retention_limit             = optional(number, 0)<br>    final_snapshot_identifier            = optional(string)<br>    cluster_mode_enabled                 = optional(bool, false)<br>    cluster_mode_replicas_per_node_group = optional(number, 0)<br>    cluster_mode_num_node_groups         = optional(number, 0)<br>    cloudwatch_metric_alarms_enabled     = optional(bool, false)<br>    create_parameter_group               = optional(bool, true)<br>    parameter_group_description          = optional(string)<br>    parameter_group_name                 = optional(string)<br>    log_delivery_configuration           = optional(list(map(any)), [])<br>    description                          = optional(string)<br>    user_group_ids                       = optional(list(string))<br>    auto_minor_version_upgrade           = optional(bool)<br>    serverless_enabled                   = optional(bool, false)<br>    serverless_major_engine_version      = optional(string, "7")<br>    serverless_snapshot_time             = optional(string, "06:00")<br>    serverless_user_group_id             = optional(string)<br>    serverless_cache_usage_limits        = optional(map(any), {})<br><br>    # Context<br>    enabled             = optional(bool, true)<br>    namespace           = optional(string)<br>    tenant              = optional(string)<br>    environment         = optional(string)<br>    stage               = optional(string)<br>    name                = optional(string)<br>    delimiter           = optional(string)<br>    attributes          = optional(list(string), [])<br>    labels_as_tags      = optional(set(string), ["default"])<br>    tags                = optional(map(string), {})<br>    additional_tag_map  = optional(map(string), {})<br>    label_order         = optional(list(string))<br>    regex_replace_chars = optional(string)<br>    id_length_limit     = optional(number)<br>    label_key_case      = optional(string)<br>    label_value_case    = optional(string)<br>    descriptor_formats  = optional(any, {})<br>    #iam role<br>    iam_role_enable_default_boundary_policy = optional(bool, true)<br>    iam_role_default_boundary_name          = optional(string, "boundary")<br><br>    # Security Group<br>    create_security_group                = optional(bool, true)<br>    associated_security_group_ids        = optional(list(string), [])<br>    allowed_security_group_ids           = optional(list(string), [])<br>    security_group_name                  = optional(list(string), [])<br>    security_group_description           = optional(string, "Security group for Elasticache Redis")<br>    security_group_create_before_destroy = optional(bool, true)<br>    security_group_create_timeout        = optional(string, "10m")<br>    security_group_delete_timeout        = optional(string, "15m")<br>    allow_all_egress                     = optional(bool, null)<br>    additional_security_group_rules      = optional(list(any), [])<br>    target_security_group_id             = optional(list(string), [])<br>    preserve_security_group_id           = optional(bool, false)<br>    revoke_rules_on_delete               = optional(bool, false)<br>    inline_rules_enabled                 = optional(bool, false)<br><br>    # User Access<br>    access = optional(object({<br>      user_group_name = optional(string)<br>      users = optional(map(object({<br>        user_id              = string<br>        user_name            = string<br>        access_string        = string<br>        engine               = optional(string, "REDIS")<br>        passwords            = optional(list(string))<br>        no_password_required = optional(bool)<br>        tags                 = optional(map(string))<br>        authentication_mode = optional(object({<br>          type      = string<br>          passwords = optional(list(string))<br>        }))<br>      })), {})<br>      trusted_role_arns = optional(list(string), [])<br>    }), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elasticache_user_group_ids"></a> [elasticache\_user\_group\_ids](#output\_elasticache\_user\_group\_ids) | List of ElastiCache user group IDs |
| <a name="output_elasticache_user_ids"></a> [elasticache\_user\_ids](#output\_elasticache\_user\_ids) | List of ElastiCache user IDs |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | Elasticache Replication Group ARN |
| <a name="output_redis_cluster_enabled"></a> [redis\_cluster\_enabled](#output\_redis\_cluster\_enabled) | Indicates if cluster mode is enabled |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis primary, configuration or serverless endpoint, whichever is appropriate for the given configuration |
| <a name="output_redis_engine_version_actual"></a> [redis\_engine\_version\_actual](#output\_redis\_engine\_version\_actual) | The running version of the cache engine |
| <a name="output_redis_host"></a> [redis\_host](#output\_redis\_host) | Redis hostname |
| <a name="output_redis_id"></a> [redis\_id](#output\_redis\_id) | Redis cluster IDs |
| <a name="output_redis_member_clusters"></a> [redis\_member\_clusters](#output\_redis\_member\_clusters) | Redis cluster members |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_reader_endpoint_address"></a> [redis\_reader\_endpoint\_address](#output\_redis\_reader\_endpoint\_address) | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled or serverless is being used. |
| <a name="output_redis_security_group_id"></a> [redis\_security\_group\_id](#output\_redis\_security\_group\_id) | The ID of the created security group |
| <a name="output_redis_security_group_name"></a> [redis\_security\_group\_name](#output\_redis\_security\_group\_name) | The name of the created security group |
| <a name="output_redis_serverless_enabled"></a> [redis\_serverless\_enabled](#output\_redis\_serverless\_enabled) | Indicates if serverless mode is enabled |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
