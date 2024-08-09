//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation


final class OAuth2ServiceStorage {
    static let shared = OAuth2ServiceStorage()
    private init() { }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.token)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.token)
        }
    }
    
    
}
