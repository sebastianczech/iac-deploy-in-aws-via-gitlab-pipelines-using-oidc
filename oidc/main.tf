resource "aws_iam_role" "github_aws_oidc_role" {
  name = "GitHubActionsAwsOIDCRole"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "${var.github_provider_arn}"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringLike": {
					"token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:evcode-sebastian-czech/iac-deploy-in-aws-via-github-actions-using-oidc:*"
				}
			}
		}
	]
}
EOF
}

resource "aws_iam_policy" "github_aws_oidc_policy" {
  name        = "GitHubActionsAwsOIDCPolicy"
  description = "Policy allowing to create DynamoDB table by GitHub Actions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_aws_oidc_policy_attachment" {
  role       = aws_iam_role.github_aws_oidc_role.name
  policy_arn = aws_iam_policy.github_aws_oidc_policy.arn
}