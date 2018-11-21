#!/bin/bash


terraform_dir=~/Research/Cloud/Terraform/
terraform_out_to_app_config=~/Research/Cloud/Scripts/terraform_out_to_app_config.py
sam_template=~/Research/Cloud/sam-app/template.yaml
sam_package_cf=~/Research/Cloud/sam-app/packaged.yaml

#Check if terrafrom.tfvar exists and has valid pinpoint app
if [ ! -e "$terraform_dir"terraform.tfvar ]; then
  touch ~/Research/Cloud/Terraform/terraform.tfvar
  echo "pinpointID=id" > "$terraform_dir"terraform.tfvar
  
  #Create pinpoint app
  pinpoint_create_app_result=$(aws pinpoint create-app --create-application-request Name="NFP_Breastfeeding_App" | grep Id );

  #echo result of 
  echo "$pinpoint_create_app_result"
  IFS=':' read -ra ID <<< "$pinpoint_create_app_result";
  echo "${ID[1]//,}";

  #Replaces id in var.tf
  sed -i '' -e "s/id/${ID[1]//,}/g" "$terraform_dir"terraform.tfvar

  #Remove " and , from string
  pinpoint_id=$(echo ${ID[1]//,} | tr -d \")

else 
  echo "aws pinpoint app id already exists"
fi

#execute terraform in initialized terraform directory
(
  cd $terraform_dir; 
  terraform apply -var-file="$terraform_dir"terraform.tfvar; 
  terraform_output=$(terraform output); 
  #Parses output file into swift file for iOS App backend
  python3 $terraform_out_to_app_config "$terraform_output";
)

sam package --template-file $sam_template --s3-bucket serverlesssambucket123454321 --output-template-file $sam_package_cf

aws cloudformation deploy --template-file $sam_package_cf --stack-name nfpbreastfeedingserverlessstack --capabilities CAPABILITY_IAM

aws pinpoint delete-app --application-id $pinpoint_id
rm ~/Research/Cloud/Terraform/terraform.tfvar
