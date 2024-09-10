//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by big stepper on 20/08/2024.
//

import Foundation


final class ProfileImageService {
    
    //MARK: - Singletone
    
    static let shared = ProfileImageService()
    private init() { }
    
    //MARK: - Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    //MARK: - Methods
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(username)", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("couldn't create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethods.get
        return request
    }
    
    func fetchProfileImageURL(token: String,
                              username: String,
                              _ completion: @escaping (Result<String, Error>) -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchProfileImageURL(token: token, username: username, completion)
            }
            return
        }
        
        guard task == nil else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            print("invalid profile image reqest")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let image):
                    let profileImageURL = image.profileImage.small
                    self.avatarURL = profileImageURL
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": profileImageURL])
                    print("profile image URL fetched successfully")
                case .failure(let error):
                    completion(.failure(error))
                    print("couldn't fetch profile image URL")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}

//MARK: - Logout

extension ProfileImageService {
    func cleanAvatar() {
        self.avatarURL = nil
    }
}
