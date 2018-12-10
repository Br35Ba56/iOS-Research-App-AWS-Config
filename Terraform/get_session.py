#!/usr/local/bin/python3

import os
import sys
import string
import json

admin_auth_json = sys.argv[1]

parsed_json = json.loads(admin_auth_json)

sys.stdout.write(parsed_json['Session'])
sys.stdout.flush()
sys.stdout.close()