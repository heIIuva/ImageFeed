//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by big stepper on 07/08/2024.
//

import Foundation


final class OAuth2Service {
    
    //MARK: - Singletone
    
    static let shared = OAuth2Service()
    private init() {}
    
    //MARK: - Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post
        return request
    }
    
    func fetchOAuthToken(
        with code: String,
        completion: @escaping(_ result: Result<String, Error>) -> Void
    ) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchOAuthToken(with: code, completion: completion)
            }
            return
        }
        guard lastCode != code else {                               // 1
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
        completion(.failure(AuthServiceError.invalidRequest))
        return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                guard let self else { return }
                switch result {
                case .success(let responseBody):
                    let token = responseBody.accessToken
                    completion(.success(token))
                    print("OAuth token decoded successfully")
                case .failure(let error):
                    completion(.failure(error))
                    print("couldn't decode OAuth token")
                }
                self.task = nil
                self.lastCode = nil
            }
        self.task = task
        task.resume()
    }
}


enum DecoderError: Error, LocalizedError {
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Decoding error - \(error)"
        }
    }
}
