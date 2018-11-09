#!/usr/local/bin/python3

import sys
import string

terraform_variables = sys.argv[1]

output_values = dict(item.split("=") for item in terraform_variables.split("\n"))

data = ""

with open('./NFPAppConfig/AWS_Config.swift', 'r') as myfile:
  data = myfile.read()

for key in output_values.keys():
    data = data.replace(key.strip(), output_values[key])

file = open('./NFPAppConfig/DoNotCommit.swift', 'w')
file.write(data)
file.close()
