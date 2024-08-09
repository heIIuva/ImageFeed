//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by big stepper on 08/08/2024.
//

import Foundation


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
