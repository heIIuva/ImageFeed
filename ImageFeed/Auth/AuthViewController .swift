//
//  AuthViewController .swift
//  ImageFeed
//
//  Created by big stepper on 04/08/2024.
//

import UIKit
import ProgressHUD


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}


final class AuthViewController: UIViewController {
    
    //MARK: - Singletone
    
    private let oAuth2Service = OAuth2Service.shared
    private let storage = OAuth2Storage.shared
    
    //MARK: - Properties
    
    private let WebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    private var alertPresenter: AlertPresenterProtocol?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 16
            loginButton.layer.masksToBounds = true
            loginButton.titleLabel?.font = .SFPro.withSize(17).withWeight(.bold)
        }
    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
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

//MARK: - Extensions

extension AuthViewController: WebViewViewControllerDelegate {
    
    //MARK: - Methods
    
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        navigationController?.popToRootViewController(animated: true)
        UIBlockingProgressHUD.show()
        DispatchQueue.global().async {
            self.oAuth2Service.fetchOAuthToken(with: code) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { preconditionFailure("couldn't load AuthViewController") }
                switch result {
                case .success(let token):
                    storage.token = token
                    print("token fetched successfully: \(token)")
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    let completion = { [weak self] in
                        guard let self else { return }
                        self.navigationController?.popViewController(animated: true)
                    }
                    let viewModel = AlertModel(title: "Что-то пошло не так(",
                                               message: "Не удалось войти в систему",
                                               button: "Ok",
                                               completion: completion)
                    alertPresenter?.showAlert(result: viewModel)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
    }
}
