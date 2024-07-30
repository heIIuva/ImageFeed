//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by big stepper on 29/07/2024.
//

import UIKit


final class ProfileViewController: UIViewController {
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var tagLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!

    @IBOutlet private var exitButton: UIButton!

    @IBAction private func didTapLogoutButton() {
    }
}
