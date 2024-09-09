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
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tabProfileActive"),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
