//
//  UIFont+Extensions.swift
//  ImageFeed
//
//  Created by big stepper on 02/08/2024.
//

import UIKit


extension UIFont {
    static var SFPro: UIFont { UIFont(name: "SF-Pro", size: 23) ?? UIFont.systemFont(ofSize: 23)}
}


extension UIFont {
  func withWeight(_ weight: UIFont.Weight) -> UIFont {
    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
      UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: newDescriptor, size: pointSize)
  }
}
