//
//  SettingViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        createTableFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    // Mark: - TableView data
    
    private func createTableFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        
//        footer.snp.makeConstraints { make in
//            make.centerX.equalTo(view.width / 2)
//            make.height.equalTo(50)
//        }
        
        footer.clipsToBounds = true
        
        let button = UIButton(frame: footer.bounds)
//        button.snp.makeConstraints { make in
//            make.edges.equalTo(footer.bounds)
//        }
        footer.addSubview(button)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        tableView.tableFooterView = footer
        
    }
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Are you sure", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
