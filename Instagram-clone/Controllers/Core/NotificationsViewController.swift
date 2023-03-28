//
//  NotificationsViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit
import SnapKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noActivityLabel: UILabel = {
       let label = UILabel()
        label.text = "No Nofications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var viewModels: [NotificationCellType] = []
    private var models: [IGNotification] = []
    
    // Mark: - Lifecycle
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = true
        table.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        table.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        table.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Notification"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(noActivityLabel)
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        noActivityLabel.sizeToFit()
        noActivityLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetchNotifications() {
        
        // api call to notifications manager to retrieve
        
        // noActivityLabel.isHidden = false
        NotificationsManager.shared.getNotifications { [weak self] models in
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
            }
        }
    }
    
    private func createViewModels() {
        models.forEach { model in
            guard let type = NotificationsManager.Types(rawValue: model.notificationType) else {
                return
            }
            
            let username = model.username
            guard let profilePictureURL = URL(string: model.profilePictureURL) else {
                return
            }
            
            switch type {
                
            case .like:
                guard let postURL = URL(string: model.postURL ?? "") else {
                    return
                }
                viewModels.append(.like(viewModel: LikeNotificationCellViewModel(username: username, profilePictureURL: profilePictureURL, postURL: postURL)))
            case .comment:
                guard let postURL = URL(string: model.postURL ?? "") else {
                    return
                }
                viewModels.append(.comment(viewModel: CommentNotificationCellViewModel(username: username, profilePictureURL: profilePictureURL, postURL: postURL)))
            case .follow:
                guard let isFollowing = model.isFollowing else {
                    return
                }
                viewModels.append(.follow(viewModel: FollowNotificationCellViewModel(username: username, profilePictureURL: profilePictureURL, isCurrentUserFollowing: isFollowing)))
            }
        }
        
        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func mockData() {
         tableView.isHidden = false
        
        guard let testUrl = URL(string: "https://i.pinimg.com/originals/c0/97/8c/c0978c0f0ac5fb1619687ab6bbb40dd7.jpg") else {
            return
        }
        
        viewModels = [
            .like(viewModel: LikeNotificationCellViewModel(username: "david", profilePictureURL: testUrl, postURL: testUrl)),
            .comment(viewModel: CommentNotificationCellViewModel(username: "smokycoffee", profilePictureURL: testUrl, postURL: testUrl)),
            .follow(viewModel: FollowNotificationCellViewModel(username: "Kevin", profilePictureURL: testUrl, isCurrentUserFollowing: true))
        ]
        tableView.reloadData()
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .follow(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .like(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .comment(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        let username: String
        switch cellType {
            
        case .follow(viewModel: let viewModel):
            username = viewModel.username
        case .like(viewModel: let viewModel):
            username = viewModel.username
        case .comment(viewModel: let viewModel):
            username = viewModel.username
        }
        
        // fix the function to use username (the below is for an em
        
        DatabaseManager.shared.findUser(with: username) { [weak self] user in
            guard let user = user else {
                return
            }
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

// MARK - Actions

extension NotificationsViewController: LikeNotificationTableViewCellDelegate, CommentNotificationTableViewCellDelegate, FollowNotificationTableViewCellDelegate {
    func followNotificationTableViewCell(_cel: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {
        let username = viewModel.username
//        DatabaseManager.shared.updateRelationship(state: isFollowing ? .follow : .unfollow, for: username) { success in
//
//        }
    }
    
    func likeNotificationTableViewCell(_cell: LikeNotificationTableViewCell, didTapPost viewModel: LikeNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
                
            case .follow, .comment:
                return false
            case .like(viewModel: let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
        openPost(with: index, username: viewModel.username)
        // find post by id from particular user
        
    }
    
    func commentNotificationTableViewCell(_cell: CommentNotificationTableViewCell, didTapPost viewModel: CommentNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
                
            case .like, .follow:
                return false
            case .comment(viewModel: let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
        openPost(with: index, username: viewModel.username)
    }
    
    
    func openPost(with index: Int, username: String) {
        print(index)
        
        guard index < models.count else {
            return
        }
        
        let model = models[index]
        let username = username
        guard let postID = model.postId else {
            return
        }
    }
}
