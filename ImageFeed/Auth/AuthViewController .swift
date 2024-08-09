//
//  AuthViewController .swift
//  ImageFeed
//
//  Created by big stepper on 04/08/2024.
//

import UIKit


final class AuthViewController: UIViewController {
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2Storage = OAuth2ServiceStorage.shared
    private let WebViewSegueIdentifier = "WebViewSegue"
    
    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 16
            loginButton.layer.masksToBounds = true
            loginButton.titleLabel?.font = .SFPro.withSize(17).withWeight(.bold)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == WebViewSegueIdentifier,
            let webViewViewController = segue.destination as? WebViewViewController
        {
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "goBackButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "goBackButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypDark") // 4
    }
    
}


extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self, let delegate = self.delegate else { preconditionFailure("couldn't load AuthViewController") }
            switch result {
            case .success(let token):
                self.oAuth2Storage.token = token
                delegate.didAuthenticate(self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
