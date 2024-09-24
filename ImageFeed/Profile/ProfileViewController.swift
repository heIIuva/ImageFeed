//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by big stepper on 29/07/2024.
//

import UIKit
import Kingfisher


protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileInformation(profile: Profile)
    func updateAvatar()
    func dismiss()
}


final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    //MARK: - Properties
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfilePresenterProtocol?
    
    private let profileImageService = ProfileImageService.shared
    private let profileData = ProfileService.shared.profile
    
    lazy var profileImageView: UIImageView? = {
        let profileImage = UIImage(named: "profilePicture")
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.backgroundColor = .ypDark
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    private lazy var nameLabel: UILabel? = {
        let nameLabel = UILabel()
        nameLabel.font = .SFPro.withWeight(.bold)
        nameLabel.textColor = .ypWhite
        nameLabel.backgroundColor = .ypDark
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var loginLabel: UILabel? = {
        let loginLabel = UILabel()
        loginLabel.font = .SFPro.withSize(17).withWeight(.medium)
        loginLabel.textColor = .ypGray
        loginLabel.backgroundColor = .ypDark
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private lazy var bioLabel: UILabel? = {
        let bioLabel = UILabel()
        bioLabel.font = .SFPro.withSize(17).withWeight(.medium)
        bioLabel.textColor = .ypWhite
        bioLabel.backgroundColor = .ypDark
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        return bioLabel
    }()
    
    private lazy var logoutButton: UIButton? = {
        guard let logoutButtonImage = UIImage(named: "exitButton") else { return UIButton() }
        
        let logoutButton = UIButton.systemButton(with: logoutButtonImage, target: self, action: #selector(didTapLogoutButton))
        logoutButton.backgroundColor = .ypDark
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileImageView()
        setUpLogoutbutton()
        
        guard let profileData else { return }
        updateProfileInformation(profile: profileData)
        
        view.backgroundColor = .ypDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarItem = UITabBarItem(title: "",
                                       image: UIImage(named: "tabProfileActive"),
                                       selectedImage: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarItem = UITabBarItem(title: "",
                                       image: UIImage(named: "tabProfileInactive"),
                                       selectedImage: nil)
    }
    
    //MARK: - UI Methods
    
    private func setUpProfileImageView() {
        guard let profileImageView else { return }
        
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func setUpLogoutbutton() {
        guard let logoutButton else { return }

        view.addSubview(logoutButton)
        guard let profileImageView else { return }
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setUpProfileLabels() {
        guard let nameLabel, let loginLabel, let bioLabel, let profileImageView else { return }
        
        let labels = [nameLabel, loginLabel, bioLabel]
                
        labels.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func updateProfileInformation(profile: Profile) {
        setUpProfileLabels()
        updateAvatar()
        
        nameLabel?.text = profile.name
        loginLabel?.text = profile.loginName
        bioLabel?.text = profile.bio
        
        print("user data set up successfully")
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL),
              let profileImageView
        else { return }
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "avatarPlaceholder"),
                                     options: [.processor(processor)])
    }
    
    @objc private func didTapLogoutButton() {
        presenter?.didTapLogoutButton()
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
}

