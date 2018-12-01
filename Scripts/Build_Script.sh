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
  #check if .terraform exists, if not then initialize the directory
  if [ ! -e "$terraform_dir".terraform ]; then 
    terraform init 
  fi 
  
  terraform apply -var-file="$terraform_dir"terraform.tfvar; 
  terraform_output=$(terraform output); 
  #Parses output file into swift file for iOS App backend
  python3 $terraform_out_to_app_config "$terraform_output";
)

#Build lambda java project

#(
  #cd ~/Research/Cloud/sam-app/
  #mvn install
#)

sam package --template-file $sam_template --s3-bucket serverlesssambucket123454321 --output-template-file $sam_package_cf

aws cloudformation deploy --template-file $sam_package_cf --stack-name nfpbreastfeedingserverlessstack --capabilities CAPABILITY_IAM



echo "Do you need to install the API Gateway SDK? Enter 1 for yes, 2 for no."
select yn in "Yes" "No"; do
    case $yn in
      Yes ) 
        echo "Fetching SDK";
        #Variables for get-sdk
        rest_api_id=$(aws cloudformation list-exports --query "Exports[?Name==\`NFPBreastFeedingAPI\`].Value" --no-paginate --output text);
        stage_name=NFPBreastFeedingAPI;

        #Directorys for SDK
        sdk_target_dir=~/Research/iOS-Research-App/Breast\ Feeding\ NFP/APIGatewaySDK/;

        #get the SDK from apigateway
        aws apigateway get-sdk --rest-api-id $rest_api_id --stage-name $stage_name --sdk-type swift --parameters classPrefix='MU' NFPApiSDK.zip;
        unzip NFPApiSDK.zip;
        cp -R ./aws-apigateway-ios-swift/generated-src/ "$sdk_target_dir";
        rm -rf aws-apigateway-ios-swift;
        rm NFPApiSDK.zip;
        break;;
      No ) break;;
    esac
done

#install cocoa pods
(
  cd ~/Research/iOS-Research-App/
  pod install
)