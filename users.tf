resource "aws_elasticache_user" "redis_user" {
  for_each = { for user in local.redis_users : "${user.redis_key}:${user.user_key}" => user }

  user_id       = each.value.user.user_id
  user_name     = each.value.user.user_name
  access_string = each.value.user.access_string
  engine        = lookup(each.value.user, "engine", "REDIS")

  dynamic "authentication_mode" {
    for_each = lookup(each.value.user, "authentication_mode", null) != null ? [each.value.user.authentication_mode] : []
    content {
      type      = authentication_mode.value.type
      passwords = lookup(authentication_mode.value, "passwords", null)
    }
  }

  no_password_required = lookup(each.value.user, "no_password_required", null)
  passwords            = lookup(each.value.user, "passwords", null)
  tags                 = lookup(each.value.user, "tags", null)
}

resource "aws_elasticache_user_group" "redis_user_group" {
  for_each = local.redis_user_group_config

  engine        = "REDIS"
  user_group_id = each.value.user_group_id

  user_ids = concat([for user_id in each.value.user_ids : aws_elasticache_user.redis_user["${each.key}:${user_id}"].id], ["default"])

  tags = var.redis[each.key].tags

  lifecycle {
    ignore_changes = [user_ids]
  }

  depends_on = [
    aws_elasticache_user.redis_user
  ]
}

