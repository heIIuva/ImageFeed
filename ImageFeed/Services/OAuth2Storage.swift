//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation
import SwiftKeychainWrapper


final class OAuth2Storage {
    
    //MARK: - Singletone
    
    static let shared = OAuth2Storage()
    private init() {}
    
    //MARK: - Properties

    private let storage = KeychainWrapper.standard
    enum StorageKeys: String {
        case token
    }

    var token: String? {
        get {
            storage.string(forKey: StorageKeys.token.rawValue)
        }
        set {
            guard let newValue else {
                return
            }
            storage.set(newValue, forKey: StorageKeys.token.rawValue)
        }
    }
}

//MARK: - Logout

extension OAuth2Storage {
    func cleanToken() {
        storage.removeObject(forKey: StorageKeys.token.rawValue)
    }
}
    
