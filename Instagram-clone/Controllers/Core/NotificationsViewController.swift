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
        mockData()
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
            return cell
            
        case .like(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .comment(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
