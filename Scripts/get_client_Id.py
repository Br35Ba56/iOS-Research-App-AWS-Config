#!/usr/local/bin/python3

import os
import sys
import string
import json

user_pool_client = sys.argv[1]

user_pool_client_json = json.loads(user_pool_client)
client_id =  user_pool_client_json['UserPoolClient']['ClientId']

sys.stdout.write(client_id)
sys.stdout.flush()
sys.stdout.close()