#!/usr/local/bin/python3

import os
import sys
import string


terraform_variables = sys.argv[1]
config_file = os.path.expanduser("~/Research/Cloud/NFPAppConfig/AWS_Config.swift")
output_file = os.path.expanduser("~/Research/iOS-Research-App/Breast Feeding NFP/DoNotCommit.swift")

output_values = dict(item.split("=") for item in terraform_variables.split("\n"))

data = ""

with open(config_file, 'r') as myfile:
  data = myfile.read()

for key in output_values.keys():
    value = output_values[key].strip()
    data = data.replace(key.strip(), "\"" + value + "\"")

#Write output to iOS project
file = open(output_file, 'w')
file.write(data)
file.close()
