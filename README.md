# AWS CloudWatch Exporter

This project contains an AWS Lambda function for exporting CloudWatch logs to S3. It includes Go source code for the
function and Terraform code for setting up the S3 bucket, IAM role and Lambda function.

## Prerequisites

- Go v1.19
- AWS CLI v2
- Terraform v1.3.7+

## Deploy function

### Build Go binary

```bash
OUT_PATH="terraform/cloudwatch-exporter/resources/artifacts/main"

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${OUT_PATH}
```

### Build infrastructure

The following variables need to be set, see [.envrc.sample](.envrc.sample) for example:

| Variable              | Description                     |
|-----------------------|---------------------------------|
| AWS_ACCESS_KEY_ID     | AWS access key id               |
| AWS_SECRET_ACCESS_KEY | AWS secret access key           |
| TF_CLI_ARGS_init      | Terraform backend configuration |
| TF_WORKSPACE          | Terraform workspace             |

Deploy infrastructure

```bash
cd terraform
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## Invoke function

Invoke the Lambda function with log group name, destination prefix, and from and to timestamps

```bash
FUNCTION_NAME=$(cd terraform && terraform output -raw function_name)

PAYLOAD='{
  "log_group": "my-log-group",
  "prefix": "my-log-group/2023-02-04",
  "from": 1675468800000,
  "to": 1675555200000
}'

aws lambda invoke \
--function-name=${FUNCTION_NAME} \
--payload=${PAYLOAD} \
--cli-binary-format=raw-in-base64-out \
response.json
```
