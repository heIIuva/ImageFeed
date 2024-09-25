//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by big stepper on 25/09/2024.
//

import XCTest
@testable import ImageFeed


final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsViewDidDisappear() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidDisappear(true)
        
        //then
        XCTAssertTrue(presenter.viewDidDisappearCalled)

    }
    
    func testViewControllerUpdatesProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileInfo = ProfileResult(username: "Roma",
                                        firstName: "Roman",
                                        lastName: "Arbuzov",
                                        bio: "nigga")
        
        //when
        viewController.updateProfileInformation(profile: Profile(profileResult: profileInfo))
        var name: String { profileInfo.firstName + " " + (profileInfo.lastName ?? "") }
        
        //then
        XCTAssertEqual(profileInfo.username, viewController.profile?.username)
        XCTAssertEqual(name, viewController.profile?.name)
        XCTAssertEqual(profileInfo.bio, viewController.profile?.bio)
    }
    
    func testViewControllerUpdatesAvatar() {
        //given
        let viewController = ProfileViewController()
        let profilePicture = viewController.profileImageView?.image
        
        //when
        _ = viewController.view
        
        //
        XCTAssertEqual(profilePicture, UIImage(named: "avatarPlaceholder"))
    }
}


final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profile: Profile?
    
    func updateProfileInformation(profile: Profile) {
        self.profile = profile
    }
    
    func updateAvatar() {
        
    }
    
    func dismiss() {
        
    }
    
    
}


final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    var viewDidLoadCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
    }
    
    func didTapLogoutButton() {
        
    }
    
    
}
