//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by big stepper on 24/09/2024.
//

import Foundation
import Kingfisher


protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidDisappear()
    func didTapLogoutButton()
}


final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let storage = OAuth2Storage.shared
    private let logoutService = ProfileLogoutService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    //MARK: - Init
    
    init(alertPresenter: AlertPresenterProtocol) {
        self.alertPresenter = alertPresenter
    }
    
    //MARK: - Methods
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    func viewDidDisappear() {
        guard let profileImageServiceObserver else { return }
        NotificationCenter.default.removeObserver(profileImageServiceObserver)
    }
        
    func didTapLogoutButton() {
        let viewModel = AlertModel(title: "Пока, пока!",
                                   message: "Уверены что хотите выйти?",
                                   button: "Да",
                                   completion: { self.logoutService.logout() },
                                   secondButton: "Нет",
                                   secondCompletion: { self.view?.dismiss() })
        alertPresenter?.showAlert(result: viewModel)
    }
}
