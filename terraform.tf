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
  identity_pool_name               = "identity pool"
  allow_unauthenticated_identities = true
  //This needs to get changed to cognito user pool app client id
cognito_identity_providers {
  provider_name = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool_client.client.user_pool_id}"
  client_id = "${aws_cognito_user_pool_client.client.id}"
}

  /*supported_login_providers {
    "graph.facebook.com" = "7346241598935555"
  }*/
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

resource "aws_iam_role_policy" "authenticated_s3_put_object" {
  name = "s3_put_object_policy"
  role = "${aws_iam_role.authenticated.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::nfpbreastfeedingrese-deployments-mobilehub-128695951"
      ]
    }
  ]
}
EOF
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

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = "${aws_cognito_identity_pool.main.id}"

  role_mapping {
    identity_provider         = "graph.facebook.com"
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
