//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by big stepper on 29/07/2024.
//

import UIKit


final class ProfileViewController: UIViewController {
    
    private var profileImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileImageView()
        setUpLogoutbutton()
        setUpProfileLabels()
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
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 327),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setUpProfileLabels() {
        let nameLabel = UILabel()
        let tagLabel = UILabel()
        let bioLabel = UILabel()
        let labels = [nameLabel, tagLabel, bioLabel]
        
        nameLabel.text = "Екатерина Новикова"
        tagLabel.text = "@ekaterina_nov"
        bioLabel.text = "Hello, world!"
        
        nameLabel.font = nameLabel.font.withSize(23)
        tagLabel.font = tagLabel.font.withSize(17)
        bioLabel.font = bioLabel.font.withSize(17)
        
        for label in labels {
            label.textColor = .white
            label.backgroundColor = .ypDark
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        
    }
}
