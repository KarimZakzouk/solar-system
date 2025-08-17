name: Solar System Workflow

on: 
  workflow_dispatch:
  push:
    branches:
      - main
      - 'feature-branch-A'

jobs:
    terraform:
      name: Terraform Deployment
      runs-on: ubuntu-latest
      environment: production
      steps:
        - name: Checkout Repository
          uses: actions/checkout@v5

        - name: Login to AWS
          uses: aws-actions/configure-aws-credentials@v4.3.1
          with:
            aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
            aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            aws_region: us-east-1

        - name: Setup Terraform
          uses: hashicorp/setup-terraform@v3.1.2
          with:
            terraform_version: 1.0.0

        - name: Terraform Init
          run: terraform init
          working-directory: ./Terraform

        - name: Terraform Plan
          run: terraform plan
          working-directory: ./Terraform

        - name: Terraform Apply
          run: terraform apply -auto-approve
          working-directory: ./Terraform


        # - name: Terraform Apply or Destroy
        #   run: |
        #     if [ "${{ github.event.inputs.destroy }}" == "yes" ]; then
        #       terraform destroy -auto-approve
        #     else
        #       terraform apply -auto-approve
        #     fi
        #   working-directory: ./Terraform
