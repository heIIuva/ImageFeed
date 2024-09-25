//
//  ViewController.swift
//  ImageFeed
//
//  Created by big stepper on 07/07/2024.
//

import UIKit
import Kingfisher


protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableView: UITableView! { get set }
    var photos: [Photo] { get set }
    func updateTableViewAnimated()
}


final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    //MARK: - Outlets
    
    @IBOutlet lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.ypDark
        return tableView
    }()
    
    //MARK: - Properties
        
    var presenter: ImagesListPresenterProtocol?
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    //MARK: - Init
    
    init(presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        updateTableView()
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
        presenter?.viewDidDisappear()
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
        presenter?.updateTableView()
    }
}

//MARK: - Extensions

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
        presenter?.tableViewWillDisplay(indexPath: indexPath)
    }
}


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
        presenter?.imagesListDidTapLike(cell)
    }
}
