data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

# output tls {
#   value = data.tls_certificate.gitlab
# }

resource "aws_iam_openid_connect_provider" "gitlab_provider" {
  url             = var.gitlab_url
  client_id_list  = [var.gitlab_aud]
  thumbprint_list = [for item in data.tls_certificate.gitlab.certificates: item.sha1_fingerprint]
}

resource "aws_iam_role" "gitlab_aws_oidc_role" {
  name = "GitlabPipelineAwsOIDCRole"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "${aws_iam_openid_connect_provider.gitlab_provider.arn}"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
            "gitlab.com:sub": "project_path:sebastianczech/deploy-iac-in-aws-via-gitlab-pipelines-using-oidc:ref_type:branch:ref:main"
        }
			}
		}
	]
}
EOF
}

resource "aws_iam_policy" "gitlab_aws_oidc_policy" {
  name        = "GitlabPipelineAwsOIDCPolicy"
  description = "Policy allowing to create DynamoDB table by Gitlab pipeline"

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

resource "aws_iam_role_policy_attachment" "gitlab_aws_oidc_policy_attachment" {
  role       = aws_iam_role.gitlab_aws_oidc_role.name
  policy_arn = aws_iam_policy.gitlab_aws_oidc_policy.arn
}