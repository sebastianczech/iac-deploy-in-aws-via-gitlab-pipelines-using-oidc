# Deploy IaC in AWS via Gitlab pipelines using OIDC

Simple repository created to deploy infrastructure using Terraform into AWS cloud by Gitlab pipeline using OpenID Connect. Whole integration between AWS and Gitlab was configured using [Configure OpenID Connect in AWS to retrieve temporary credentials](https://docs.gitlab.com/ee/ci/cloud_services/aws/) by:
1. adding identity provider in AWS as described in [Configure OpenID Connect between GitLab and AWS](https://gitlab.com/guided-explorations/aws/configure-openid-connect-in-aws) or [Terraform Pipeline with Gitlab CI and OIDC for AWS](https://globaldatanet.com/tech-blog/terraform-pipeline-with-gitlab-ci-and-oidc-for-aws)
1. configuring the role and trust policy (code for [IAM role and policy configuration is available in oidc subfolder](oidc)):
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "${var.gitlab_provider_arn}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                       "gitlab.com:sub": "project_path:mygroup/myproject:ref_type:branch:ref:main"
                    }
                }
            }
        ]
    }
    ```
2. updating your Gitlab pipeline by retrieving temporary credentials:
    ```
    assume role:
    script:
        - >
        export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s"
        $(aws sts assume-role-with-web-identity
        --role-arn ${ROLE_ARN}
        --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
        --web-identity-token $CI_JOB_JWT_V2
        --duration-seconds 3600
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
        --output text))
        - aws sts get-caller-identity
    ```
