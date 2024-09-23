//
//  ViewController.swift
//  ImageFeed
//
//  Created by big stepper on 07/07/2024.
//

import UIKit
import Kingfisher


protocol imagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol { get set }
}


final class ImagesListViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.ypDark
        return tableView
    }()
    
    //MARK: - Properties
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private let storage = OAuth2Storage.shared
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var alertPresenter: AlertPresenterProtocol?
    private var photos: [Photo] = []

    private let dateFormatter = DateFormatter.dateFormatter
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        updateTableView()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarItem = UITabBarItem(title: "",
                                       image: UIImage(named: "tabEditorialActive"),
                                       selectedImage: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarItem = UITabBarItem(title: "",
                                       image: UIImage(named: "tabEditorialInactive"),
                                       selectedImage: nil)
        
        guard let imagesListServiceObserver else { return }
        NotificationCenter.default.removeObserver(imagesListServiceObserver)
    }
    
    private func showSingleImageViewController(indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        guard let imageURL = URL(string: photos[indexPath.row].largeImageURL) else { return }
        viewController.largeImageUrl = imageURL
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    private func updateTableView() {
        guard let token = storage.token else { return }
        
        imagesListService.fetchPhotosNextPage(token: token)
        updateTableViewAnimated()
    }
}

//MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier,for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        if cell.configCell(photo: photos[indexPath.row]) {
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let token = storage.token else { return }
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage(token: token)
        }
    }
}


extension ImagesListViewController {
    func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let oldCount = photos.count
            let newCount = imagesListService.photos.count
            photos = imagesListService.photos
            if oldCount != newCount {
                tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
}

//MARK: - Extensions

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSingleImageViewController(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let thumbImage = photos[indexPath.row].thumbSize
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImage.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImage.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let token = storage.token,
              let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(token: token, photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let isLiked):
                    self.photos[indexPath.row].isLiked = isLiked
                    cell.setIsLiked(isLiked: isLiked)
            case .failure(let error):
                let alert = AlertModel(title: "something went wrong",
                                       message: "check your internet connection\n\(error)",
                                       button: "try again"){}
                alertPresenter?.showAlert(result: alert)
            }
        }
    }
}
