//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by big stepper on 05/08/2024.
//

import UIKit
import WebKit


final class WebViewViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadAuthView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                        options: [],
                                                        changeHandler: { [weak self] _, _ in
                                                        guard let self else { return }
                                                        self.updateProgress()})
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.authorizeURLString)
        else {
            print("an error occurred with authorization url")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url
        else {
            print("an error occurred with query items")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    
    //MARK: - Methods
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == Constants.code } )
        {
            return codeItem.value
        } else {
            print("couldn't get code")
            return nil
        }
    }
}

