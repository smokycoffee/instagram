//
//  ProfileViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let user: User
    
    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        
        configure()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showSignedOutIfNeeded()
//    }
//
//    private func showSignedOutIfNeeded() {
//        guard !AuthManager.shared.isSignedIn else {
//            return
//        }
//
//        // show signed out UI
//        let vc = SignInViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
//    }
    
    private func configure() {
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }

}
