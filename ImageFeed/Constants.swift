//
//  constants.swift
//  ImageFeed
//
//  Created by big stepper on 03/08/2024.
//

import Foundation


enum Constants {
    static let accessKey = "BYBf3gtmb8aLVWKfcdPRgDZ73vk028nIplf76cPe_IA"
    static let secretKey = "qi5e5CoUCbZVkaTYKSXqL3w6fOZCp6QkzOxfx65baZw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL? = .init(string: "https://api.unsplash.com/")
    static let token = "token"
    static let grantType: String = "authorization_code"
    static let baseURLString: String =  "https://unsplash.com/oauth/token"
    static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
}

