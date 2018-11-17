output "s3_bucket_name" {
  value = "${aws_s3_bucket.survey.id}"
}

output "cognito_user_pool_id" {
  value = "${aws_cognito_user_pool.pool.id}"
}

output "aws_cognito_identity_pool_id" {
  value = "${aws_cognito_identity_pool.main.id}"
}

output "aws_cognito_user_pool_client_secret" {
  value = "${aws_cognito_user_pool_client.client.client_secret}"
}

output "aws_cognito_user_pool_client_id" {
  value = "${aws_cognito_user_pool_client.client.id}"
}

output "aws_pinpoint_app_id" {
  value = "${var.pinpointID}"
}
