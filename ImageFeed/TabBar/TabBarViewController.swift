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
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
