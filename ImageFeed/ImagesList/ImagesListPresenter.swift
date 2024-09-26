//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by big stepper on 23/09/2024.
//

import Foundation


protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidDisappear()
    func imagesListDidTapLike(_ cell: ImagesListCell)
    func tableViewWillDisplay(indexPath: IndexPath)
    func updateTableView()
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Properties
    
    private let imagesListService = ImagesListService.shared
    private let storage = OAuth2Storage.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    weak var view: ImagesListViewControllerProtocol?
    
    //MARK: - Init
    
    init(alertPresenter: AlertPresenterProtocol) {
        self.alertPresenter = alertPresenter
    }
    
    //MARK: - Methods
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
        }
    }
    
    func viewDidDisappear() {
        guard let imagesListServiceObserver else { return }
        NotificationCenter.default.removeObserver(imagesListServiceObserver)
    }
    
    func imagesListDidTapLike(_ cell: ImagesListCell) {
        guard let view else { return }
        guard let token = storage.token,
              let indexPath = view.tableView.indexPath(for: cell) else { return }
        let photo = view.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(token: token, photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let isLiked):
                view.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked: isLiked)
            case .failure(let error):
                let alert = AlertModel(title: "something went wrong",
                                       message: "check your internet connection\n\(error)",
                                       button: "try again"){}
                alertPresenter?.showAlert(result: alert)
            }
        }
    }
    
    func tableViewWillDisplay(indexPath: IndexPath) {
        guard let token = storage.token else { return }
        
        if indexPath.row + 1 == view?.photos.count {
            imagesListService.fetchPhotosNextPage(token: token)
        }
    }
    
    func updateTableView() {
        guard let token = storage.token else { return }
        
        imagesListService.fetchPhotosNextPage(token: token)
        view?.updateTableViewAnimated()
    }
}
