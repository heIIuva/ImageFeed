//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by big stepper on 24/09/2024.
//

import Foundation


protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
}


final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Properties
    
    weak var view: ProfileViewControllerProtocol?
}
