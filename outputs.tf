output "redis_id" {
  description = "Redis cluster IDs"
  value = {
    for k, v in module.redis : k => v.id
  }
}

output "redis_security_group_id" {
  description = "The ID of the created security group"
  value = {
    for k, v in module.redis : k => v.security_group_id
  }
}

output "redis_security_group_name" {
  description = "The name of the created security group"
  value = {
    for k, v in module.redis : k => v.security_group_name
  }
}

output "redis_port" {
  description = "Redis port"
  value = {
    for k, v in module.redis : k => v.port
  }
}

output "redis_endpoint" {
  description = "Redis primary, configuration or serverless endpoint, whichever is appropriate for the given configuration"
  value = {
    for k, v in module.redis : k => v.endpoint
  }
}

output "redis_reader_endpoint_address" {
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled or serverless is being used."
  value = {
    for k, v in module.redis : k => v.reader_endpoint_address
  }
}

output "redis_member_clusters" {
  description = "Redis cluster members"
  value = {
    for k, v in module.redis : k => v.member_clusters
  }
}

output "redis_host" {
  description = "Redis hostname"
  value = {
    for k, v in module.redis : k => v.host
  }
}

output "redis_arn" {
  description = "Elasticache Replication Group ARN"
  value = {
    for k, v in module.redis : k => v.arn
  }
}

output "redis_engine_version_actual" {
  description = "The running version of the cache engine"
  value = {
    for k, v in module.redis : k => v.engine_version_actual
  }
}

output "redis_cluster_enabled" {
  description = "Indicates if cluster mode is enabled"
  value = {
    for k, v in module.redis : k => v.cluster_enabled
  }
}

output "redis_serverless_enabled" {
  description = "Indicates if serverless mode is enabled"
  value = {
    for k, v in module.redis : k => v.serverless_enabled
  }
}

output "elasticache_user_ids" {
  description = "List of ElastiCache user IDs"
  value = [
    for user in aws_elasticache_user.redis_user : {
      user_id   = user.user_id
      user_name = user.user_name
    }
  ]
}

output "elasticache_user_group_ids" {
  description = "List of ElastiCache user group IDs"
  value = [
    for group in aws_elasticache_user_group.redis_user_group : {
      user_group_id = group.user_group_id
      engine        = group.engine
      user_ids      = group.user_ids
    }
  ]
}
