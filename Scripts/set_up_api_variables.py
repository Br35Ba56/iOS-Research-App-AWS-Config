#!/usr/local/bin/python3

import os
import sys
import string
import json

admin_auth_json = sys.argv[1]
user_pool = sys.argv[2]
test_user = sys.argv[3]
output_file = os.path.expanduser("~/Research/Cloud/Scripts/variables.json")

print(admin_auth_json)

parsed_json = json.loads(admin_auth_json)

print(user_pool)
print(test_user)
auth_result=parsed_json['AuthenticationResult']
token = auth_result['IdToken']
output="[{\"token\": \"" + token + "\", \"user_pool\": \"" + user_pool + "\", \"test_user\":\""+test_user+"\"}]"
file = open(output_file, 'w')
file.write(output)
file.close