#/bin/bash

#Remove var.tf for clean configuration should use environment variable for
#checking for production or testing deployment
rm terraform.tfvar
touch terraform.tfvar;
echo "pinpointID=id" > terraform.tfvar

#Create pinpoint app
pinpointID=$(aws pinpoint create-app --create-application-request Name="NFP_Breastfeeding_App" | grep Id );
IFS=':' read -ra ID <<< "$pinpointID";
echo "${ID[1]//,}";

#Replaces id in var.tf
sed -i '' -e "s/id/${ID[1]//,}/g" terraform.tfvar

#Remove " and , from string
PINPOINTID=$(echo ${ID[1]//,} | tr -d \")

terraform apply -var-file=terraform.tfvar

terraform_output=$(terraform output);

python3 terraform_out_to_app_config.py "$terraform_output"

cat ./NFPAppConfig/DoNotCommit.swift
aws pinpoint delete-app --application-id $PINPOINTID
