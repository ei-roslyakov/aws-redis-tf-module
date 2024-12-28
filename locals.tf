locals {
  elasticache_user_arns = {
    for redis_key, redis_config in var.redis :
    redis_key => [
      for user_key, user in lookup(redis_config.access, "users", {}) :
      "arn:aws:elasticache:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:user:${user.user_id}"
    ]
  }
  elasticache_cluster_arns = {
    for k, v in module.redis : k => v.arn
  }
  redis_users = flatten([
    for redis_key, redis_config in var.redis : [
      for user_key, user in lookup(redis_config.access, "users", {}) : {
        redis_key = redis_key
        user_key  = user_key
        user      = user
      }
    ]
  ])
  redis_user_group_config = {
    for redis_key, redis_config in var.redis :
    redis_key => {
      user_group_id = redis_config.access.user_group_name
      user_ids      = [for user_key, user in lookup(redis_config.access, "users", {}) : user.user_id]
    }
  }
}