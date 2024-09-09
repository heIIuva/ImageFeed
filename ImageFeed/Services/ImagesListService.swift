//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by big stepper on 02/09/2024.
//

import Foundation


final class ImagesListService {
    
    //MARK: - Singletone
    
    static let shared = ImagesListService()
    private init() { }
    
    //MARK: - Propeties
    
    private let storage = OAuth2Storage.shared
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - Methods
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard let url = URL(string: "/photos?page=\(page)", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("couldn't create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethods.get
        return request
    }
    
    private func makeLikesRequest(token: String, photoId: String, httpMethod: String) -> URLRequest? {
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("couldn't create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        return request
    }
    
    private func nextPageNumber() -> Int {
        guard let lastLoadedPage else { return 1 }
        return lastLoadedPage + 1
    }
    
    private func convertFromPhotoResult(result photoResult: PhotoResult) -> Photo {
            let thumbWidth = 200.0
            let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
            let thumbHeight = thumbWidth / aspectRatio
            return Photo(
                id: photoResult.id,
                size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
                createdAt: dateFormatter.date(from: photoResult.createdAt ?? ""),
                welcomeDescription: photoResult.description,
                thumbImageURL: photoResult.urls.small,
                largeImageURL: photoResult.urls.full,
                isLiked: photoResult.likedByUser,
                thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
            )
        }
    
    
    func fetchPhotosNextPage(token: String) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchPhotosNextPage(token: token)
            }
            return
        }
        
        let nextPage = nextPageNumber()
        
        guard task == nil else {
            print(AuthServiceError.invalidRequest)
            return
        }
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            print(AuthServiceError.invalidRequest)
            print("invalid photos request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                guard let self else { return }
                switch result {
                case .success(let photoResult):
                    DispatchQueue.main.async {
                        var photos: [Photo] = []
                        photoResult.forEach {
                            photo in photos.append(self.convertFromPhotoResult(result: photo)) }
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                        self.photos += photos
                        self.lastLoadedPage = nextPage
                        print("photos fetched successfully")
                    }
                case .failure(let error):
                    print(error)
                    print("couldn't fetch photos")
                }
                self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    func changeLike(token: String, photoId: String, isLiked: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.changeLike(token: token, photoId: photoId, isLiked: isLiked, completion)
            }
            return
        }
        
        let httpMethod = isLiked ? HTTPMethods.post : HTTPMethods.delete
        
        guard task == nil else {
            print(AuthServiceError.invalidRequest)
            print("task is not nil")
            return
        }
        
        guard let request = makeLikesRequest(token: token, photoId: photoId, httpMethod: httpMethod) else {
            print(AuthServiceError.invalidRequest)
            print("invalid likes request")
            return
        }
        
        let task =  urlSession.objectTask(for: request) { [weak self] (result: Result<Like, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let likeData):
                        let likedByUser = likeData.photo.likedByUser
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(id: photo.id,
                                                 size: photo.size,
                                                 createdAt: photo.createdAt,
                                                 welcomeDescription: photo.welcomeDescription,
                                                 thumbImageURL: photo.thumbImageURL,
                                                 largeImageURL: photo.largeImageURL,
                                                 isLiked: likedByUser,
                                                 thumbSize: photo.thumbSize)
                            self.photos[index] = newPhoto
                            print("isLiked property updated successfully")
                        } else {
                            print("could't update isLiked property")
                        }
                        completion(.success(likedByUser))
                        print("like data fetched successfully")
                case .failure(let error):
                    completion(.failure(error))
                    print("couldn't fetch like data")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}

//MARK: - Logout

extension ImagesListService {
    func cleanPhotos() {
        self.photos = []
    }
}
