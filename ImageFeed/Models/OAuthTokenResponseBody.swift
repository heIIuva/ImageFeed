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
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}
