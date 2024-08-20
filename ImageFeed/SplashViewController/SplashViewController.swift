//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


final class SplashViewController: UIViewController {
    
    //MARK: - Singletone
    
    private let profileService = ProfileService.shared
    private let oAuth2Service = OAuth2Service.shared
    private let storage = OAuth2ServiceStorage.shared
    
    //MARK: - Propeties
    
    private let segueIdentifier = "ShowAuthScreen"
    
    //MARK: - Methods
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        UserDefaults.standard.removeObject(forKey: OAuth2ServiceStorage.StorageKeys.token.rawValue)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        chooseScreen()
    }
    
    private func showTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first 
        else {
            assertionFailure("Invalid Configuration")
            return }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func chooseScreen() {
        if let token = storage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
    }
}

//MARK: - Extensions

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(segueIdentifier)")
                return }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

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
            case .success:
               self.showTabBarController()

            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
}
