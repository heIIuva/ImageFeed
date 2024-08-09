//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import UIKit


final class SplashViewController: UIViewController {
    private let segueIdentifier = "ShowAuthScreen"
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2Storage = OAuth2ServiceStorage.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oAuth2Storage.token != nil {
            showTabBarController()
        } else {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    
    private func showTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Invalid Configuration")
            return }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
}


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
        showTabBarController()
        }
    
    /*
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showTabBarController()
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
     */
}
