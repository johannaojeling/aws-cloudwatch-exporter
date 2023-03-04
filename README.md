# AWS CloudWatch Exporter

This project contains an AWS Lambda function for exporting CloudWatch logs to S3. It includes Go source code for the
function and Terraform code for setting up the S3 bucket, IAM role, Lambda function and EventBridge trigger. The
function is scheduled to run on a daily basis and writes the logs to `s3://{bucket}/{log_group}/{%Y-%m-%d}/`.

## Prerequisites

- Go v1.19
- AWS CLI v2
- Terraform v1.3.7+

## Deployment

### Build Go binary

```bash
OUT_PATH="terraform/cloudwatch-exporter/resources/artifacts/main"

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${OUT_PATH}
```

### Deploy infrastructure

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
