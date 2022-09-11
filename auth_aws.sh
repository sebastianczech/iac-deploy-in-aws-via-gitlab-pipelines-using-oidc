 #!/bin/bash
STS=($(aws sts assume-role-with-web-identity --role-arn ${ROLE_ARN} --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}" --web-identity-token $CI_JOB_JWT_V2 --duration-seconds 3600 --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text))
export AWS_ACCESS_KEY_ID="${STS[0]}"
export AWS_SECRET_ACCESS_KEY="${STS[1]}"
export AWS_SESSION_TOKEN="${STS[2]}"