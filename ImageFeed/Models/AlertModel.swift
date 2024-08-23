//
//  AlertModel.swift
//  ImageFeed
//
//  Created by big stepper on 22/08/2024.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let button: String
    let completion: (() -> Void)
}
