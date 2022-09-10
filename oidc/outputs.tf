output "gitlab_aws_oidc_role" {
  value = aws_iam_role.gitlab_aws_oidc_role.name
}

output "gitlab_aws_oidc_policy" {
  value = aws_iam_policy.gitlab_aws_oidc_policy.name
}