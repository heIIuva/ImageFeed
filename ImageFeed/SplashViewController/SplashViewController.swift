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
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2ServiceStorage = OAuth2ServiceStorage.shared
    
    //MARK: - Propeties
    
    private let segueIdentifier = "ShowAuthScreen"
    
    //MARK: - Methods
    
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
        if oAuth2ServiceStorage.token != nil {
            showTabBarController()
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
    }
}
