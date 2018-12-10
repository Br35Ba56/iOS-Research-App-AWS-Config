#!/bin/bash

user_pool=$(terraform output cognito_user_pool_id)
user_name="test_user@fake.com"
user_name_1="test_user_2@fake.com"
echo $user_pool
echo $user_name

#create user to call requests
aws cognito-idp admin-create-user \
  --user-pool-id $user_pool \
  --username $user_name \
  --temporary-password Passw0rd! \
  --user-attributes Name=email,Value=$user_name,Name=phone_number,Value=+12323334444



session=$(python get_session.py "$(aws cognito-idp admin-initiate-auth \
  --user-pool-id $user_pool \
  --client-id 7no0360po46obi1d0d9d5r27l5 \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=$user_name,PASSWORD=Passw0rd!)" )

echo $session

python set_up_api_variables.py "$(aws cognito-idp admin-respond-to-auth-challenge \
  --user-pool-id $user_pool \
  --client-id 7no0360po46obi1d0d9d5r27l5 \
  --challenge-name NEW_PASSWORD_REQUIRED \
  --challenge-response USERNAME=$user_name,NEW_PASSWORD=Passw0rd# \
  --session $session )" $user_pool

newman run Tests_NFP_Breast_Feeding_API.postman_collection.json -d variables.json

#aws cognito-idp admin-delete-user \
  #--user-pool-id $user_pool \
  #--username $user_name \

