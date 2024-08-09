//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation


struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: UInt
}
