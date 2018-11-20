#!/bin/bash

#Check if terrafrom.tfvar exists and has valid pinpoint app

if [ ! -e ~/Research/Cloud/Terraform/terraform.tfvar ]; then
  echo ""
  echo "pinpointID=id" > terraform.tfvar
  
  #Create pinpoint app
  pinpoint_id_raw=$(aws pinpoint create-app --create-application-request Name="NFP_Breastfeeding_App" | grep Id );
  IFS=':' read -ra ID <<< "$pinpoint_id_raw";
  echo "${ID[1]//,}";

  #Replaces id in var.tf
  sed -i '' -e "s/id/${ID[1]//,}/g" ~/Research/Cloud/Terraform/terraform.tfvar

  #Remove " and , from string
  pinpoint_id=$(echo ${ID[1]//,} | tr -d \")

else 
  echo "file exists"
fi

#execute terraform in initialized terraform directory
(
  cd ~/Research/Cloud/Terraform/; 
  terraform apply -var-file=~/Research/Cloud/Terraform/terraform.tfvar; 
  terraform_output=$(terraform output); 
  #Parses output file into swift file for iOS App backend
  python3 ~/Research/Cloud/Scripts/terraform_out_to_app_config.py "$terraform_output";
)

sam package --template-file ~/Research/Cloud/sam-app/template.yaml --s3-bucket serverlesssambucket123454321 --output-template-file ~/Research/Cloud/sam-app/packaged.yaml

aws cloudformation deploy --template-file ~/Research/Cloud/sam-app/packaged.yaml --stack-name nfpbreastfeedingserverlessstack --capabilities CAPABILITY_IAM
