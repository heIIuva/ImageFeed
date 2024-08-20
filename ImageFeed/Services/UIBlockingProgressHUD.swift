//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by big stepper on 18/08/2024.
//

import UIKit
import ProgressHUD


final class UIBlockingProgressHUD {

    //MARK: - Properties
    
    private static var window: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
    
    //MARK: - Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
