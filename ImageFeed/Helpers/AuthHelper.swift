//
//  Untitled.swift
//  ImageFeed
//
//  Created by big stepper on 23/09/2024.
//

import Foundation


protocol AuthHelperProtocol {
    func AuthRequest() -> URLRequest?
    func code(from url: URL) -> String?
}


final class AuthHelper: AuthHelperProtocol {
    
    //MARK: - Properties
    
    let configuration: AuthConfiguration
    
    //MARK: - Methods
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authorizeURLString) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: Constants.code),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    func AuthRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants.path,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == Constants.code} )
        {
            return codeItem.value
        } else {
            print("couldn't get code")
            return nil
        }
    }
}
