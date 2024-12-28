module "iam_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy?ref=89fe17a6549728f1dc7e7a8f7b707486dfb45d89" # 5.44.0

  for_each = var.redis

  name        = "${each.key}-elasticache-access-policy"
  path        = "/"
  description = "Policy created for ElastiCache cluster ${each.key} to allow access to the cluster"

  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Action" = [
          "elasticache:Connect"
        ]
        "Resource" = concat(
          [local.elasticache_cluster_arns[each.key]],
          local.elasticache_user_arns[each.key]
        )
      }
    ]
  })

  tags = each.value.tags
}

module "iam_assumable_role_custom" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role?ref=89fe17a6549728f1dc7e7a8f7b707486dfb45d89" # 5.44.0

  for_each = var.redis

  trusted_role_arns             = lookup(each.value.access, "trusted_role_arns", [])
  role_name                     = "${each.key}-elasticache-access-role"
  create_role                   = true
  role_requires_mfa             = false
  role_permissions_boundary_arn = each.value.iam_role_enable_default_boundary_policy ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${each.value.iam_role_default_boundary_name}" : each.value.role_permissions_boundary_arn

  custom_role_policy_arns = [
    module.iam_policy[each.key].arn
  ]
  number_of_custom_role_policy_arns = 1

  tags = each.value.tags
}
