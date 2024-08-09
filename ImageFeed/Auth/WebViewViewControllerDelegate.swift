//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
