resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "identity pool"
  allow_unauthenticated_identities = true
  //This needs to get changed to cognito user pool app client id
  supported_login_providers {
    "graph.facebook.com" = "7346241598935555"
  }
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
