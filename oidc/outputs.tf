output "github_aws_oidc_role" {
  value = aws_iam_role.github_aws_oidc_role.name
}

output "github_aws_oidc_policy" {
  value = aws_iam_policy.github_aws_oidc_policy.name
}