//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by big stepper on 09/09/2024.
//

import Foundation
import WebKit


final class ProfileLogoutService {
    
    //MARK: - Singletone
    
    static let shared = ProfileLogoutService()
    private init(){}
    
    //MARK: - Properties
    
    private let storage = OAuth2Storage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    //MARK: - Methods
    
    func logout() {
        storage.cleanToken()
        profileService.cleanProfile()
        profileImageService.cleanAvatar()
        imagesListService.cleanPhotos()
        cleanCookies()
        showSplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
                                                        for: [record],
                                                        completionHandler: {})
            }
        }
    }
    
    private func showSplashViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            assertionFailure("Invalid Configuration")
            return }
        
        window.rootViewController = SplashViewController()
    }
}
