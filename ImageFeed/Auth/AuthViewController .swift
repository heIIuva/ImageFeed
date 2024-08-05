//
//  AuthViewController .swift
//  ImageFeed
//
//  Created by big stepper on 04/08/2024.
//

import UIKit


final class AuthViewController: UIViewController {
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
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "goBackButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "goBackButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypDark") // 4
    }
    
}
