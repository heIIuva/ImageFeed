//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by big stepper on 29/07/2024.
//

import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileImageService = ProfileImageService.shared
    private let profileData = ProfileService.shared.profile
    private let storage = OAuth2Storage.shared
    
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var bioLabel: UILabel?
    private var logoutButton: UIButton?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileImageView()
        setUpLogoutbutton()
        
        guard let profileData else { return }
        updateProfileInformation(profile: profileData)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        self.updateAvatar()
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL),
              let profileImageView
        else { return }
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "avatarPlaceholder"))
    }
    
    private func setUpProfileImageView() {
        let profileImage = UIImage(named: "profilePicture")
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.backgroundColor = .ypDark
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
        ])
        self.profileImageView = profileImageView
    }
    
    private func setUpLogoutbutton() {
        let logoutButtonImage = UIImage(named: "exitButton")
        
        guard let logoutButtonImage else { return }
        
        let logoutButton = UIButton.systemButton(with: logoutButtonImage, target: self, action: #selector(self.didTapLogoutButton))
        logoutButton.backgroundColor = .ypDark
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        guard let profileImageView else { return }
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        self.logoutButton = logoutButton
    }
    
    private func setUpProfileLabels() {
        let nameLabel = UILabel()
        let loginLabel = UILabel()
        let bioLabel = UILabel()
        let labels = [nameLabel, loginLabel, bioLabel]
        
        nameLabel.font = .SFPro.withWeight(.bold)
        loginLabel.font = .SFPro.withSize(17).withWeight(.medium)
        bioLabel.font = .SFPro.withSize(17).withWeight(.medium)
        
        nameLabel.textColor = .ypWhite
        loginLabel.textColor = .ypGray
        bioLabel.textColor = .ypWhite
        
        for label in labels {
            label.backgroundColor = .ypDark
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
        }
        
        guard let profileImageView else { return }
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ])
        self.nameLabel = nameLabel
        self.loginLabel = loginLabel
        self.bioLabel = bioLabel
    }
    
    private func updateProfileInformation(profile: Profile) {
        setUpProfileLabels()
        
        nameLabel?.text = profile.name
        loginLabel?.text = profile.loginName
        bioLabel?.text = profile.bio
        
        print("user data set up successfully")
    }
    
    @objc
    private func didTapLogoutButton() {
        
    }
}
