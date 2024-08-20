//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation


final class OAuth2ServiceStorage {
    
    //MARK: - Singletone
    
    static let shared = OAuth2ServiceStorage()
    private init() { }
    
    //MARK: - Properties
    
    private let storage = UserDefaults.standard
    enum StorageKeys: String {
        case token
    }
    
    var token: String? {
        get {
            storage.string(forKey: StorageKeys.token.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: StorageKeys.token.rawValue)
        }
    }
}
