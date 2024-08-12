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
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(
        with code: String,
        completion: @escaping(_ result: Result<String, Error>) -> Void
    ) {
        guard let request = makeOAuthTokenRequest(code: code) else {
        print("invalid fetch token request")
        return }
        
        let dataTask = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("couldn't decode OAuth token")
                    completion(.failure(DecoderError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        dataTask.resume()
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
