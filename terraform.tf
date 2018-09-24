//Will need to add SMS role to allow cognito to verify via SMS in the future.

resource "aws_cognito_user_pool" "pool" {
  name = "NFP_Breastfeeding_Pool"
  username_attributes = ["email"]
  email_verification_subject = "Your verification code"
  email_verification_message = "Your verification code is {####}."
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers = true
    require_symbols = true
  }

  schema {
   attribute_data_type      = "String"
   developer_only_attribute = false
   mutable                  = false
   name                     = "email"
   required                 = true
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "phone_number"
    required                 = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "NFP_Breast_Feading_User_Pool_Client"
  generate_secret = true
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "NFP_Breastfeeding_Identity_Pool"
  allow_unauthenticated_identities = true
  cognito_identity_providers {
    provider_name = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool_client.client.user_pool_id}"
    client_id = "${aws_cognito_user_pool_client.client.id}"
  }
}

resource "aws_iam_role" "unauthenticated" {
  name = "NFP_Breastfeeding_Cognito_Unauthenticated"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "cognito-identity.amazonaws.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "unauthenticated"
          }
        }
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "unauthenticated_cognito_get_id" {
  name = "cognito_get_id"
  role = "${aws_iam_role.unauthenticated.id}"
  policy = "${aws_iam_role_policy.authenticated_cognito_get_id.policy}"
}

resource "aws_iam_role_policy" "unauthenticated_mobile_analytics" {
  name = "mobile_analytics"
  role = "${aws_iam_role.unauthenticated.id}"
  policy = "${aws_iam_role_policy.authenticated_mobile_analytics.policy}"
}

resource "aws_iam_role" "authenticated" {
  name = "NFP_Breastfeeding_Cognito_Authenticated"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated_cognito_sync" {
  name = "cognito_sync_policy"
  role = "${aws_iam_role.authenticated.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cognito-sync:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated_cognito_get_id" {
  name = "cognito_get_id"
  role = "${aws_iam_role.authenticated.id}"
  policy = "${data.aws_iam_policy_document.cognito_get_id.json}"
}

resource "aws_iam_role_policy" "authenticated_s3_put_object" {
  name = "s3_put_object_policy"
  role = "${aws_iam_role.authenticated.id}"
  policy = "${data.aws_iam_policy_document.s3_put_object.json}"
}

//Mobile analytics is now amazon pinpoint, use AWS CLI command:
//aws pinpoint create-app --create-application-request Name="Mobile App"
//This will create an app where the ID will be added to resources in the
//following iam role.  This can be done in the script that calls terraform apply

resource "aws_iam_role_policy" "authenticated_mobile_analytics" {
  name = "mobile_analytics_put_event"
  role = "${aws_iam_role.authenticated.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "mobiletargeting:UpdateEndpoint"
      ],
      "Resource": [
        "arn:aws:mobiletargeting:*:551307643672:apps/69lvutlebj6jpn19pmiv9rep7a"
      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "cognito_get_id" {
  statement {
    actions = [
      "cognito-identity:GetId"
    ]
    resources = [
      "arn:aws:cognito-identity:*:*:identityPool/${aws_cognito_identity_pool.main.id}",
    ]
  }
}

data "aws_iam_policy_document" "s3_put_object" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.survey.arn}"
    ]
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = "${aws_cognito_identity_pool.main.id}"

  role_mapping {
    identity_provider         = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool_client.client.user_pool_id}:${aws_cognito_user_pool_client.client.id}"
    ambiguous_role_resolution = "AuthenticatedRole"
    type                      = "Rules"

    mapping_rule {
      claim      = "isAdmin"
      match_type = "Equals"
      role_arn   = "${aws_iam_role.authenticated.arn}"
      value      = "paid"
    }
  }

  roles {
    "authenticated" = "${aws_iam_role.authenticated.arn}"
  }
}

resource "aws_s3_bucket" "survey" {
  bucket = "nfpbreastfeedingsurveybucket-${random_id.idkey.hex}"
  acl    = "private"
}

resource "random_id" "idkey" {
   byte_length = 4
}

output "idkey" {
   value = "${random_id.idkey.hex}"
}
