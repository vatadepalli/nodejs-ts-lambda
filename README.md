# NodeJS TS Lambda

## NodeJS Development

This project uses typescript, which compiles into javascript

1. Install Dependencies for Local Development

        yarn

2. Package for Terraform Deployment

        yarn package

## Terraform Deployment

1. Create a file - terraform.tfvars - in the root directory by copying the example - and fill values 

        cp terraform.tfvars.example terraform.tfvars

2. Initate Terraform & Deploy

        terraform init

        terraform apply