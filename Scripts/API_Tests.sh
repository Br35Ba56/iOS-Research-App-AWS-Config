#!/bin/bash

user_pool=$(cd ~/Research/Cloud/Terraform/ && terraform output cognito_user_pool_id)
user_name="test_user@fake.com"
user_name_1="test_user_2@fake.com"
echo $user_pool

echo "creating test app client"
test_client_id=$(python3 get_client_Id.py "$(aws cognito-idp create-user-pool-client \
  --user-pool-id $user_pool \
  --client-name test-app-client \
  --no-generate-secret \
  --refresh-token-validity 1 \
  --explicit-auth-flow "ADMIN_NO_SRP_AUTH")")

user_name_1="test_user_2@fake.com"


echo "creating test user 1"
#create user 1 to call requests
aws cognito-idp admin-create-user \
  --user-pool-id $user_pool \
  --username $user_name \
  --temporary-password Passw0rd! \
  --user-attributes Name=email,Value=$user_name,Name=phone_number,Value=+12323334444

#create user 2 to disable in tests
aws cognito-idp admin-create-user \
  --user-pool-id $user_pool \
  --username $user_name_1 \
  --temporary-password Passw0rd! \
  --user-attributes Name=email,Value=$user_name_1,Name=phone_number,Value=+12323434444

#authenticate user 2
  aws cognito-idp admin-initiate-auth \
  --user-pool-id $user_pool \
  --client-id $test_client_id \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=$user_name_1,PASSWORD=Passw0rd!

echo "test user initiate auth"
session=$(python get_session.py "$(aws cognito-idp admin-initiate-auth \
  --user-pool-id $user_pool \
  --client-id $test_client_id \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=$user_name,PASSWORD=Passw0rd!)" )

echo $session

echo "test user get access tokens and add user 2 to variables.json"
python set_up_api_variables.py "$(aws cognito-idp admin-respond-to-auth-challenge \
  --user-pool-id $user_pool \
  --client-id $test_client_id \
  --challenge-name NEW_PASSWORD_REQUIRED \
  --challenge-response USERNAME=$user_name,NEW_PASSWORD=Passw0rd# \
  --session $session )" $user_pool $user_name_1

newman run Test_NFP_Breastfeeding_API.postman_collection.json -d variables.json

echo "delete test users"
aws cognito-idp admin-delete-user \
  --user-pool-id $user_pool \
  --username $user_name 

aws cognito-idp admin-delete-user \
  --user-pool-id $user_pool \
  --username $user_name_1

echo "delete app client"
aws cognito-idp delete-user-pool-client \
--user-pool-id $user_pool \
--client-id $test_client_id 

