//
//  SearchResultsViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 22/3/23.
//

import UIKit
import SnapKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var users = [User]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with results: [User]) {
        self.users = results
        tableView.reloadData()
        tableView.isHidden = users.isEmpty

    }

    
    // tableviews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = users[indexPath.row].username
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsViewController(self, didSelectResultWith: users[indexPath.row])
    }
}
