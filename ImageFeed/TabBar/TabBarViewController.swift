//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by big stepper on 25/08/2024.
//

import UIKit


final class TabBarViewController: UITabBarController {
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        imagesListViewController.tabBarItem = UITabBarItem(title: "",
                                                           image: UIImage(named: "tabEditorialInactive"), selectedImage: nil)
        let imagesListPresenter = ImagesListPresenter(alertPresenter: AlertPresenter())
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tabProfileInactive"),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
