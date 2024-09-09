//
//  UIImageView+Extensions.swift
//  ImageFeed
//
//  Created by big stepper on 25/08/2024.
//

import UIKit


extension UIImageView {
    func rounded() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
