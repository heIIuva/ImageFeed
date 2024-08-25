//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import UIKit
import SwiftKeychainWrapper


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


final class SplashViewController: UIViewController {
    
    //MARK: - Singletone
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let oAuth2Service = OAuth2Service.shared
    private let storage = OAuth2Storage.shared
    
    //MARK: - Propeties
    
    private var logo: UIImageView?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //KeychainWrapper.standard.removeAllKeys()
        addLogo()
        view.backgroundColor = .ypDark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        chooseScreen()
    }
    
    private func addLogo() {
        let logo = UIImage(named: "Vector")
        let logoView = UIImageView(image: logo)
        logoView.backgroundColor = .ypDark
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.logo = logoView
    }
    
    private func showAuthController() {
        let authViewController = UIStoryboard(name: "Main",
                                              bundle: .main
        ).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        guard let authViewController else { return }
        authViewController.delegate = self
        
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func showTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first 
        else {
            assertionFailure("Invalid Configuration")
            return }

        window.rootViewController = UIStoryboard(name: "Main",
                                                 bundle: .main
        ).instantiateViewController(withIdentifier: "TabBarViewController")
    }
    
    private func chooseScreen() {
        if let token = storage.token {
            fetchProfile(token)
        } else {
            showAuthController()
        }
    }
}

//MARK: - Extensions

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)        
        guard let token = storage.token else { return }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self else { return }

            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(token: token, username: profile.username) { _ in }
                self.showTabBarController()

            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
}
