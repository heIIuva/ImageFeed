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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
    static let code = "code"
    static let path = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authorizeURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: URL,
        authorizeURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authorizeURLString = authorizeURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            authorizeURLString: Constants.authorizeURLString
        )
    }
}

enum AuthServiceError: Error {
    case invalidRequest
}

enum HTTPMethods {
    static let get = "GET"
    static let post = "POST"
    static let delete = "DELETE"
}

