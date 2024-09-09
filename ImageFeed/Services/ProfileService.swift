//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by big stepper on 18/08/2024.
//

import Foundation


final class ProfileService {
    
    //MARK: - Singletone
    
    static let shared = ProfileService()
    private init() { }
    
    //MARK: - Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    //MARK: - Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("couldn't create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchProfile(token, completion: completion)
            }
            return
        }
        
        guard task == nil else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            print("invalid profile data request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let data):
                        let profile = Profile(profileResult: data)
                        self.profile = profile
                        completion(.success(profile))
                    print("user data saved successfully")
                case .failure(let error):
                    completion(.failure(error))
                    print("couldn't fetch user data")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
