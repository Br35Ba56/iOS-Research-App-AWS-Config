//
//  DoNotCommit.swift
//  Breast Feeding NFP
//
//  Created by Anthony Schneider on 2/24/18.
//  Copyright © 2018 Anthony Schneider. All rights reserved.

import Foundation
import AWSCore
import AWSCognitoIdentityProvider

struct AWSConstants {
  static let poolID = cognito_user_pool_id
  static let appClientID = aws_cognito_user_pool_client_id
  static let appClientSecret = aws_cognito_user_pool_client_secret
  static let identityPoolID = aws_cognito_identity_pool_id
  static let region = AWSRegionType.USEast1
  static let bucket = s3_bucket_name
  static let mobileAnalyticsAppID = aws_pinpoint_app_id
}
